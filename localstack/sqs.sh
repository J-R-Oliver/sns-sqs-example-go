#!/bin/bash

awslocal sqs create-queue --queue-name example-go-request
SUBSCRIPTION_ARN=$(awslocal sns subscribe --protocol sqs --topic-arn arn:aws:sns:eu-west-2:000000000000:example-go-request --notification-endpoint arn:aws:sqs:eu-west-2:000000000000:example-go-request --query 'SubscriptionArn' --output text)
awslocal sns get-subscription-attributes --subscription-arn "$SUBSCRIPTION_ARN"

awslocal sqs create-queue --queue-name example-go-response
SUBSCRIPTION_ARN=$(awslocal sns subscribe --protocol sqs --topic-arn arn:aws:sns:eu-west-2:000000000000:example-go-response --notification-endpoint arn:aws:sqs:eu-west-2:000000000000:example-go-response --query 'SubscriptionArn' --output text)
awslocal sns get-subscription-attributes --subscription-arn "$SUBSCRIPTION_ARN"
