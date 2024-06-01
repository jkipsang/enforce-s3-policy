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
