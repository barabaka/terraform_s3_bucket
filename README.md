# Description

This module is used to create S3 bucket with specified policy and lifecycle rules. 
It will also create a KMS key (or use the existing one) to encrypt its contents.

# Setup terraform
`terraform init`

# Create policy file

Rename or copy policy.json.example to policy.json and adjust per your requirements.

# Input variables
*region* - AWS region  
*bucket_name* - S3 bucket name  
*policy_file* - file name with S3 bucket policy in JSON format  
*key_arn* (Optional) - Encryption key ARN. If not specified the new one will be created    
*ia_days* (Optional) - number of days to transition to "Infrequently Accessed" storage class, defaults to 10  
*glacier_days* (Optional) - number of days to transition to "Glacier" storage class, defaults to 20  

# Plan examples

Create new encryption key and provide custom number of days for infrequent-access transition policy:

```
terraform plan \
-var="bucket_name=oleg" \
-var="region=eu-central-1" \  
-var="policy_file=policy.json" \  
-var="ia_days=5"
```

Use existing encryption key and provide custom number of days for glacier transition policy:

```
teraform plan \
-var="bucket_name=oleg" \
-var="region=eu-central-1" \
-var="key_arn=arn:aws:kms:eu-west-1:291357997490:key/660c5800-3cc0-4361-a932-c55def078032" \
-var="policy_file=policy.json" \
-var="glacier_days=25"
```