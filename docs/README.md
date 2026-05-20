# 📘 **Инструкция по GBS (кратко)**

## Установка

```cmd
1. Создайте папку C:\GBS
2. Сохраните GBS.BAT (интерпретатор)
3. Сохраните скрипты с расширением .gbs
```

## Запуск

```cmd
GBS.BAT script.gbs
```

## Команды

```gbs
print "text"          # Вывод
io.read()             # Ввод
set x = 5             # Переменная
# comment             # Комментарий
```

## Пример

```gbs
print "Your name?"
io.read()
set name = %GBS_INPUT%
print "Hello "
print name
```

## Готово! 🚀
