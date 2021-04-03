#resource "kubernetes_namespace" "load-balancer" {
#  metadata {
#    name = var.namespace
#  }
#}
resource "kubernetes_namespace" "dev" {
  metadata {
    annotations = {
      name = "dev"
    }

    labels = {
      mylabel = "leo-dev"
    }

    name = "dev"
  }
}

resource "kubernetes_namespace" "uat" {
  metadata {
    annotations = {
      name = "uat"
    }

    labels = {
      mylabel = "leo-uat"
    }

    name = "uat"
  }
}

resource "kubernetes_namespace" "prod" {
  metadata {
    annotations = {
      name = "prod"
    }

    labels = {
      mylabel = "leo-prod"
    }

    name = "prod"
  }
}

resource "kubernetes_limit_range" "dev-lr" {
  metadata {
    name      = "cpu-limit-range"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }
  spec {
    limit {
      type = "PersistentVolumeClaim"
      max = {
        storage = "2Gi"
      }
      min = {
        storage = "1Gi"
      }
    }
    limit {
      type = "Container"
      default = {
        cpu    = "0.5"
        memory = "512Mi"
      }
      default_request = {
        cpu    = "0.25"
        memory = "256Mi"
      }
      max = {
        cpu    = "1"
        memory = "1Gi"
      }
      min = {
        cpu    = "10m"
        memory = "64Mi"
      }
    }
  }
}
resource "kubernetes_limit_range" "uat-lr" {
  metadata {
    name      = "cpu-limit-range"
    namespace = kubernetes_namespace.uat.metadata[0].name
  }
  spec {
    limit {
      type = "PersistentVolumeClaim"
      max = {
        storage = "4Gi"
      }
      min = {
        storage = "1Gi"
      }
    }
    limit {
      type = "Container"
      default = {
        cpu    = "0.5"
        memory = "512Mi"
      }
      default_request = {
        cpu    = "0.25"
        memory = "256Mi"
      }
      max = {
        cpu    = "1"
        memory = "1Gi"
      }
      min = {
        cpu    = "10m"
        memory = "64Mi"
      }
    }
  }
}
resource "kubernetes_limit_range" "prod-lr" {
  metadata {
    name      = "cpu-limit-range"
    namespace = kubernetes_namespace.prod.metadata[0].name
  }
  spec {
    limit {
      type = "PersistentVolumeClaim"
      max = {
        storage = "6Gi"
      }
      min = {
        storage = "1Gi"
      }
    }
    limit {
      type = "Container"
      default = {
        cpu    = "0.5"
        memory = "512Mi"
      }
      default_request = {
        cpu    = "0.25"
        memory = "256Mi"
      }
      max = {
        cpu    = "1"
        memory = "1Gi"
      }
      min = {
        cpu    = "10m"
        memory = "64Mi"
      }
    }
  }
}
resource "kubernetes_resource_quota" "dev-rq" {
  metadata {
    name = "leo-dev-rq"
  }
  spec {
    hard = {
      "requests.cpu"     = "1"
      "requests.memory"  = "1Gi"
      "limits.cpu"       = "1"
      "limits.memory"    = "2Gi"
      "requests.storage" = "10Gi"
    }
  }
}
resource "kubernetes_resource_quota" "uat-rq" {
  metadata {
    name = "leo-uat-rq"
  }
  spec {
    hard = {
      "requests.cpu"     = "2"
      "requests.memory"  = "2Gi"
      "limits.cpu"       = "4"
      "limits.memory"    = "4Gi"
      "requests.storage" = "15Gi"
    }
  }
}
resource "kubernetes_resource_quota" "prod-rq" {
  metadata {
    name = "leo-prod-rq"
  }
  spec {
    hard = {
      "requests.cpu"     = "4"
      "requests.memory"  = "4Gi"
      "limits.cpu"       = "8"
      "limits.memory"    = "6Gi"
      "requests.storage" = "20Gi"
    }
  }
}