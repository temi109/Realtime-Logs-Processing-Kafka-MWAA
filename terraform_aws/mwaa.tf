## IAM

data "aws_iam_policy_document" "mwaa_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["airflow.amazonaws.com", "airflow-env.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "mwaa_role" {
  name               = "mwaa-execution-role"
  assume_role_policy = data.aws_iam_policy_document.mwaa_assume_role.json
}


resource "aws_iam_role_policy" "mwaa_policy" {
  role = aws_iam_role.mwaa_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject*",
          "s3:GetBucket*",
          "s3:List*"
        ],
        Resource = [
          aws_s3_bucket.mwaa_sync_bucket.arn,
          "${aws_s3_bucket.mwaa_sync_bucket.arn}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:*"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource = "*"
      }
    ]
  })
}

## VPC AND NETWORKING

data "aws_availability_zones" "available" {}

locals {
  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "data-vpc"
  cidr = local.cidr

  azs             = local.azs
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.cidr, 8, k + 48)]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.cidr, 4, k)]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "aws_mwaa" = "1"
  }

  private_subnet_tags = {
    "aws_mwaa" = "1"
  }
}



## Security Group

resource "aws_security_group" "mwaa" {
  name   = "mwaa-sg"
  vpc_id = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "aws_mwaa_environment" "airflow" {
#   name               = "td-airflow"
#   airflow_version    = "3.0.6"
#   execution_role_arn = aws_iam_role.mwaa_role.arn

#   source_bucket_arn = aws_s3_bucket.mwaa_sync_bucket.arn
#   dag_s3_path       = "project025/dags"

#   network_configuration {
#     security_group_ids = [aws_security_group.mwaa.id]
#     subnet_ids = module.vpc.private_subnets
#   }

#   environment_class = "mw1.micro"

#   logging_configuration {
#     scheduler_logs {
#         enabled   = true
#         log_level = "INFO"
#     }

#     worker_logs {
#         enabled   = true
#         log_level = "INFO"
#     }

#     task_logs {
#         enabled   = true
#         log_level = "INFO"
#     }

#     webserver_logs {
#         enabled   = true
#         log_level = "INFO"
#     }
#     dag_processing_logs {
#         enabled   = true
#         log_level = "INFO"
#     }
#   }
#   min_workers                 = 1
#   max_workers                 = 1

#   depends_on = [aws_iam_role_policy.mwaa_policy, aws_s3_bucket.mwaa_sync_bucket, aws_security_group.mwaa]
# }