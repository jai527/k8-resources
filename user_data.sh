#!/bin/bash

yum update -y
yum install -y git wget curl unzip tar

# Install eksctl
ARCH=amd64
PLATFORM=Linux_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_${PLATFORM}.tar.gz"

tar -xzf eksctl_${PLATFORM}.tar.gz -C /tmp

install -m 0755 /tmp/eksctl /usr/local/bin/eksctl

rm -f eksctl_${PLATFORM}.tar.gz
rm -f /tmp/eksctl

# Install kubectl
curl -Lo /usr/local/bin/kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.35.2/2026-02-27/bin/linux/amd64/kubectl

chmod +x /usr/local/bin/kubectl

# Verify installation
eksctl version > /tmp/eksctl-version.txt
kubectl version --client > /tmp/kubectl-version.txt