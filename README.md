# eks-mlops
A streamlined, security-aware, GitOps-based setup for provisioning and managing an EKS cluster using Terraform, GitHub Actions, and the AWS Well-Architected Framework as a guide.

---

### 1. Environment Configuration (Local Use Only)
This project expects sensitive configuration to be stored outside of version control.
1. Create a directory named `env/` in the project root
2. Inside it, create a file named `.dev.env`.<br>
- You can use the provided `.example.env` file in the root as a reference for required variables.

#### ⚠️ Environment File Warning
The `env/` directory and `.dev.env` file are intentionally excluded from version control via the `.gitignore` file.

These files are for local development only for a successful deployment, will contain sensitive data.
Ensure they remain ignored and are **never** committed to the repository.

Use `env/.example.env` as a safe, shareable template of vairables required for a successful deployment.

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