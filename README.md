# Ansible EC2 Web Server Automation

This project demonstrates an automated configuration and deployment of web servers on two AWS EC2 instances (slaves) using **Ansible** from a master node.

## 📁 Project Structure

- `play.yaml`: Ansible playbook that:
  - Sets up Apache on `slave1` with a custom webpage.
  - Sets up Nginx on `slave2` and deploys a basic HTML page.

## 🛠 Technologies Used

- Ansible
- AWS EC2 (Ubuntu instances)
- Apache2 and Nginx
- UFW (Uncomplicated Firewall)
- YAML

## 🖥️ What the Playbook Does

### 🖥 Slave 1 (Apache)
- Updates and upgrades packages.
- Installs Apache2.
- Allows Apache through UFW.
- Adds a custom HTML page.

### 🖥 Slave 2 (Nginx)
- Updates and upgrades packages.
- Installs Nginx.
- Adds a custom HTML page.

## 🔧 How to Run

1. Ensure Ansible is installed on the master node.
2. Add slave instance IPs and private keys in `/etc/ansible/hosts`.
3. Run the playbook:

```bash
ansible-playbook play.yaml


🛰️ Testing SSH Connection
Run this command to test if Ansible can communicate with both instances:

bash
Copy
Edit
ansible -m ping all
Expected Output:

json
Copy
Edit
slave1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
slave2 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
