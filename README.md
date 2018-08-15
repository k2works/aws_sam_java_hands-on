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
```

**[⬆ back to top](#構成)**

## 配置

**[⬆ back to top](#構成)**

## 運用

**[⬆ back to top](#構成)**

## 開発

**[⬆ back to top](#構成)**

# 参照 #
+ [Amazon Linux2にDockerをインストールする](https://qiita.com/reoring/items/0d1f556064d363f0ccb8)
+ [Pythonのパッケージ管理システムpipのインストールと使い方](https://uxmilk.jp/12691) 
+ [aws-sam-local 改め aws-sam-cli の新機能 sam init を試す](https://qiita.com/hayao_k/items/841026f9675d163b58d5)
+ [[Java全般]SDKMAN（旧gvm）でJavaやGrvoovyをインストール](https://qiita.com/saba1024/items/967ee3d8a79440a97336)