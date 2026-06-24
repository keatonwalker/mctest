# Minecraft Fabric Setup for Windows 11 Clients

This directory contains an Ansible playbook designed to fully automate the installation of **Minecraft: Java Edition (Fabric Modded)** on Windows 11 clients. It ensures 100% version compatibility with your Minecraft server.

## Version Specifications (Server-Client Parity)
- **Minecraft Game Version**: `1.21`
- **Java Runtime**: Java 21 (Adoptium OpenJDK via Chocolatey)
- **Mod Loader**: Fabric Mod Loader (LATEST)
- **Core Dependencies**: Fabric API (`v0.100.1+1.21`)

---

## Playbook Architecture
The playbook ([minecraft-client.yml](minecraft-client.yml)) automates the following steps:
1. **Directory Setup**: Creates safe temporary work directories (`C:\Temp\MinecraftSetup`).
2. **Chocolatey Installation**: Checks if the Chocolatey package manager is installed on the Windows machine, bootstrapping it if necessary.
3. **Core Dependencies**: Installs **Java 21 (OpenJDK)** and the official **Minecraft Launcher** via Chocolatey.
4. **Fabric Mod Loader**: Downloads and executes the official Fabric Loader installer in client CLI mode, dynamically injecting the Minecraft `1.21` Fabric profile into your launcher profiles.
5. **Fabric API Mod**: Downloads and registers the identical `fabric-api-0.100.1+1.21.jar` file in your AppData directory (`%APPDATA%\.minecraft\mods\`).
6. **Cleanup**: Removes all temporary installers and build assets.

---

## How to Execute the Playbook

### Prerequisite: Enable WinRM on Windows 11
Ansible controls Windows hosts via Windows Remote Management (WinRM). To enable and prepare WinRM on your Windows 11 client:
1. Search for **PowerShell** in your Start menu, right-click, and select **Run as Administrator**.
2. Run the following command to download and run the official Ansible WinRM setup script:
   ```powershell
   [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 3072
   $url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
   Invoke-Expression ((New-Object System.Net.WebClient).DownloadString($url))
   ```

### Executing from your Ansible Controller
Run the playbook targeting your Windows 11 client using your inventory or directly:
```bash
ansible-playbook -i "YOUR_WINDOWS_IP," -u "YOUR_WINDOWS_USERNAME" -k -e "ansible_connection=winrm ansible_winrm_server_cert_validation=ignore" minecraft-client.yml
```

Alternatively, you can create a local `hosts` inventory file:
```ini
[windows]
win11-client ansible_host=192.168.1.50

[windows:vars]
ansible_user=AdminUser
ansible_password=SecretPassword
ansible_connection=winrm
ansible_port=5986
ansible_winrm_transport=credssp
ansible_winrm_server_cert_validation=ignore
```
And execute it with:
```bash
ansible-playbook -i hosts minecraft-client.yml
```
