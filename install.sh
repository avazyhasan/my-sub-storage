#!/bin/bash

echo "Cloudflare Worker Auto Deploy (GitHub Version)"
echo "------------------------------------------------"

# Token ثابت داخل اسکریپت (دیگه نیازی به read نیست)
CF_API_TOKEN="objS3eTtFd0zSI_myfSwi24to06jw-wTIWbfAcNn"

# Account ID و Worker Name ثابت
CF_ACCOUNT_ID="c8646a80-adb1-4c06-b2d4-9eeba3999ca1"
WORKER_NAME="my-worker"

echo ""
echo "Downloading worker script..."
curl -L -o worker.js https://raw.githubusercontent.com/avazyhasan/my-sub-storage/main/worker.js

if [ ! -f worker.js ]; then
  echo "❌ Failed to download worker.js"
  exit 1
fi

echo ""
echo "Deploying Worker..."

RESPONSE=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/accounts/$CF_ACCOUNT_ID/workers/scripts/$WORKER_NAME" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -H "Content-Type: application/javascript" \
  --data-binary @worker.js)

# بررسی موفقیت
if [[ "$RESPONSE" == *'"success":true'* ]]; then
  echo "✅ Worker deployed successfully!"
else
  echo "❌ Deployment failed!"
  echo "Cloudflare Response:"
  echo "$RESPONSE"
fi

echo ""
echo "Finished."