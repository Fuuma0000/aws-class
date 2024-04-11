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

# キーペアのリソースを作成
resource "aws_key_pair" "my_keypair" {
  key_name   = "my-keypair"
  public_key = file("${path.module}/../keys/my-keypair.pub") # 公開鍵ファイルのパスを指定
}

# 出力: 公開鍵の値を表示
output "public_key" {
  value = aws_key_pair.my_keypair.public_key
}

resource "tls_private_key" "my_keypair" {
  algorithm = "ED25519"
}

# ローカルファイルに秘密鍵を生成
resource "local_file" "private_key" {
  filename        = "${path.module}/../keys/my-keypair.pem"    # 秘密鍵ファイルのパスを指定
  content         = tls_private_key.my_keypair.private_key_pem # Terraformで生成した秘密鍵の内容を取得
  file_permission = "0400"                                     // 400パーミッションを設定
}
