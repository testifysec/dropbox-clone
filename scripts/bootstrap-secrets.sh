#!/bin/bash
set -euo pipefail

# Bootstrap Kubernetes secrets from AWS Secrets Manager
# This script creates the necessary secrets for the dropbox-clone application
#
# Prerequisites:
# - AWS CLI configured with appropriate credentials
# - kubectl configured to access the target EKS cluster
#
# Usage:
#   ./scripts/bootstrap-secrets.sh [environment]
#   ./scripts/bootstrap-secrets.sh dev
#   ./scripts/bootstrap-secrets.sh prod

ENVIRONMENT="${1:-dev}"
NAMESPACE="dropbox-clone"
PROJECT_NAME="dropbox-clone"
SECRET_NAME="${PROJECT_NAME}-${ENVIRONMENT}-rds-credentials"
AWS_REGION="${AWS_REGION:-us-east-1}"

echo "Bootstrapping secrets for environment: ${ENVIRONMENT}"
echo "Using AWS Secrets Manager secret: ${SECRET_NAME}"
echo "Target namespace: ${NAMESPACE}"
echo ""

# Ensure namespace exists
kubectl get namespace "${NAMESPACE}" >/dev/null 2>&1 || {
    echo "Creating namespace ${NAMESPACE}..."
    kubectl create namespace "${NAMESPACE}"
}

# Fetch RDS credentials from AWS Secrets Manager
echo "Fetching RDS credentials from AWS Secrets Manager..."
RDS_SECRET=$(aws secretsmanager get-secret-value \
    --secret-id "${SECRET_NAME}" \
    --region "${AWS_REGION}" \
    --query 'SecretString' \
    --output text)

# Parse the JSON secret
DB_USERNAME=$(echo "${RDS_SECRET}" | jq -r '.username')
DB_PASSWORD=$(echo "${RDS_SECRET}" | jq -r '.password')
DB_HOST=$(echo "${RDS_SECRET}" | jq -r '.host')
DB_PORT=$(echo "${RDS_SECRET}" | jq -r '.port')
DB_NAME=$(echo "${RDS_SECRET}" | jq -r '.database')

# URL-encode the password (handle special characters)
DB_PASSWORD_ENCODED=$(python3 -c "import urllib.parse; print(urllib.parse.quote('${DB_PASSWORD}', safe=''))")

# Create the database connection string
CONNECTION_STRING="postgres://${DB_USERNAME}:${DB_PASSWORD_ENCODED}@${DB_HOST}:${DB_PORT}/${DB_NAME}?sslmode=require"

# Create or update the database credentials secret
echo "Creating/updating database credentials secret..."
kubectl create secret generic dropbox-clone-db-credentials \
    --namespace "${NAMESPACE}" \
    --from-literal=connection_string="${CONNECTION_STRING}" \
    --dry-run=client -o yaml | kubectl apply -f -

# Generate JWT secret if it doesn't exist
if kubectl get secret dropbox-clone-jwt-secret -n "${NAMESPACE}" >/dev/null 2>&1; then
    echo "JWT secret already exists, skipping..."
else
    echo "Creating JWT secret..."
    JWT_SECRET=$(openssl rand -base64 32)
    kubectl create secret generic dropbox-clone-jwt-secret \
        --namespace "${NAMESPACE}" \
        --from-literal=secret="${JWT_SECRET}"
fi

echo ""
echo "Secrets bootstrapped successfully!"
echo ""
echo "Created/updated secrets:"
kubectl get secrets -n "${NAMESPACE}" | grep dropbox-clone
