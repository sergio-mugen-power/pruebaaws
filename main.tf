provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "sergiosl-bucket"

  tags = {
    Name        = "sergiobucket"
    Environment = "Dev"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.my_bucket.bucket
}
