FROM golang:1.22-bookworm
ADD . app
WORKDIR app
RUN go mod init cmd/bash-exporter && go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o bash-exporter cmd/bash-exporter/bash-exporter.go

FROM alpine:3
WORKDIR /root/
COPY --from=0 /go/app/bash-exporter .
COPY ./examples/* /scripts/
CMD ["./bash-exporter"]
