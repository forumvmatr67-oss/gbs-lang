import sys
import os
import glob

class GBSInterpreter:
    def __init__(self):
        self.variables = {}
        self.lines = []
        self.pc = 0
        
    def run(self, filename):
        if not os.path.exists(filename):
            print(f"Error: File '{filename}' not found!")
            return False
        
        with open(filename, 'r', encoding='utf-8') as f:
            self.lines = [line.rstrip() for line in f.readlines()]
        
        print(f"\n=== Running {filename} ===\n")
        
        while self.pc < len(self.lines):
            line = self.lines[self.pc].strip()
            
            if not line or line.startswith('#'):
                self.pc += 1
                continue
            
            # print command
            if line.startswith('print '):
                content = line[6:].strip()
                if content.startswith('"') and content.endswith('"'):
                    print(content[1:-1])
                elif content in self.variables:
                    print(self.variables[content])
                else:
                    print(content)
            
            # set variable
            elif line.startswith('set '):
                parts = line[4:].split('=')
                if len(parts) == 2:
                    var = parts[0].strip()
                    val = parts[1].strip()
                    
                    if val.isdigit():
                        self.variables[var] = int(val)
                    elif val.startswith('"') and val.endswith('"'):
                        self.variables[var] = val[1:-1]
                    elif val in self.variables:
                        self.variables[var] = self.variables[val]
                    else:
                        self.variables[var] = val
                    
                    print(f"[DEBUG] {var} = {self.variables[var]}")
            
            # io.read()
            elif line == 'io.read()':
                user_input = input("> ")
                self.variables['last_input'] = user_input
            
            # if condition
            elif line.startswith('if '):
                condition = line[3:]
                if not self.eval_condition(condition):
                    # skip to endif
                    depth = 1
                    while self.pc < len(self.lines):
                        self.pc += 1
                        if self.pc >= len(self.lines):
                            break
                        next_line = self.lines[self.pc].strip()
                        if next_line.startswith('if '):
                            depth += 1
                        elif next_line == 'endif':
                            depth -= 1
                            if depth == 0:
                                break
            
            elif line == 'endif':
                pass
            
            # for loop
            elif line.startswith('for '):
                # for i = 1 to 10
                parts = line[4:].split()
                if len(parts) >= 5 and parts[1] == '=' and parts[3] == 'to':
                    var = parts[0]
                    start = int(parts[2])
                    end = int(parts[4])
                    
                    # execute loop
                    for value in range(start, end + 1):
                        self.variables[var] = value
                        # find end of loop
                        loop_end = self.find_loop_end(self.pc)
                        # execute body
                        self.execute_block(self.pc + 1, loop_end)
                    self.pc = loop_end
            
            elif line == 'end':
                pass
            
            else:
                # variable assignment without 'set'
                if '=' in line and not line.startswith('if'):
                    var, val = line.split('=', 1)
                    var = var.strip()
                    val = val.strip()
                    
                    if val.isdigit():
                        self.variables[var] = int(val)
                    elif val.startswith('"') and val.endswith('"'):
                        self.variables[var] = val[1:-1]
                    elif val in self.variables:
                        self.variables[var] = self.variables[val]
                    else:
                        self.variables[var] = val
            
            self.pc += 1
        
        print("\n=== Script finished ===")
        return True
    
    def find_loop_end(self, start_pos):
        depth = 1
        pos = start_pos
        while pos < len(self.lines):
            line = self.lines[pos].strip()
            if line.startswith('for '):
                depth += 1
            elif line == 'end':
                depth -= 1
                if depth == 0:
                    return pos
            pos += 1
        return pos
    
    def execute_block(self, start, end):
        saved_pc = self.pc
        self.pc = start
        while self.pc < end:
            line = self.lines[self.pc].strip()
            if line.startswith('print '):
                content = line[6:].strip()
                if content.startswith('"') and content.endswith('"'):
                    print(content[1:-1])
                elif content in self.variables:
                    print(self.variables[content])
            elif '=' in line and not line.startswith('if'):
                var, val = line.split('=', 1)
                var = var.strip()
                val = val.strip()
                if val.isdigit():
                    self.variables[var] = int(val)
                elif val in self.variables:
                    self.variables[var] = self.variables[val]
            self.pc += 1
        self.pc = saved_pc
    
    def eval_condition(self, condition):
        for op in ['==', '!=', '>=', '<=', '>', '<']:
            if op in condition:
                left, right = condition.split(op, 1)
                left = left.strip()
                right = right.strip()
                
                left_val = self.variables.get(left, left)
                right_val = self.variables.get(right, right)
                
                # convert to int if possible
                try:
                    left_val = int(left_val)
                except:
                    pass
                try:
                    right_val = int(right_val)
                except:
                    pass
                
                if op == '==':
                    return left_val == right_val
                elif op == '!=':
                    return left_val != right_val
                elif op == '>':
                    return left_val > right_val
                elif op == '<':
                    return left_val < right_val
                elif op == '>=':
                    return left_val >= right_val
                elif op == '<=':
                    return left_val <= right_val
        return False

def find_all_gbs_files():
    print("\n=== Searching for .gbs files ===\n")
    files = glob.glob('**/*.gbs', recursive=True)
    if not files:
        print("No .gbs files found!")
    else:
        print(f"Found {len(files)} file(s):")
        for f in files:
            size = os.path.getsize(f)
            print(f"  📄 {f} ({size} bytes)")
    return files

def create_new_script(name):
    filename = f"{name}.gbs" if not name.endswith('.gbs') else name
    template = f'''# {name}.gbs
# Created by GBS Language

print "Hello from {name}!"
print "==================="

# Variables
set username = "GBS User"
set age = 25
set pi = 3.14

# Output
print "Welcome, "
print username
print "Age: "
print age

# Input
print "What is your name?"
io.read()
set name_input = last_input
print "Hello, "
print name_input

# Conditions
set x = 10
set y = 20

if x < y
    print "x is less than y"
endif

# Loop
for i = 1 to 5
    print "Count: "
    print i
end

print "Done!"
'''
    
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(template)
    print(f"✅ Created: {filename}")
    return filename

def main():
    if len(sys.argv) < 2:
        print("GBS Language Interpreter")
        print("=" * 40)
        print("Commands:")
        print("  gbs.bat script.gbs     - run script")
        print("  python gbs.py find     - find all .gbs files")
        print("  python gbs.py create NAME - create new script")
        print("  python gbs.py --help   - show this help")
        return
    
    cmd = sys.argv[1]
    
    if cmd == 'find':
        find_all_gbs_files()
    
    elif cmd == 'create':
        if len(sys.argv) < 3:
            print("Usage: python gbs.py create NAME")
            return
        create_new_script(sys.argv[2])
    
    elif cmd == '--help' or cmd == '-h':
        print("GBS Language - Help")
        print("  run <file>   - execute GBS script")
        print("  find         - search for .gbs files")
        print("  create <name> - create new script")
        print("  --help       - show this help")
    
    elif cmd == 'run':
        if len(sys.argv) < 3:
            print("Usage: python gbs.py run script.gbs")
            return
        interpreter = GBSInterpreter()
        interpreter.run(sys.argv[2])
    
    else:
        # assume it's a filename
        interpreter = GBSInterpreter()
        interpreter.run(sys.argv[1])

if __name__ == '__main__':
    main()
