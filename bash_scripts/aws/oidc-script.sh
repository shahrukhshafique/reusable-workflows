#!/usr/bin/env bash
set -euo pipefail

ACCOUNT_ID="XXXXXXXXXXX"
ROLE_NAME="github-terraform-role"
TRUST_FILE="trust-github-terraform-role.json"
POLICY_FILE="policy-github-terraform-role.json"

echo "[INFO] Creating (or verifying) GitHub OIDC provider..."
if ! aws iam list-open-id-connect-providers --query "OpenIDConnectProviderList[?contains(Arn, 'token.actions.githubusercontent.com')].Arn" --output text | grep -q "oidc-provider/token.actions.githubusercontent.com"; then
  aws iam create-open-id-connect-provider \
    --url https://token.actions.githubusercontent.com \
    --client-id-list sts.amazonaws.com \
    --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1
else
  echo "[INFO] OIDC provider already exists."
fi

echo "[INFO] Checking trust file: $TRUST_FILE"
[ -f "$TRUST_FILE" ] || { echo "[ERROR] Missing $TRUST_FILE"; exit 1; }

echo "[INFO] Checking policy file: $POLICY_FILE"
[ -f "$POLICY_FILE" ] || { echo "[ERROR] Missing $POLICY_FILE"; exit 1; }

if aws iam get-role --role-name "$ROLE_NAME" >/dev/null 2>&1; then
  echo "[WARN] Role $ROLE_NAME already exists. Skipping creation."
else
  echo "[INFO] Creating role $ROLE_NAME ..."
  aws iam create-role \
    --role-name "$ROLE_NAME" \
    --assume-role-policy-document "file://$TRUST_FILE" \
    --max-session-duration 7200 \
    --description "Unified GitHub Terraform role"
fi

echo "[INFO] Attaching/Updating inline policy..."
aws iam put-role-policy \
  --role-name "$ROLE_NAME" \
  --policy-name "${ROLE_NAME}-inline" \
  --policy-document "file://$POLICY_FILE"

echo "[INFO] Tagging role..."
aws iam tag-role --role-name "$ROLE_NAME" --tags Key=Owner,Value=Platform Key=Purpose,Value=Terraform

echo "[INFO] Final role ARN:"
aws iam get-role --role-name "$ROLE_NAME" --query 'Role.Arn' --output text