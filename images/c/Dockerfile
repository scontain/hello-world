FROM alpine:3.10

WORKDIR /app
COPY ./hello-world.c .

RUN apk add --no-cache gcc build-base && \
    cc -pie -o hello-world hello-world.c

CMD [ "/app/hello-world" ]
