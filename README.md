# eks-mlops
A streamlined, security-aware, GitOps-based setup for provisioning and managing an EKS cluster using Terraform, GitHub Actions, and the AWS Well-Architected Framework as a guide.

---

## Step 1
### Environment Configuration (Required for Policy Generation and CI/CD)
This project expects sensitive configuration to be stored outside of version control. Local environment files (`env/*.env`) are used to generate IAM policies for each environment. GitHub Actions variables and secrets are required to securely execute Terraform in CI/CD in accordance with the AWS Well Architected Framework.

    ⚠️ Due to limitations in GitHub’s OIDC support for environment-level secrets (specifically, the inability to cleanly split read/write access by pull request vs main branch), this project does not use GitHub Environments. Instead, all secrets and variables are configured at the repository level under Settings → Secrets and Variables → Actions.

#### Required Setup Before You Can Generate Policies or Use CI
1. Local Environment Files
- Create a directory named `env/` in the project root
- Inside it, create a file named `.dev.env`
    - Use the provided `.local.env` file at the root as a reference
    - Be sure to define a valid `WRITE_ROLE_ARN` in this file before proceeding to `Step 2`
2. GitHub Repository Variables and Secrets
- Go to your repository’s Settings → Secrets and Variables → Actions
- These must be defined at the repository level — not as GitHub Environments — due to OIDC limitations
- Use `.github.env` in the root as a reference for required repository-level variables and secrets.

#### ⚠️ Environment File Warning
The `env/` directory and `.dev.env` file are intentionally excluded from version control via the `.gitignore` file.

These files are used for local development and policy generation only. They will contain sensitive data and must remain ignored by version control.

Ensure they remain ignored and are **never** committed to the repository.

Use `.local.env` as a safe, shareable **template** of the required variables for a successful deployment.

## Step 2
### Manual IAM Policy Generation and Setup
You must manually create an IAM role before generating policies or provisioning infrastructure. All `.*.env` variables need to have valid values. This role will be assumed by GitHub Actions and must include a trust relationship for OIDC as well as sufficient permissions to manage infrastructure via Terraform.

This project follows GitOps and AWS Well Architected Framework principles. As part of that, Terraform does not create its own permissions — it assumes them through a pre-provisioned IAM role.

#### Why This Is Needed
The official [Terraform AWS modules](https://github.com/terraform-aws-modules) require a role that:
- Already exists
- Has an [OIDC trust relationship](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html) with GitHub Actions
- Has sufficient permissions to create and manage other roles and policies (via Terraform)

To set this up securely, we generate the required trust, read, and write IAM policy documents ahead of time.

Policy Generation (after IAM Role Prerequisite)
1. Define your environment config in `env/.dev.env`.
2. Generate the rendered IAM policies:
```shell
make generate-policies
```
3. This fills in `*.tpl` templates in:
`terraform/modules/iam/templates/github_oidc_roles/`

    And outputs `*.json` files under:
`terraform/modules/iam/templates/generated/<env>/`

    Example output:
    ``` shell
    generated/dev/
    ├── read_permissions/
    │   ├── gh_ci_s3_read.json
    │   └── gh_ci_iam_read.json
    ├── write_permissions/
    │   ├── gh_ci_vpc_access.json
    │   └── gh_ci_cloudwatch_logs_access.json
    └── trust_permissions/
        └── gh_ci_role_trust_write.json
    ```
#### What You Must Manually Create in AWS
Using the generated `.json` files:
1. Update the initial IAM role (e.g., TerraformWriteRole) with:
    - A trust policy (`trust_permissions/*.json`) that allows GitHub OIDC authentication from your repo/environment.
2. Attach
    - Read policies (`read_permissions/*.json`) for non-destructive operations
    - Write policies (`write_permissions/*.json`) for provisioning infrastructure
3. Define this role ARN as `WRITE_ROLE_ARN` in your `env/.env` file so Terraform in GitHub Actions can assume it.
    - ⚠️ This bootstrapped role is required before any Terraform code can run successfully in CI/CD.

### 2. Format code
```bash
make format
```

### 3. Static analysis
```bash
make scan
```

---

## Git Tips
Branch Setup
```shell
    git checkout main && \
    git pull origin main && \
    git checkout -b init && \
    git merge main
```
- Configure a repository Github variable for `REPO_CAN_RUN_CI` to restrict access to who can run your Github actions.

Messaging
```
<type>(<scope>): <summary line>

<explanation of what changed and why, especially if fixing something broken>

```
---

## Remote State

Terraform uses an S3 backend with DynamoDB state locking. You must configure the values in the `terraform init` step of GitHub Actions based on the `env` values above.

---

## GitHub Actions Auth

This repo uses [OIDC](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html) to securely assume AWS roles without storing AWS credentials in GitHub.

---