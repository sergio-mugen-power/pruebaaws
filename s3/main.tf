resource "aws_s3_bucket" "serbucket" {
  bucket = "serbucket-sergiosl-accordjonante"
  tags = {
    Name        = "serbucket"
    Environment = "Dev"
    Team        = "Mclaren Malboro Honda Bucket Team"
  }

  lifecycle_rule {
    id      = "Ayrton Senna"
    enabled = true

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }

    noncurrent_version_expiration {
      days = 365
    }
  }

  versioning {
    enabled = true
  }
}
