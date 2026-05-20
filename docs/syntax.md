```markdown
# GBS Language Syntax Guide

## 📖 Переменные

```gbs
set name = "John"
set age = 25
set pi = 3.14
```

## 📤 Вывод на экран

```gbs
print "Hello World"
print variable_name
```

## 📥 Ввод с клавиатуры

```gbs
io.read()
set user_input = %GBS_INPUT%
```

## 🔀 Условные операторы

```gbs
if age >= 18
    print "Adult"
else
    print "Child"
end
```

## 🔢 Операторы сравнения

| Оператор | Значение |
|----------|----------|
| `==` | равно |
| `!=` | не равно |
| `>` | больше |
| `<` | меньше |
| `>=` | больше или равно |
| `<=` | меньше или равно |

## 💬 Комментарии

```gbs
# Это однострочный комментарий
```

## 📝 Пример программы

```gbs
# Проверка возраста

print "Enter your age: "
io.read()
set age = %GBS_INPUT%

if age >= 18
    print "You are adult"
    print "You can vote!"
else
    print "You are child"
    print "You cannot vote"
end
```

## 🎮 Игра "Угадай число"

```gbs
set secret = 42
set guess = 0

while guess != secret
    print "Guess: "
    io.read()
    set guess = %GBS_INPUT%
    
    if guess > secret
        print "Too high!"
    elseif guess < secret
        print "Too low!"
    end
end

print "You win!"
```
```
