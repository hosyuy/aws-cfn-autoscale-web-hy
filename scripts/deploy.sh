#!/bin/bash

# ==============================================================================
# AWS CloudFormation 自動デプロイメントスクリプト
# 設計思想: 冪等性（Idempotency）とモジュール化を重視した完全自動化パイプライン
# ==============================================================================

# --- 1. 環境変数の定義 ---
# システム全体で一貫性を持たせるための共通識別子
SYSTEM_NAME="my-portfolio-system"
STACK_NAME="${SYSTEM_NAME}-master"

# S3バケット名は全世界で一意である必要があるため、必要に応じて末尾にユニークな値を付与
BUCKET_NAME="my-cfn-artifacts-hy"
REGION="ap-northeast-1"

echo "🚀 ${SYSTEM_NAME} のデプロイメントパイプラインを開始します..."

# --- 2. アーティファクト保存用S3バケットのプロビジョニング ---
# 冪等性を確保するため、バケットの存在を確認してから作成。
# このバケットはNested Stacksの子テンプレート（01~03）を一時保存するために使用します。
if aws s3 ls "s3://$BUCKET_NAME" 2>&1 | grep -q 'NoSuchBucket'; then
  echo "🪣 アーティファクトバケットが存在しません。バケットを作成中: $BUCKET_NAME"
  aws s3 mb s3://$BUCKET_NAME --region $REGION
else
  echo "✅ アーティファクトバケット $BUCKET_NAME は既に存在します。処理を続行します..."
fi

# --- 3. テンプレートのパッケージング ---
# ローカルにある子スタック（ネットワーク、セキュリティ、アプリ）をS3にアップロード。
# Masterスタックから参照可能なS3 URLが埋め込まれた 'packaged.yaml' を自動生成します。
echo "📦 CloudFormation テンプレートをパッケージ化中..."
aws cloudformation package \
  --template-file cloudformation/master.yaml \
  --s3-bucket $BUCKET_NAME \
  --output-template-file packaged.yaml

# --- 4. スタックのデプロイ実行 ---
# パッケージ化されたテンプレートを使用して、依存関係に基づいた順次デプロイを実行。
# SystemName パラメータを渡すことで、スタック間のリソース参照を動的に統合します。
echo "☁️ CloudFormation スタックをデプロイ中: $STACK_NAME..."
aws cloudformation deploy \
  --template-file packaged.yaml \
  --stack-name $STACK_NAME \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides SystemName=$SYSTEM_NAME

echo "🎉 デプロイパイプラインが正常に完了しました！インフラストラクチャの構築に成功しました。"