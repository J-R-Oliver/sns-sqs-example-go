FROM golang:1.18.2 as build

WORKDIR /app

COPY . .

RUN CGO_ENABLED=0 go build -o health-check cmd/healthcheck/* &&\
    CGO_ENABLED=0 go build -o sns-sqs-example-go cmd/web/*

FROM gcr.io/distroless/static@sha256:2ad95019a0cbf07e0f917134f97dd859aaccc09258eb94edcb91674b3c1f448f

ARG BUILD_DATE

LABEL application="sns-sqs-example-go"
LABEL author="James Oliver"
LABEL description="Example backend service interacting with AWS SNS and SQS."
LABEL build-date=$BUILD_DATE

USER nonroot:nonroot

EXPOSE 8080
ENV PORT=8080

WORKDIR /app

COPY --from=build --chown=nonroot:nonroot --chmod=500 /app/health-check .

COPY --from=build --chown=nonroot:nonroot --chmod=500 /app/sns-sqs-example-go .

HEALTHCHECK --interval=25s --timeout=3s --retries=2 CMD ["./health-check"]

CMD ["/app/sns-sqs-example-go"]
