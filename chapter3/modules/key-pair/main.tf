resource "tls_private_key" "my_keypair" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "my_keypair" {
  key_name   = var.name
  public_key = trimspace(tls_private_key.my_keypair.public_key_openssh)
}

# ローカルファイルに秘密鍵を生成
resource "local_file" "private_key" {
  filename        = "./keys/${var.name}.pem" # Terraformで生成した秘密鍵の内容を取得
  content         = tls_private_key.my_keypair.private_key_openssh
  file_permission = "400" // 400パーミッションを設定
}
