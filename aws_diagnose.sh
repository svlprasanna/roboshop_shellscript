#!/bin/bash

echo "🔍 Checking AWS CLI configuration..."
aws configure list
echo

echo "🔍 Checking environment proxy variables..."
env | grep -i proxy
echo

echo "🔍 Testing AWS credentials with STS GetCallerIdentity..."
aws sts get-caller-identity --output json || {
    echo "❌ Failed to authenticate with AWS. Check your credentials!"
    exit 1
}
echo

echo "🔍 Testing EC2 DescribeInstances API call..."
aws ec2 describe-instances --max-items 1 --output json || {
    echo "❌ Failed to connect to EC2. Possible proxy or region issue."
    exit 1
}
echo

echo "✅ AWS CLI looks properly configured and reachable."
