# aws-class

授業の課題を管理するリポジトリです。

## 使い方

### awscli をインストール

https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/getting-started-install.html

# tfenv のインストール

```bash
brew install tfenv
```

# tfenv の初期化(aws-class ディレクトリで実行 .terraform-version があるのでそれを使う)

```bash
tfenv install
```

# 実行するディレクトリに移動

cd chapter1

# 実行

```bash
terraform init
terraform plan
terraform apply
```

## おすすめエイリアス

```bash
alias tf='terraform'
alias tfv='terraform validate'
alias tff='terraform fmt -recursive'
```
