#!/bin/bash 

# Set non-interactive mode for installations
export DEBIAN_FRONTEND=noninteractive

# Update package list and install basic tools
apt-get update
apt-get install -y git wget net-tools

# Load necessary kernel modules for Kubernetes
modprobe overlay
modprobe br_netfilter

# Disable swap (required for Kubernetes)
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Ensure overlay and br_netfilter modules are loaded on boot
tee /etc/modules-load.d/k8s.conf <<EOF
overlay
br_netfilter
EOF

# Configure sysctl settings for Kubernetes networking
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sysctl --system  # Apply sysctl settings

# Install necessary utility tools
apt-get install -yq \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    gnupg \
    software-properties-common

# Install and configure containerd as the container runtime
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg  
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" |  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install containerd and configure it to use systemd as the cgroup driver
apt-get update
apt-get install -yq containerd.io
containerd config default |  tee /etc/containerd/config.toml >/dev/null 2>&1
sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
systemctl restart containerd
systemctl enable containerd

# Set Kubernetes version and add its repository
KUBERNETES_VERSION=1.29
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v$KUBERNETES_VERSION/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v$KUBERNETES_VERSION/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Install Kubernetes components: kubelet, kubeadm, kubectl
apt-get update -y
apt-get install -y  kubelet kubeadm kubectl kubernetes-cni nfs-common

# Set the hostname to indicate worker nodes
sudo hostnamectl set-hostname worker(hostname -i)