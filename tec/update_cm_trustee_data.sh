#!/bin/bash

# Configuration
NAMESPACE="trusted-execution-clusters"
CM_NAME="trustee-data"

# Values to add
VAL_PCR4="974772cb9118cbf082487ed185cbe11f396ad6b8b764e5d361c15122f5bdb9cc"
VAL_PCR14="cecf4f468c9b6d840d8161e29a40726c1e4f46c4329e9af3ec981bc85f74ed45"

echo "Fetching and patching ConfigMap '$CM_NAME' in namespace '$NAMESPACE'..."

kubectl get cm "$CM_NAME" -n "$NAMESPACE" -o json | \
jq --arg val4 "$VAL_PCR4" --arg val14 "$VAL_PCR14" '
  .data["reference-values.json"] |= (
    fromjson | 
    map(
      if .name == "tpm_pcr4" then 
        .value = (.value + [$val4] | unique)
      elif .name == "tpm_pcr14" then 
        .value = (.value + [$val14] | unique)
      else 
        . 
      end
    ) | 
    tojson
  )
' | kubectl apply -f -

echo "Done. ConfigMap updated."
