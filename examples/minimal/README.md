# Minimal example

Besides having a Kubernetes cluster ready-to-use (or that you need to deploy via Terraform), you need to provide the `S3` credentials and buckets to install this module. The file `main.tf` shows how to do it.

## Required permission

The `AWS permissions` that you need are simple. Apache Druid needs to be able to access the two buckets for storing/listing/getting/deleting the indexes and segments. An example of `IAM policy` is described here below

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::<s3-bucket-name-storage>",
                "arn:aws:s3:::<s3-bucket-name-index>",
                "arn:aws:s3:::<s3-bucket-name-storage>/*",
                "arn:aws:s3:::<s3-bucket-name-index>/*"
            ]
        }
    ]
}
```