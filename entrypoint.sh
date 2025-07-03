#!/bin/sh
# entrypoint.sh: Генерирует crontab из шаблона с учетом переменной окружения CRON_SCHEDULE

: "${CRON_SCHEDULE:=*/30 * * * *}" # Значение по умолчанию, если не задано

# Подставляем расписание в шаблон и сохраняем итоговый crontab
sed "s|{{CRON_SCHEDULE}}|$CRON_SCHEDULE|g" /app/crontab.template > /etc/cron.d/telegram_poster_cron
chmod 0644 /etc/cron.d/telegram_poster_cron

# Применяем crontab
crontab /etc/cron.d/telegram_poster_cron

touch /var/log/telegram_poster.log

# Запускаем cron в foreground
exec cron -f
