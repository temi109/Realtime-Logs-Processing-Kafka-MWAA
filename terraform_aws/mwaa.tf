# module "mwaa" {
#   source = "../.."

#   name              = var.name
#   airflow_version   = "3.1.7"
#   environment_class = "mw1.medium"
#   create_s3_bucket  = false
#   source_bucket_arn = aws_s3_bucket.mwaa_sync_bucket.arn
#   dag_s3_path       = "project025/dags"
#   requirements_s3_path = "project025/requirements.txt"