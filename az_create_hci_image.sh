#!/bin/bash

# Script to create an Azure HCI cluster image from storage using Azure CLI
# Usage: ./create-hci-cluster-image.sh <resource-group> <cluster-name> <storage-account> <container> <image-name> <os-type> <blob-name>

set -e

# Arguments
RESOURCE_GROUP="$1"
CLUSTER_NAME="$2"
STORAGE_ACCOUNT="$3"
CONTAINER="$4"
IMAGE_NAME="$5"
OS_TYPE="$6"         # Example: Windows or Linux
BLOB_NAME="$7"       # Example: my-vhd.vhd

if [ $# -ne 7 ]; then
    echo "Usage: $0 <resource-group> <cluster-name> <storage-account> <container> <image-name> <os-type> <blob-name>"
    exit 1
fi

# Get storage account key
STORAGE_KEY=$(az storage account keys list \
    --resource-group "$RESOURCE_GROUP" \
    --account-name "$STORAGE_ACCOUNT" \
    --query '[0].value' -o tsv)

# Build the blob URL
BLOB_URL="https://${STORAGE_ACCOUNT}.blob.core.windows.net/${CONTAINER}/${BLOB_NAME}"

# Create image from the blob in the storage account
az stack-hci image create \
    --resource-group "$RESOURCE_GROUP" \
    --cluster-name "$CLUSTER_NAME" \
    --name "$IMAGE_NAME" \
    --os-type "$OS_TYPE" \
    --source-uri "$BLOB_URL" \
    --storage-account-key "$STORAGE_KEY"

echo "Azure HCI cluster image '$IMAGE_NAME' created successfully from $BLOB_URL"
