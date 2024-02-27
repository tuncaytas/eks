terraform {
  backend "s3" {
    bucket = "tuncayeks"
    key    = "tf-state"
    region = "us-east-2"
  }
}
