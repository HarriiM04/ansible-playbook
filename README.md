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
- YAML

### Initial Steps
- make sure your key file used in instaces are stored in master instance if it is not than copy it from your local machine to master instance
- create directory name ansible(you can give any name).
- change directory to ansible.
- create play.yaml.

## 🖥️ What the Playbook Does

### 🖥 Slave 1 (Apache)
- Updates and upgrades packages.
- Installs Apache2.
- Adds a custom HTML page.

### 🖥 Slave 2 (Nginx)
- Updates and upgrades packages.
- Installs Nginx.
- Adds a custom HTML page.


## 🧱 EC2 Instance Setup

### 🧑‍💻 1. SSH Key Authentication

Ensure your EC2 instances (master + 2 slaves) are running Ubuntu and that:
- Your `.pem` SSH key is stored on the master.
- You can SSH into the slaves using the private key.

### 🗂️ 2. Ansible Inventory File `/etc/ansible/hosts` in Master instance 

```ini
[production]
slave1 ansible_ssh_host=Add-slave1-public-id-from-aws-ec2-instance ansible_ssh_private_key_file=~/keyubuntu.pem ansible_user=ubuntu

slave1 ansible_ssh_host=Add-slave1-public-id-from-aws-ec2-instance ansible_ssh_private_key_file=~/keyubuntu.pem ansible_user=ubuntu
````

---

## 🛰️ Testing SSH Connection

Run this command to test if Ansible can communicate with both instances:

```bash
ansible -m ping all
```

**Expected Output:**

```json
slave1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
slave2 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

## 🌐 Allow HTTP (Port 80) in AWS

In your EC2 **Security Groups** for both slaves:

* Go to: **EC2 Dashboard → Security Groups → Inbound Rules**
* Add a new rule:

  * **Type**: HTTP
  * **Protocol**: TCP
  * **Port Range**: 80
  * **Source**: 0.0.0.0/0 (or restrict as needed)

This is needed to view the Apache/Nginx page in a browser via public IP.

---

## 🚀 Run the Playbook

```bash
ansible-playbook play.yaml
```

After successful execution:

* Visit `http://[Slave1 Public IP]` → should show "Welcome to slave1 with apache2"
* Visit `http://[Slave2 Public IP]` → should show "Let i present slave2"

---

## ✅ Outcome

* Both web servers are installed and serving different pages.
* Demonstrates role-based Ansible usage and practical DevOps skills.
* Fully automated configuration using Infrastructure as Code (IaC).

---

## 🤝 Contributing

Feel free to fork, try on your own AWS instances, and improve this project.

---

## 📜 License

This project is open-source and available under the MIT License.
