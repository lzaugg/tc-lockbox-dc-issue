# from https://lipanski.com/posts/smallest-docker-image-static-website
FROM busybox:1.36

RUN adduser -D static
USER static
WORKDIR /home/static

COPY static/ .

CMD ["busybox", "httpd", "-f", "-v", "-p", "3000"]