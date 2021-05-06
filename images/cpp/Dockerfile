FROM alpine:3.10

WORKDIR /app
COPY ./hello-world.cpp .

RUN apk add --no-cache g++ build-base && \
    g++ -pie -o hello-world hello-world.cpp

CMD ["/app/hello-world"]
