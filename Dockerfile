FROM golang:1.21-bullseye
ADD . app
WORKDIR app
RUN go mod init cmd/bash-exporter && go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o bash-exporter cmd/bash-exporter/bash-exporter.go

FROM alpine
WORKDIR /root/
COPY --from=0 /go/app/bash-exporter .
COPY ./examples/* /scripts/
CMD ["./bash-exporter"]