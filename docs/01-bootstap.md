# 01 - Bootstrap: Manual Setup Requirements

These are one-time setup steps required before using this repository in any environment (`<env>` = `dev`, `prod`, etc).

As a starting point, you will need to manual configure the required field in the `terraform init` within the `.github/workflows/*` and ensure they are configured as secrets in github.

```yaml
- name: Terraform Init
  run: |
    terraform init \
      -backend-config="bucket=${{ secrets.TF_VAR_S3_BUCKET_NAME }}" \
      -backend-config="key=${{ secrets.TF_VAR_S3_BUCKET_KEY }}" \
      -backend-config="region=${{ secrets.TF_VAR_AWS_REGION }}" \
      -backend-config="encrypt=true" \
      -backend-config="dynamodb_table=${{ secrets.TF_VAR_DYNAMODB_TABLE_NAME }}"
```

## 1. Create the S3 bucket for remote state
Name: `${{ secrets.TF_VAR_S3_BUCKET_NAME }}`

## 2. Create the DynamoDB table for state locking
Name: `${{ secrets.TF_VAR_DYNAMODB_TABLE_NAME }}`

## 3. Create three policies for S3, DynamoDB, and VPC
Configure your `.env` file in the root of the directory (make sure it is in the .gitignore too).
```shell
AWS_ACCOUNT_ID=
AWS_REGION=
S3_BUCKET_NAME=
S3_BUCKET_KEY=
S3_ACCESS_SID=
DYNAMODB_TABLE_NAME=
DYNAMODB_ACCESS_SID=
VPC_ACCESS_SID=
```
The run `terraform/policies/generate_policies.sh` to create the necesssary policies for Github to leverage via aws role. See below cor configuring the role.

##
## 4. GitHub Actions OIDC Role Setup

This project uses **GitHub Actions with OpenID Connect (OIDC)** to securely assume an AWS IAM role **without long-lived secrets**. This follows AWS and GitHub's recommended best practices for CI pipelines.

### Why we use this
- **No AWS secrets** are stored in GitHub.
- The IAM role is only assumable from this repo and branch (`main`).
- The setup can be extended to allow different permissions per environment or workflow.

### How it works
GitHub Actions automatically requests a short-lived token from its OIDC provider, which AWS uses to authenticate and authorize the CI workflow to assume a specific IAM role.

### AWS Documentation
- [Using OpenID Connect with GitHub Actions](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html#oidc-github)
- [Configure the OIDC trust relationship](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html#oidc-create-role-console)
- [GitHub Actions – OIDC Token Format](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect#token-format)

## 5. Configure Role/Policies/Trust Relationship
Leverage the three policies and apply them to the Role you create and within the Trust Relationship of the Role, give access to your Github user/org and repo.