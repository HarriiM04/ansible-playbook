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
```

Here you go! This is already in proper **Markdown (.md)** format. You can copy and paste it **directly** into a file named `README.md`:

````markdown
# 🔧 Ansible EC2 Web Server Automation Project

This project demonstrates the use of **Ansible** to automate the setup of web servers on two AWS EC2 instances (Ubuntu). A master node controls two slaves — each configured differently using a single playbook.

---

## 📁 What’s Inside

- `play.yaml`: Ansible playbook with 2 plays:
  - 🖥 **Slave1** → Installs Apache2, sets up firewall, deploys a custom page.
  - 🖥 **Slave2** → Installs Nginx, deploys a different custom HTML site.

---

## ⚙️ Technologies Used

- Ansible
- AWS EC2 (Ubuntu)
- Apache2 & Nginx
- UFW Firewall
- YAML
- SSH Key Authentication

---

## 🧱 EC2 Instance Setup

### 🧑‍💻 1. SSH Key Authentication

Ensure your EC2 instances (master + 2 slaves) are running Ubuntu and that:
- Your `.pem` SSH key is stored on the master.
- You can SSH into the slaves using the private key.

### 🗂️ 2. Ansible Inventory File `/etc/ansible/hosts`

```ini
[slave1]
13.49.xx.101 ansible_ssh_private_key_file=~/keyubuntu.pem ansible_user=ubuntu

[slave2]
13.49.xx.102 ansible_ssh_private_key_file=~/keyubuntu.pem ansible_user=ubuntu
````

Replace `13.49.xx.101/102` with your actual EC2 public IPs.

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

---

## 🛠️ Playbook: `play.yaml`

```yaml
---

- name: Setup Apache on slave1 with custom page and firewall
  hosts: slave1
  become: yes
  tasks:
    - name: update and upgrade system
      apt:
        update_cache: yes
        upgrade: dist

    - name: install apache2
      apt:
        name: apache2
        state: latest

    - name: allow Apache in UFW
      ufw:
        rule: allow
        name: "Apache"

    - name: add custom page to slave1
      copy:
        dest: /var/www/html/index.html
        content: |
          <html>
          <head><title>Slave1 Apache</title></head>
          <body><h1>Welcome to Slave1 ({{ inventory_hostname }})</h1></body>
          </html>

- name: Setup Nginx and deploy HTML site on slave2
  hosts: slave2
  become: yes
  tasks:
    - name: update and upgrade system
      apt:
        update_cache: yes
        upgrade: dist

    - name: install nginx
      apt:
        name: nginx
        state: latest

    - name: add custom HTML site to slave2
      copy:
        dest: /var/www/html/index.html
        content: |
          <html>
          <head><title>Slave2 Nginx</title></head>
          <body><h1>Hello from Slave2 ({{ inventory_hostname }})</h1></body>
          </html>
```

---

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

* Visit `http://[Slave1 Public IP]` → should show "Welcome to Slave1..."
* Visit `http://[Slave2 Public IP]` → should show "Hello from Slave2..."

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

```

---

Just save it as `README.md` and push to GitHub.  
If you want, I can help you with Git commands for that too!
```

