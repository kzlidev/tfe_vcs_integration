#!/bin/bash

# https://developer.hashicorp.com/terraform/enterprise/api-docs/private-registry/modules#create-a-module-with-no-vcs-connection

# Token must belong to a team or team member with the Manage modules permission enabled.
export TFE_TOKEN=""
export TFE_ORG=""

# List the modules in the private registry
curl \
  --request GET \
  --header "Authorization: Bearer $TFE_TOKEN" \
  https://app.terraform.io/api/v2/organizations/$TFE_ORG/registry-modules


# Create a new module in the private registry
curl \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data @01-private-module-payload.json \
  https://app.terraform.io/api/v2/organizations/$TFE_ORG/registry-modules

# Create a new module version in the private registry
curl \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data @02-private-module-version-payload.json \
  https://app.terraform.io/api/v2/organizations/$TFE_ORG/registry-modules/private/$TFE_ORG/my-module/aws/versions > response.json

# The upload URL is for uploading the actual module
export UPLOAD_URL=$(jq -r '.data.links.upload' response.json)

# Zip up the module using tar
# The module name is the one that is given in 01-private-module-payload.json
# The module tf files should be in the root directory (not in a subdirectory)
tar zcvf module.tar.gz -C "./terraform-aws-s3/" .

# Upload the module
curl \
  --header "Content-Type: application/octet-stream" \
  --request PUT \
  --data-binary @module.tar.gz \
  $UPLOAD_URL
