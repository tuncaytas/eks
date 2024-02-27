terraform {
  backend "s3" {
    bucket = "tuncayeks"
    key    = "tf-state/eks"
    region = "us-east-2"
  }
}
