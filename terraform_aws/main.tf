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