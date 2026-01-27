#!/bin/bash

# Configuration
NAMESPACE="trusted-execution-clusters"
CM_NAME="image-pcrs"

NEW_ENTRY='{
  "conf": {
    "first_seen": "2026-01-23T07:41:01.246680554Z",
    "pcrs": [
      {
        "id": 4,
        "value": "974772cb9118cbf082487ed185cbe11f396ad6b8b764e5d361c15122f5bdb9cc",
        "parts": []
      },
      {
        "id": 14,
        "value": "cecf4f468c9b6d840d8161e29a40726c1e4f46c4329e9af3ec981bc85f74ed45",
        "parts": []
      }
    ],
    "reference": "manually-added"
  }
}'

echo "--- Fetching current ConfigMap... ---"
CURRENT_CONTENT=$(kubectl get cm "$CM_NAME" -n "$NAMESPACE" -o go-template='{{index .data "image-pcrs.json"}}')

if [ -z "$CURRENT_CONTENT" ]; then
    echo "Error: Could not fetch data. Check if ConfigMap exists."
    exit 1
fi

echo "--- Merging new values... ---"
UPDATED_CONTENT=$(echo "$CURRENT_CONTENT" | jq --argjson new "$NEW_ENTRY" '. + $new')

echo "--- Patching Kubernetes... ---"
PATCH_PAYLOAD=$(jq -n --arg data "$UPDATED_CONTENT" '{"data": {"image-pcrs.json": $data}}')

kubectl patch cm "$CM_NAME" -n "$NAMESPACE" --type=merge -p "$PATCH_PAYLOAD"
