AWS SAM Java Hands-on
===================

# 目的 #
AWS サーバーレスアプリケーションモデル (AWS SAM) ハンズオン(Java)

# 前提 #
| ソフトウェア   | バージョン   | 備考        |
|:---------------|:-------------|:------------|
| java           |8    |             |
| sam            |0.3.0  |             |
| docker         |17.06.2  |             |
| docker-compose |1.21.0  |             |
| vagrant        |2.0.3  |             |


# 構成 #
1. [構築](#構築 )
1. [配置](#配置 )
1. [運用](#運用 )
1. [開発](#開発 )

## 構築
### 開発用仮想マシンの起動・プロビジョニング
+ Dockerのインストール
+ docker-composeのインストール
+ pipのインストール

```bash
vagrant up
vagrant ssh
```

### 開発パッケージのインストール
+ aws-sam-cliのインストール

```bash
pip install --user aws-sam-cli
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.3/install.sh | bash
source ~/.bashrc 
curl -s api.sdkman.io | bash
source "/home/vagrant/.sdkman/bin/sdkman-init.sh"
sdk list maven
sdk use maven 3.5.4
sdk list java
sdk use java 8.0.181-zulu
```

### ドキュメント環境構築
```bash
cd /vagarnt
sdk list gradle
sdk use gradle 4.9
```
ドキュメントの生成
```bash
gradle asciidoctor
ruby -run -e httpd ./docs t -p 8000
```
[http://192.168.33.10:8000/](http://192.168.33.10:8000/)に接続して確認する


**[⬆ back to top](#構成)**

## 配置
### AWS認証設定
```bash
cd /vagrant/sam-app
cat <<EOF > .env
#!/usr/bin/env bash
export AWS_ACCESS_KEY_ID=xxxxxxxxxxxx
export AWS_SECRET_ACCESS_KEY=xxxxxxxxxx
export AWS_DEFAULT_REGION=us-east-1
EOF
```
アクセスキーを設定したら以下の操作をする
```bash
source .env
aws ec2 describe-regions
```

デプロイ用のS3バケットを用意する
```bash
aws s3 mb s3://java-hands-on
```
デプロイを実行する
````bash
cd /vagrant/sam-app
sam validate
sam package --template-file template.yaml --s3-bucket java-hands-on --output-template-file packaged.yaml
sam deploy --template-file packaged.yaml --stack-name java-hands-on --capabilities CAPABILITY_IAM
````
デプロイが成功したら動作を確認する
```bash
aws cloudformation describe-stacks --stack-name java-hands-on --query 'Stacks[].Outputs[1]'
```

**[⬆ back to top](#構成)**

## 運用
### スタックの削除
```bash
aws cloudformation delete-stack --stack-name java-hands-on
```
### S３バケットの削除
```bash
aws s3 rb s3://java-hands-on --force

### git-secretsの設定
インストール
```bash
cd /home/vagrant
git clone https://github.com/awslabs/git-secrets.git
cd git-secrets/
sudo make install
```
既存プロジェクトにフックを設定
```bash
cd /vagrant
git secrets --install
```
拒否条件を設定
```bash
git secrets --register-aws --global
```
レポジトリをスキャンする
```bash
cd /vagrant
git secrets --scan -r 
```
許可ルールを追加する
```bash
git config --add secrets.allowed sam-app/hello_world/event_file.json
```

**[⬆ back to top](#構成)**

## 開発
### アプリケーションの作成
```bash
cd /vagrant
sam init --runtime java
cd sam-app
```

### ローカルでテストする
```bash
cd /vagrant/sam-app
mvn install
mvn test
sam local generate-event api > event_file.json
sam local invoke HelloWorldFunction --event event_file.json
sam local start-api --host 0.0.0.0
```
[http://192.168.33.10:3000/hello](http://192.168.33.10:3000/hello)に接続して確認する

### コードカバレッジのセットアップ
pom.xmlファイルにJaCoCoのレポジトリ情報を追加して以下のコマンドを実行する
```bash
mvn install
mvn help:describe -Dplugin=org.jacoco:jacoco-maven-plugin -Ddetail
```
カバレッジレポートを作る
```bash
mvn clean jacoco:prepare-agent test jacoco:report
ruby -run -e httpd ./target/site/jacoco -p 8000
```
[http://192.168.33.10:8000/](http://192.168.33.10:8000/)に接続して確認する

**[⬆ back to top](#構成)**

# 参照 #
+ [Amazon Linux2にDockerをインストールする](https://qiita.com/reoring/items/0d1f556064d363f0ccb8)
+ [Pythonのパッケージ管理システムpipのインストールと使い方](https://uxmilk.jp/12691) 
+ [aws-sam-local 改め aws-sam-cli の新機能 sam init を試す](https://qiita.com/hayao_k/items/841026f9675d163b58d5)
+ [[Java全般]SDKMAN（旧gvm）でJavaやGrvoovyをインストール](https://qiita.com/saba1024/items/967ee3d8a79440a97336)
+ [クラウド破産しないように git-secrets を使う](https://qiita.com/pottava/items/4c602c97aacf10c058f1)
+ [JaCoCoでJavaのコードカバレッジレポートを作る](https://ishiis.net/2016/10/13/jacoco-coverage/)
+ [図入りのAsciiDoc記述からPDFを生成する環境をGradleで簡単に用意する](https://qiita.com/tokumoto/items/d37ab3de5bdbee307769) 