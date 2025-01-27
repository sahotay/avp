resource "helm_release" "argocd" {
  namespace        = "argocd"
  create_namespace = true
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"

  # Apply configurations from values file
  values = [file("${path.module}/templates/argo.yaml")]

  # Set admin password securely
  set_sensitive {
    name  = "configs.secret.argocdServerAdminPassword"
    value = local.admin_password != "" ? bcrypt(local.admin_password) : ""
  }

  # Enable insecure server access (for demo purposes)
  set {
    name  = "configs.params.server\\.insecure"
    value = true
  }
}
