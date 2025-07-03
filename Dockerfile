# Используем официальный образ Python как базовый
FROM python:3.11-slim

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файлы проекта в контейнер
COPY . /app

# Устанавливаем зависимости
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Копируем пример env, если .env не существует
RUN if [ ! -f .env ]; then cp example.env .env; fi

# Устанавливаем cron
RUN apt-get update && apt-get install -y cron && rm -rf /var/lib/apt/lists/*

# Копируем crontab файл
COPY crontab /etc/cron.d/telegram_poster_cron

# Даем права на выполнение cron файла
RUN chmod 0644 /etc/cron.d/telegram_poster_cron

# Добавляем логи
RUN touch /var/log/telegram_poster.log

# Применяем cron задания
RUN crontab /etc/cron.d/telegram_poster_cron

# Запускаем cron в форграунде
CMD ["cron", "-f"]
