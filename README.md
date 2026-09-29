# Spring PetClinic Infrastructure

## Simple Architecture

```text
GitHub Actions (Plan on PR, Apply after merge)
                     |
                     v
          Terraform remote state (S3)
          Locking (DynamoDB + S3 lockfile)
                     |
          +----------+-----------+
          |                      |
          v                      v
   EKS infrastructure       Optional add-ons
   VPC, IAM, KMS, EKS       Argo CD and/or Datadog
                                  |
                                  v
                         Optional ApplicationSet
                         external GitOps repository
```

```text
terraform/
  bootstrap/terraform-backend/  # one-time state lock/versioning setup
  environments/
    production/                 # VPC, IAM, KMS, EKS
    production-platform/        # Argo CD and Datadog after EKS exists
    production-gitops/          # optional ApplicationSet after Argo CD exists
  modules/
    networking/  iam/  kms/  eks/
    argocd/  datadog/  applicationset/

.github/workflows/
  terraform-plan.yml            # PR plan and PR comment
  terraform-apply.yml           # approved apply after merge
```

## What To Run

- To create the cluster: use `environments/production`.
- To install Argo CD and/or Datadog: use `environments/production-platform` after EKS is available. The `enable_argocd` and `enable_datadog` variables default to `false`, so the normal deployment creates EKS only. Set the GitHub repository variable `ENABLE_ARGOCD` or `ENABLE_DATADOG` to `true` to enable that add-on on a merge or manual workflow dispatch.
- To deploy applications through Argo CD: set both `ENABLE_ARGOCD=true` and `ENABLE_GITOPS=true`, and configure `APPLICATION_PATH_PATTERN`; this runs `environments/production-gitops` after the platform stage. It is not required to create EKS or install Argo CD/Datadog.
- The backend bootstrap is only for establishing DynamoDB locking and S3 versioning. It is not part of normal cluster or add-on changes after it has been applied.

The roots use separate S3 state keys because EKS must exist before Kubernetes/Helm providers can connect, and the ApplicationSet CRD must exist before Terraform can manage an ApplicationSet custom resource. This separation is only for dependency boundaries; the modules remain reusable.

## Safety And Configuration

- Terraform runs through the two GitHub Actions workflows using GitHub OIDC; do not run it from a developer workstation.
- The production AWS provider is restricted to account `992382771174` in `ap-south-1`.
- Set approved public EKS endpoint CIDRs and explicit cluster-admin role ARNs as GitHub repository variables. Do not use `0.0.0.0/0` for the public endpoint.
- `ENABLE_ARGOCD`, `ENABLE_DATADOG`, and `ENABLE_GITOPS` are optional GitHub repository variables and default to off.
- Keep an add-on flag enabled after Terraform starts managing that add-on. Changing it back to `false` removes the module from desired state and Terraform can plan to uninstall it; inspect the PR plan before merging.
- Store the Datadog API key as the GitHub Actions secret `DATADOG_API_KEY`. Apply writes it to a Kubernetes Secret; Terraform does not receive the key.
- The GitOps repository is external: `https://github.com/Hamza-Yousaf109/spring-petclinic-gitops.git`. Verify its manifest path before enabling the ApplicationSet.
- Review each PR plan. Apply is gated by the GitHub `production` environment and should have required reviewers configured.

The last read-only AWS inspection found the S3 state object encrypted but without versioning, no `petclinic-terraform-lock` table, and no PetClinic EKS cluster or named resources in the target account/region. No resources were changed. The first apply therefore needs the backend bootstrap and will create cost-bearing AWS infrastructure including EKS, NAT Gateway, EIP, and KMS resources.# spring-petclinic-infrastructure
