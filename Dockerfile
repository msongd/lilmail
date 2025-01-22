FROM golang:latest AS go

ARG APP_NAME="LittleMail"
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
ENV APP_NAME $APP_NAME

ADD . /src

ARG LDFLAGS=""

WORKDIR /src
RUN mkdir -p /app/cache /app/sessions && \
    cp -R /src/templates /app && \
    find /app/templates -type f -name '*.html' -exec sed -i -E "s/[Ll]il[Mm]ail/${APP_NAME}/g" {} \; && \
    cp /src/config.toml /app && \
    chown -R nobody:nogroup /app
RUN CGO_ENABLED=0 GOOS=linux go build -v -o /go/bin/app .

FROM alpine:3.21
RUN apk add --no-cache openssl
COPY --from=go /go/bin/app /usr/bin/app
COPY --from=go /app /app
COPY --from=go /src/config.toml /app
WORKDIR /app
USER nobody
ENTRYPOINT ["/usr/bin/app"]
