FROM nginx:alpine

# Удаляем дефолтный конфиг
RUN rm /etc/nginx/conf.d/default.conf

# Устанавливаем fcgiwrap и утилиты
RUN apk add --no-cache fcgiwrap spawn-fcgi bash

# Создаем скрипт, который возвращает hostname и IP
RUN mkdir -p /usr/share/nginx/html && \
    echo '#!/bin/sh' > /usr/share/nginx/html/info.sh && \
    echo 'echo "Content-Type: text/plain"' >> /usr/share/nginx/html/info.sh && \
    echo 'echo ""' >> /usr/share/nginx/html/info.sh && \
    echo 'echo "Hostname: $(hostname)"' >> /usr/share/nginx/html/info.sh && \
    echo 'echo "IP: $(hostname -I | awk \x27{print $1}\x27)"' >> /usr/share/nginx/html/info.sh && \
    chmod +x /usr/share/nginx/html/info.sh

# Копируем конфиги nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY nginx2.conf /etc/nginx/nginx.conf

# Запускаем fcgiwrap и nginx
CMD spawn-fcgi -s /var/run/fcgiwrap.sock -M 766 /usr/bin/fcgiwrap && nginx -g 'daemon off;'

EXPOSE 8080
