#!/bin/bash

# Create OIDC Provider and get the provider ARN

# aws iam create-open-id-connect-provider ‐‐url  https://token.actions.githubusercontent.com ‐‐thumbprint-list "7560d6f40fa55195f740ee2b1b7c0b4836cbe103" ‐‐client-id-list 'sts.amazonaws.com'



STATE_BUCKET="terraform-state-$(echo $RANDOM)"
echo $STATE_BUCKET
REGION="eu-central-1"
echo $REGION

aws s3api create-bucket --bucket $STATE_BUCKET --region "us-east-1"
aws s3api put-bucket-versioning --bucket $STATE_BUCKET --versioning-configuration Status=Enabled
aws s3api put-bucket-encryption --bucket $STATE_BUCKET --server-side-encryption-configuration '{
    "Rules": [
        {
            "ApplyServerSideEncryptionByDefault": {
                "SSEAlgorithm": "AES256"
            }
        }
    ]
}'

# aws dynamodb create-table \
#     --table-name terraform-lock-db \
#     --attribute-definitions AttributeName=LockID,AttributeType=S \
#     --key-schema AttributeName=LockID,KeyType=HASH \
#     --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
#     --region $REGION
