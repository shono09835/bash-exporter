FROM golang:1.21-bullseye
ADD . app
WORKDIR app
RUN go mod init pkg/run && go mod tidy
WORKDIR cmd/bash-exporter
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o bash-exporter .

FROM alpine
WORKDIR /root/
COPY --from=0 /go/app/cmd/bash-exporter/bash-exporter .
COPY ./examples/* /scripts/
CMD ["./bash-exporter"]