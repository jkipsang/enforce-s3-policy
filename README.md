Enforce S3 Bucket Policy

This repository provides a JSON policy file and a Bash script to enforce TLS 1.2 and secure requests on Amazon S3 buckets. The policy denies access to requests that do not meet the TLS 1.2 protocol and are not sent over HTTPS.
JSON Policy File

The policy JSON file enforce-tls-12-requests-only.json contains statements that:

    Deny any S3 actions on the bucket and its objects if the TLS version is less than 1.2.
    Deny any S3 actions on the bucket and its objects if the request is not made over HTTPS.
```json

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowTLS12Only",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::YOUR_BUCKET_NAME/*",
                "arn:aws:s3:::YOUR_BUCKET_NAME"
            ],
            "Condition": {
                "NumericLessThan": {
                    "s3:TlsVersion": "1.2"
                }
            }
        },
        {
            "Sid": "AllowSSLRequestsOnly",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::YOUR_BUCKET_NAME/*",
                "arn:aws:s3:::YOUR_BUCKET_NAME"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}

Bash Script

The Bash script update-s3-policies.sh automates the process of applying the above policy to a list of S3 buckets. It iterates over a predefined list of buckets, updates the policy JSON with the specific bucket name, and applies the policy using the AWS CLI.
Prerequisites

    AWS CLI installed and configured with the necessary permissions.
    A list of S3 bucket names.
    The JSON policy template file (enforce-tls-12-requests-only.json).

Usage

    Clone the repository:

    sh

git clone https://github.com/your-repo/enforce-s3-policy.git
cd enforce-s3-policy

Edit the list of buckets:
Update the buckets array in update-s3-policies.sh with the names of your S3 buckets.

Run the script:

sh

    ./update-s3-policies.sh

Script Content

```bash

#!/bin/bash

# Define the list of buckets
buckets=("bucket1" "bucket2" "bucket3")

# Define the policy template and profile
policy_template="path/enforce-tls-12-requests-only.json"
policy_temp_file="/tmp/enforce-tls-12-requests-only.json"
profile="AWS Profile"

# Iterate over the buckets and apply the policy
for bucket in "${buckets[@]}"; do
  echo "Updating policy for bucket: $bucket"

  # Create a temporary policy file for the current bucket
  sed "s/YOUR_BUCKET_NAME/$bucket/g" "$policy_template" > "$policy_temp_file"

  aws s3api put-bucket-policy --bucket "$bucket" --policy file://"$policy_temp_file" --profile "$profile"

  if [ $? -eq 0 ]; then
    echo "Successfully updated policy for bucket: $bucket"
  else
    echo "Failed to update policy for bucket: $bucket" >&2
  fi
done

# Clean up temporary file
rm "$policy_temp_file"

echo "Policy update process completed."



#Notes

    Ensure the AWS CLI is configured with a profile that has the necessary permissions to update bucket policies.
    The script replaces the placeholder YOUR_BUCKET_NAME in the policy template with each bucket name.
    The temporary policy file is created in /tmp and is cleaned up after the script runs.

#Contributing

Feel free to submit issues or pull requests if you find any bugs or have suggestions for improvements.
#License
This project is licensed under the MIT License. See the LICENSE file for details.
