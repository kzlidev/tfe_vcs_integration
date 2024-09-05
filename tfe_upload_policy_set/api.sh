#!/bin/bash

# https://developer.hashicorp.com/terraform/enterprise/api-docs/policy-sets#create-a-policy-set

# Token must have permission to manage VCS Settings
export TFE_TOKEN=""
export TFE_ORG=""

# Create a new policy set
curl \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data @payload.json \
  https://app.terraform.io/api/v2/organizations/$TFE_ORG/policy-sets > response.json

# Retrieve the policy set id
export POLICY_SET_ID=$(jq -r '.data.id' response.json)

# Create a new policy set version
curl \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  https://app.terraform.io/api/v2/policy-sets/$POLICY_SET_ID/versions > response.json

# The upload URL is for uploading the actual policies
export UPLOAD_URL=$(jq -r '.data.links.upload' response.json)

# Zip up the module using tar
# The sentinel.hcl file should be in the root directory (not in a subdirectory)
tar zcvf policy-set.tar.gz -C "./sentinel/" .

curl \
  --header "Content-Type: application/octet-stream" \
  --request PUT \
  --data-binary @policy-set.tar.gz \
  $UPLOAD_URL
