terraform {
  backend "s3" {
    bucket         = "petclinic-s3-v1"
    key            = "dev/application/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "petclinic-terraform-lock"
    use_lockfile   = true
  }
}