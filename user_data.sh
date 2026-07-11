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

# Step 1: Download kubectx & kubens
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
# Step 2: Create Symlinks
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
#Step 3: Make Executable
sudo chmod +x /opt/kubectx/kubectx
sudo chmod +x /opt/kubectx/kubens
# Verify Installation
kubens
# K9s is a terminal-based UI for Kubernetes. Instead of typing many kubectl commands, you get an interactive dashboard.
curl -sS https://webinstall.dev/k9s | bash


# Install Docker (simple & reliable)
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user