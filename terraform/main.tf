terraform {
  backend "s3" {
    region         = "us-east-1"
    key            = "resource-watch-manager.tfstate"
    dynamodb_table = "aws-locks"
    encrypt        = true
  }
}
# import core state
data "terraform_remote_state" "core" {
  backend = "s3"
  config = {
    bucket = local.tf_state_bucket
    region = "us-east-1"
    key    = "core.tfstate"
  }
}
# some local
locals {
  bucket_suffix      = var.environment == "production" ? "" : "-${var.environment}"
  tf_state_bucket    = "wri-api-terraform${local.bucket_suffix}"
  tags               = data.terraform_remote_state.core.outputs.tags
  name_suffix        = terraform.workspace == "default" ? "" : "-${terraform.workspace}"
  project            = "resource-watch-manager"
  create_db_sql      = "SELECT 'CREATE DATABASE ${var.database}' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '${var.database}')\\gexec"
  drop_db_sql        = "DROP DATABASE IF EXISTS ${var.database};"
  create_role_sql    = "DO $body BEGIN CREATE ROLE ${var.user_name} LOGIN PASSWORD '${var.password}'; EXCEPTION WHEN others THEN RAISE NOTICE '${var.user_name} role exists, not re-creating'; END $body$"
  drop_role_sql      = "DROP ROLE IF EXISTS ${var.user_name};"
  superuser          = jsondecode(data.terraform_remote_state.core.outputs.postgres_writer_secret_string)["username"]
  superuser_password = jsondecode(data.terraform_remote_state.core.outputs.postgres_writer_secret_string)["password"]
  host               = jsondecode(data.terraform_remote_state.core.outputs.postgres_writer_secret_string)["host"]
  port               = jsondecode(data.terraform_remote_state.core.outputs.postgres_writer_secret_string)["port"]
}



resource "null_resource" "database" {
  # Changes to username, password or database triggers provisioner
  triggers = {
    role     = var.user_name
    password = var.password
    database = var.database
  }

  connection {
    host = data.terraform_remote_state.core.outputs.bastion_dns
    user = "ubuntu"
    private_key = "~/.certificates/tmaschler_gfw.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "PGPASSWORD=${local.superuser_password} psql -h ${local.host} -p ${local.port} -U ${local.superuser} -c ${local.create_db_sql}",
      "PGPASSWORD=${local.superuser_password} psql -h ${local.host} -p ${local.port} -U ${local.superuser} -c ${local.create_role_sql}",
    ]
  }

  provisioner "remote-exec" {
    when    = destroy
    inline = [
      "PGPASSWORD=${local.superuser_password} psql -h ${local.host} -p ${local.port} -U ${local.superuser} -c ${local.drop_db_sql}",
      "PGPASSWORD=${local.superuser_password} psql -h ${local.host} -p ${local.port} -U ${local.superuser} -c ${local.drop_role_sql}",
    ]
  }
}