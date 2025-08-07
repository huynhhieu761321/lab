# GitOps Nginx Deployment with Jenkins & Argo CD

This project demonstrates a GitOps-style CI/CD pipeline that:

- Builds and pushes a custom Nginx Docker image
- Manages Kubernetes manifests with Kustomize for `dev`, `staging`, and `prod`
- Uses Argo CD to deploy apps declaratively to an EKS cluster
- Syncs changes via a Jenkins pipeline

---

## 🌐 Project Structure


LAB/
├── Dockerfile # Custom Nginx image
├── Jenkinsfile # Jenkins pipeline
├── apps/
│ ├── base/ # Shared K8s base config
│ ├── dev/ # Kustomize overlay for dev
│ ├── staging/ # Kustomize overlay for staging
│ └── prod/ # Kustomize overlay for prod
└── argocd-apps/ # Argo CD Application manifests