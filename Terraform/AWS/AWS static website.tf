
#declaramos provider y region

provider "aws" {
  region = "eu-west-1"
}

#declaramos el bucket y permisos 
resource "aws_s3_bucket" "website_bucket" {
  bucket = "website-bucket-estatico"
  acl    = "public-read"
 
 #le pasamos las paginas indice y error del website
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

#creamos el objeto del index.html de la pagina web

resource "aws_s3_bucket_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = "index.html"
  source = "directorio/del/archivo.html"
  content_type = "text/html"
}

#creamos el objeto del error.html del a pagina web 
resource "aws_s3_bucket_object" "error_html" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = "error.html"
  source = "directorio/del/error.html" #ejemplo /webpage/error.html
  content_type = "text/html"
}

#creamos el objeto de el bucket para las imagenes del site
resource "aws_s3_bucket_object" "cloud_image" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = "cloud.jpg"
  source = "https://example.com/free-images/cloud.jpg" #ruta del a imagen gratutita
  content_type = "image/jpeg"
}

#creamos el objeto en aws de la politica de el bucket"

resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website_bucket.id

#le pasamos las politicas en formato JSON"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        #permisos de lectura publica para poder acceder a la pagina web"
        Sid = "PublicReadGetObject"
        Effect = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "${aws_s3_bucket.website_bucket.arn}/*"
        ]
      }
    ]
  })
}
