# Minecraft Infrastructure as Code (GCP)

This directory contains the Terraform configuration files required to provision a Google Cloud Platform (GCP) virtual machine and security rules for hosting a modded Minecraft server.

---

## 🏗️ Infrastructure Provisioned
* **VPC Network**: Creates an isolated virtual private cloud (`mc-network`).
* **Firewall Rule**: Configures `mc-allow-minecraft-ssh` allowing:
  * **TCP `25565`**: Minecraft Server port (Open to `0.0.0.0/0`).
  * **TCP `22`**: SSH administrative port (Open to `0.0.0.0/0`).
* **Compute Engine VM**: Deploys an `e2-medium` virtual machine named `mc-fun-one` running **Ubuntu 22.04 LTS**.
* **Metadata Configuration**: Automatically enables Google OS Login for simple, secure SSH session authentication.

---

## 🚀 Execution Instructions

### Step 1: Initialize Terraform
Initialize the working directory to download the required Google Cloud provider plugins:
```bash
terraform init
```

### Step 2: Plan your Infrastructure
Generate an execution plan to verify what resources will be created inside your project (`walkboys-mc-fun-one`):
```bash
terraform plan
```

### Step 3: Apply Configurations
Build the infrastructure on GCP:
```bash
terraform apply
```
*(Type `yes` when prompted to confirm execution.)*

### Step 4: Verify Output
Upon successful application, Terraform will output the public IP address of your new VM:
```text
Outputs:
instance_external_ip = "34.123.45.67"
```
Use this IP inside your Ansible playbooks and within Minecraft client connections.

---

## 🧹 Destroying Resources
To teardown all resources and prevent ongoing billing:
```bash
terraform destroy
```
