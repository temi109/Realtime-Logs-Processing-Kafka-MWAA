terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}


provider "aws" {
  region = "eu-west-2"
}

## AWS Secrets Manager resources to store sensitive information for Kafka and Elasticsearch connections

resource "aws_secretsmanager_secret" "mwaa_kafka_elasticsearch_credentials" {
  name = "mwaa_kafka_elasticsearch_credentials"
  description = "Kafka and Elasticsearch credentials for MWAA environment"
}


resource "aws_secretsmanager_secret_version" "mwaa_kafka_elasticsearch_credentials_value" {
  secret_id = aws_secretsmanager_secret.mwaa_kafka_elasticsearch_credentials.id

  secret_string = jsonencode({
    KAFKA_SASL_USERNAME = var.KAFKA_SASL_USERNAME
    KAFKA_SASL_PASSWORD = var.KAFKA_SASL_PASSWORD
    KAFKA_BOOTSTRAP_SERVER = var.KAFKA_BOOTSTRAP_SERVER
    ELASTICSEARCH_ENDPOINT = var.ELASTICSEARCH_ENDPOINT
    ELASTICSEARCH_API_KEY = var.ELASTICSEARCH_API_KEY
  })
}

## MwAA S3 Sync Bucket resources to store DAGs and plugins for the MWAA environment

resource "aws_s3_bucket" "mwaa_sync_bucket" {
    bucket = "ti-mwaa-sync-bucket"
    tags = {
    Name        = "mwaa-sync-Bucket"
    Environment = "Prod"
    }

    force_destroy = true
}

resource "aws_s3_object" "mwaa_sync_bucket_folder" {
 
  bucket = aws_s3_bucket.mwaa_sync_bucket.id
  key    = "project025/"

  content = ""
}

resource "aws_s3_bucket_versioning" "mwaa_sync_bucket_versioning" {
  bucket = aws_s3_bucket.mwaa_sync_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "mwaa_sync_bucket_sse" {
  bucket = aws_s3_bucket.mwaa_sync_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "mwaa_sync_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.mwaa_sync_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

