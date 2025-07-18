# 02 - CI Setup: GitHub Actions for Terraform

This guide configures GitHub Actions to support Terraform workflows for all environments using short-lived AWS credentials via OpenID Connect (OIDC).

## CI Workflow Files

You should have two workflows in `.github/workflows/`:

- `terraform-ci.yml`: triggered on PRs and pushes with apply configured only for `main` branch
- `terraform-destroy.yml`: a manually triggered workflow (`workflow_dispatch`) that destroys all resources in the specified environment. Use with caution.

## GitHub Secrets

In your GitHub repo settings, define the following secrets:

- `TF_VAR_AWS_REGION` – AWS region (e.g., `us-east-1`)
- `TF_VAR_ROLE_TO_ASSUME` – The full ARN of the IAM role for GitHub Actions


## Notes
- Plans run on all branches to detect issues early.
- Applies only happen from `main` to avoid accidental changes.
- Backend config values are not stored in `.tf` files for security.
