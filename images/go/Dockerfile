FROM golang:1-alpine

WORKDIR /app
COPY ./hello-world.go .

RUN apk add --no-cache gcc build-base gcc-go && \
    go mod init hello-world && \
    go build -compiler=gccgo -buildmode=exe
CMD [ "/app/hello-world" ]