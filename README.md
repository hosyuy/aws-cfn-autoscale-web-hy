
Markdown
# Auto-Scaling Web Infrastructure (AWS CloudFormation)

## 🌐 Project Overview / プロジェクト概要

AWS CloudFormationを使用した、スケーラブルで耐障害性の高いWebインフラの自動構築プロジェクトです。**IaC (Infrastructure as Code)** を採用することで、手動設定を排除し、一貫性があり再現可能なデプロイを実現しています。
This project demonstrates the automation of a production-ready web architecture. By using **Infrastructure as Code (IaC)**, we ensure consistent and repeatable deployments of a highly available web server environment.

## 🚀 Key Features / 主な機能
* **High Availability (Multi-AZ):**高可用性 (Multi-AZ):** 複数のAZにインスタンスを分散配置し、単一障害点を排除した設計。
  
* **Auto Scaling:** オートスケーリング:** CPU利用率に応じてインスタンス数を自動増減させ、負荷分散とコスト最適化を両立。
   
* **Load Balancing (ALB):** 負荷分散 (ALB):** Application Load Balancerによるトラフィック分散と、正常なインスタンスへの自動ルーティング。
    
* **Security Best Practices:** セキュリティ:** セキュリティグループによる最小権限の原則（Least Privilege）を適用。


## 🏗 Architecture / 構成図



## 🛠 Tech Stack / 使用技術
* **Infrastructure:** AWS (CloudFormation)
* **Compute:** EC2 (Auto Scaling Group)
* **Networking:** VPC, Public Subnets, Application Load Balancer
* **Security:** IAM Roles, Security Groups

## 📖 Usage / 使い方
1.  Ensure you have an AWS account and CLI configured.
2.  Deploy the template using the AWS Management Console or CLI:
    ```bash
    aws cloudformation create-stack --stack-name my-web-stack --template-body file://template.yaml --parameters ParameterKey=VPCID,ParameterValue=your-vpc-id
    ```

## 💡 Author's Note / 工夫した点
実務での運用を意識し、**モジュール化**と**拡張性**に注力しました。パラメータ化を徹底することで、開発・ステージング・本番など異なる環境でも再利用可能な設計にしています。
