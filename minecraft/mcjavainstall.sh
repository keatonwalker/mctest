#!/bin/bash
# mcjavainstall.sh
# This script uses gcloud to find the zone of the GCP VM 'mc-fun-one',
# copies the minecraft-playbook.yml file to the instance,
# and runs it locally using Ansible.

set -euo pipefail

# Configuration
PROJECT="walkboys-mc-fun-one"
INSTANCE_NAME="mc-fun-one"
PLAYBOOK_FILE="minecraft-playbook.yml"

echo "=========================================================="
echo "          Minecraft Server Deployment Script              "
echo "=========================================================="
echo "Project:       $PROJECT"
echo "Instance:      $INSTANCE_NAME"
echo "Playbook:      $PLAYBOOK_FILE"
echo "=========================================================="

# Step 1: Verify the playbook exists locally
if [[ ! -f "$PLAYBOOK_FILE" ]]; then
    echo "[-] Error: Playbook file '$PLAYBOOK_FILE' not found in the current directory." >&2
    exit 1
fi

# Step 2: Auto-detect the zone of the VM instance in the specified project
echo "[*] Detecting zone for instance '$INSTANCE_NAME' in project '$PROJECT'..."
ZONE=$(gcloud compute instances list \
    --project="$PROJECT" \
    --filter="name=$INSTANCE_NAME" \
    --format="value(zone)" \
    --limit=1 2>/dev/null)

if [[ -z "$ZONE" ]]; then
    echo "[-] Error: Could not find zone for instance '$INSTANCE_NAME' in project '$PROJECT'." >&2
    echo "    Please verify that:" >&2
    echo "    1. The instance name is correct." >&2
    echo "    2. The project name is correct." >&2
    echo "    3. You are authenticated with gcloud ('gcloud auth login')." >&2
    exit 1
fi

echo "[+] Successfully located instance '$INSTANCE_NAME' in zone: $ZONE"

# Step 3: Copy the Ansible playbook to the remote VM
echo "[*] Copying '$PLAYBOOK_FILE' to the remote instance..."
gcloud compute scp "$PLAYBOOK_FILE" "${INSTANCE_NAME}:~/${PLAYBOOK_FILE}" \
    --project="$PROJECT" \
    --zone="$ZONE"

# Step 4: SSH into the instance, bootstrap Ansible, and execute the playbook
echo "[*] Connecting to '$INSTANCE_NAME' to run the playbook..."
gcloud compute ssh "$INSTANCE_NAME" \
    --project="$PROJECT" \
    --zone="$ZONE" \
    --command="
        echo '=== Remote: Bootstrapping Ansible ==='
        if command -v apt-get &>/dev/null; then
            echo '[+] Debian/Ubuntu detected. Ensuring Ansible is installed...'
            sudo apt-get update -y
            sudo apt-get install -y ansible
        elif command -v yum &>/dev/null; then
            echo '[+] RedHat/CentOS detected. Ensuring Ansible is installed...'
            sudo yum install -y epel-release
            sudo yum install -y ansible
        else
            echo '[-] Error: Unsupported OS. Please install Ansible manually on the VM.' >&2
            exit 1
        fi

        echo '=== Remote: Running Ansible Playbook ==='
        sudo ansible-playbook -i 'localhost,' -c local ~/${PLAYBOOK_FILE}
    "

echo "=========================================================="
echo "[+] Minecraft server setup playbook executed successfully!"
echo "=========================================================="
