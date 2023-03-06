resource "aws_s3_bucket" "cice_bucket" {
  bucket   = "cice-chamo-1971"
  provider = aws.europe

}

resource "aws_s3_bucket_acl" "cice-bucket_acl" {
  bucket   = aws_s3_bucket.cice_bucket.id
  acl      = "public-read"
  provider = aws.europe


}

resource "aws_s3_bucket_versioning" "cice_bucket_versioning" {
  bucket = aws_s3_bucket.cice_bucket.id
  versioning_configuration {
    
    status = "Enabled"
  }
provider = aws.europe
}
