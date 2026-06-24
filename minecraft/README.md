# Minecraft Fabric Server Setup (Ubuntu)

This directory contains the automation playbooks and scripts necessary to deploy and configure a production-ready, modded **Minecraft Java Server (v1.21) with the Fabric Mod Loader** on an Ubuntu GCP VM.

---

## 🛠️ Architecture & Features Automated
The Ansible playbook ([minecraft-playbook.yml](minecraft-playbook.yml)) fully automates the following steps on your remote VM:
* **Java Runtime**: Installs OpenJDK 21 (required for Minecraft 1.21).
* **Fabric Mod Loader**: Downloads and executes the Fabric Server Installer to generate the `fabric-server-launch.jar`.
* **Fabric API**: Downloads and installs the core Fabric API mod (`v0.100.1+1.21`) into the server's `mods` folder, enabling support for modded gameplay.
* **Security & Firewall**: Confirms the local Ubuntu firewall (UFW) permits TCP traffic on port `25565`.
* **Systemd Service Integration**: Sets up and registers a background system daemon `minecraft.service` so that the server starts automatically on boot and handles failures gracefully.
* **Interactive Console**: Runs the server process inside a virtual `screen` terminal session, allowing administrators to attach and interact directly with the live server console.

---

## 🚀 Steps to Deploy the Server

### Prerequisite 1: Authenticate with Google Cloud
Ensure that your local `gcloud` command-line tool is authenticated to your GCP project:
```bash
gcloud auth login
```

### Prerequisite 2: Deploy using the Bash Wrapper
We have provided a robust bash script called [mcjavainstall.sh](mcjavainstall.sh) that automates the zone discovery, file transfers, and playbook execution:
1. Make the script executable:
   ```bash
   chmod +x mcjavainstall.sh
   ```
2. Run the installer:
   ```bash
   ./mcjavainstall.sh
   ```

---

## 🎮 How Users Can Join

Once the script completes, follow these instructions to let players connect to your new modded server:

### Step 1: Find your Public Server IP
Run the following command to retrieve the external IP address of your `mc-fun-one` VM instance:
```bash
gcloud compute instances list \
    --project="walkboys-mc-fun-one" \
    --filter="name=mc-fun-one" \
    --format="value(networkInterfaces[0].accessConfigs[0].natIP)"
```

### Step 2: Configure Client-Side Mods
Every player joining the server **must** run a client-side setup matching the server's configurations exactly:
1. Ensure they have installed **Minecraft Java Edition** and **Java 21**.
2. Run the client-side installer playbook located in the `client/` folder of this repository to configure **Fabric v1.21** and the matching **Fabric API Mod**.
3. Place any additional Fabric mods (matching the server's mods) inside their local `%APPDATA%\.minecraft\mods\` folder.

### Step 3: Connect in Minecraft
1. Open the **Minecraft Launcher**.
2. Select the **Fabric Loader 1.21** installation profile and launch the game.
3. In the main menu, click **Multiplayer** -> **Direct Connection** (or **Add Server**).
4. Enter the **Public Server IP** obtained in Step 1.
5. Click **Join Server**!

---

## ⚙️ Administration & Management

Once deployed, you can easily control and monitor your Minecraft server by SSH'ing into your instance (`gcloud compute ssh mc-fun-one --project=walkboys-mc-fun-one --zone=<ZONE>`) and running the following commands:

### Interacting with the Live Console
The server runs inside a decoupled GNU `screen` session. To attach to the live console and enter server commands (such as `/op username`, `/whitelist`, `/stop`, etc.):
```bash
sudo screen -r minecraft
```
> [!IMPORTANT]
> To detach from the console screen without stopping the server, press `Ctrl + A` followed by `d`.

### Systemd Service Controls
* **Check Status**:
  ```bash
  sudo systemctl status minecraft
  ```
* **Restart Server**:
  ```bash
  sudo systemctl restart minecraft
  ```
* **Stop Server**:
  ```bash
  sudo systemctl stop minecraft
  ```
* **View Systemd Logs**:
  ```bash
  sudo journalctl -u minecraft -n 50 -f
  ```
