# eks-mlops-blueprint
Minimal 3-layer Terraform layout with GitHub Actions CI.

---

## Local Setup

### 1. Create your `.env` file
At the root of the repo:
```env
AWS_REGION=your_aws_region
```
This file is ignored via `.gitignore`.

### 2. Format code
```bash
make format
```

> Note: Only `format` is supported locally to avoid state conflicts. Full init/plan/apply is handled via GitHub Actions.

---

## CI/CD and Deployment Flow

1. Start by following the manual setup steps in [docs/01-bootstrap.md](./docs/01-bootstrap.md)
2. Configure GitHub Actions as shown in [docs/02-ci-setup.md](./docs/02-ci-setup.md)
3. Use PRs to trigger Terraform plans. Merges to `main` trigger `apply`.

---

## Git Tips
```shell
    git checkout main && \
    git pull origin main && \
    git checkout -b init && \
    git merge main
```
---

## Structure

- `terraform/composition`: Top-level env-specific orchestration
- `terraform/infrastructure_modules`: Composable units like networking
- `terraform/policies/iam_templates`: IAM policy definition templates for CI access
- `Makefile`: Format helper (Docker-based)
- `.github/workflows`: GitHub Actions CI pipelines

---

## Remote State

Terraform uses an S3 backend with DynamoDB state locking. You must configure the values in the `terraform init` step of GitHub Actions. See [01-bootstrap.md](./docs/01-bootstrap.md).

---

## GitHub Actions Auth

This repo uses [OIDC](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html) to securely assume AWS roles without storing AWS credentials in GitHub.

---