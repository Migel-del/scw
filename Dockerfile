FROM nginx:alpine

# Удаляем дефолтный конфиг
RUN rm /etc/nginx/conf.d/default.conf

# Создаём простую страницу info с динамическими данными
RUN mkdir -p /usr/share/nginx/html && \
    echo 'Hostname: $HOSTNAME\nIP: $(hostname -i)\n' > /usr/share/nginx/html/info.template

# Копируем конфиги
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY nginx2.conf /etc/nginx/nginx.conf

# При старте подставляем реальные значения в info.html и запускаем nginx
CMD sh -c "echo \"Hostname: $(hostname)\" > /usr/share/nginx/html/info && \
            echo \"IP: $(hostname -i)\" >> /usr/share/nginx/html/info && \
            nginx -g 'daemon off;'"

EXPOSE 8080
