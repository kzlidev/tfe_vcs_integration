#!/bin/bash

# https://developer.hashicorp.com/terraform/enterprise/api-docs/oauth-clients#create-an-oauth-client

# Token must have permission to manage VCS Settings
export TFE_TOKEN="<TFE_TOKEN>"
export TFE_ORG="likz"

curl \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data @payload.json \
  --insecure \
  https://tfe.kz-li.sbx.hashidemos.io/api/v2/organizations/$TFE_ORG/oauth-clients
