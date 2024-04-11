terraform {
  required_version = ">= 1.5.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

locals {
  private_key_file = "./keys/hoge.pem"
}

# キーペアのリソースを作成
resource "aws_key_pair" "my_keypair" {
  key_name   = "my-keypair"
  public_key = tls_private_key.my_keypair.public_key_openssh
}

resource "tls_private_key" "my_keypair" {
  algorithm = "ED25519"
}

# ローカルファイルに秘密鍵を生成
resource "local_file" "private_key" {
  filename        = local.private_key_file
  content         = tls_private_key.my_keypair.private_key_pem # Terraformで生成した秘密鍵の内容を取得
  file_permission = "0400"                                     // 400パーミッションを設定
}
