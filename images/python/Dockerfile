FROM alpine:3.10

WORKDIR /app
COPY ./helloworld.py .

RUN apk add --no-cache python3 \
    && ln -s /usr/bin/pip3 /usr/local/bin/pip \
    && ln -s /usr/bin/pip3 /usr/bin/pip

CMD [ "python3", "/app/helloworld.py" ]
