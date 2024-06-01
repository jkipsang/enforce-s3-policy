# Enforce S3 Bucket Policy

This repository provides a JSON policy file and a Bash script to enforce TLS 1.2 and secure requests on Amazon S3 buckets. The policy denies access to requests that do not meet the TLS 1.2 protocol and are not sent over HTTPS.
# JSON Policy File

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
