# AWS OIDC Scripts

### Setup
1. Make it executable again if you overwrite it:
   ```bash
   chmod +x oidc-script.sh
   ```

2. Run:
   ```bash
   bash oidc-script.sh
   ```

3. Verify OIDC Provider:
   ```bash
   aws iam list-open-id-connect-providers
   ```

4. Verify Role Exists:
   ```bash
   aws iam get-role --role-name github-terraform-role
   aws iam get-role --role-name github-terraform-role --query 'Role.Arn' --output text
   ```
---

### Set GitHub Secret

Copy the ARN from the get-role output and in your GitHub repo:

Secret name: ASSUME_ROLE_ARN
Value: arn:aws:iam::XXXXXXXXX:role/github-terraform-role