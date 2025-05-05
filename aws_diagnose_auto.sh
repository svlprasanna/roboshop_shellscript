#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No color

echo "🔍 Checking AWS CLI configuration..."
aws configure list
echo

echo "🔍 Checking environment proxy variables..."
HAS_PROXY=0
for var in HTTP_PROXY HTTPS_PROXY http_proxy https_proxy; do
    if [[ -n "${!var}" ]]; then
        echo "⚠️  $var is set to: ${!var}"
        HAS_PROXY=1
    fi
done

if [[ "$HAS_PROXY" -eq 0 ]]; then
    echo "✅ No proxy environment variables detected."
fi
echo

echo "🔍 Testing AWS credentials with STS GetCallerIdentity..."
if aws sts get-caller-identity --output json > /dev/null 2>&1; then
    echo -e "${GREEN}✅ AWS credentials are valid.${NC}"
else
    echo -e "${RED}❌ AWS credentials test failed.${NC}"
    echo "Exiting test early."
    exit 1
fi
echo

echo "🔍 Testing EC2 DescribeInstances API call..."
if aws ec2 describe-instances --max-items 1 --output json > /dev/null 2>&1; then
    echo -e "${GREEN}✅ EC2 API call succeeded.${NC}"
else
    echo -e "${RED}❌ EC2 API call failed.${NC}"
    if [[ "$HAS_PROXY" -eq 1 ]]; then
        echo "⚠️  Retrying with proxy environment variables unset..."

        # Unset proxies and retry
        unset HTTP_PROXY HTTPS_PROXY http_proxy https_proxy

        if aws ec2 describe-instances --max-items 1 --output json > /dev/null 2>&1; then
            echo -e "${GREEN}✅ Success after unsetting proxy variables!${NC}"
        else
            echo -e "${RED}❌ Still failing after unsetting proxy. Check your network, VPN, or firewall settings.${NC}"
            exit 1
        fi
    else
        echo "Check your network, region, or firewall settings."
        exit 1
    fi
fi

echo
echo -e "${GREEN}🎉 AWS CLI is working correctly and connected to AWS!${NC}"
