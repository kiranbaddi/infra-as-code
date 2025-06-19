# Infrastructure As Code


## Motivation

- Create Modules for Resources across multiple Cloud Providers


## AWS


- [Setup Authentication with GitHub](https://aws.amazon.com/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/)


1. Go to https://token.actions.githubusercontent.com/.well-known/openid-configuration
2. Get the jwks URL (ex: https://token.actions.githubusercontent.com/.well-known/openid-configuration)
3. # Replace 'token.actions.githubusercontent.com' with the actual host from jwks_uri if different

```bash
echo | openssl s_client -servername token.actions.githubusercontent.com -showcerts -connect token.actions.githubusercontent.com:443 2>&1 | \
sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' | \
openssl x509 -noout -fingerprint | \
cut -d'=' -f2 | tr -d ':' | tr '[:upper:]' '[:lower:]'
```


Create ODIC Proiver in AWS

```bash
aws iam create-open-id-connect-provider ‐‐url  https://token.actions.githubusercontent.com ‐‐thumbprint-list "7560d6f40fa55195f740ee2b1b7c0b4836cbe103" ‐‐client-id-list 'sts.amazonaws.com'

```

Verify if the provider is created 

```bash
aws iam list-open-id-connect-providers
```

Copy the ARN.

4. Assign Role to ODIC



```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "<arn:aws:iam::111122223333:oidc-provider/token.actions.githubusercontent.com>"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:sub": "repo: <aws-samples/EXAMPLEREPO>:ref:refs/heads/<ExampleBranch>",
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                }
            }
        }
    ]
}
```



aws iam create-role --role-name GitHubAction-AssumeRoleWithAction --assume-role-policy-document file://<file_location>