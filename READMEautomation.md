Here’s a **cleaned-up, properly formatted, and professional `README.md`** version of what you wrote — structured clearly for others to understand and follow:

---

# 🛡️ Automated Backup Script with Google Drive & Webhook Integration

This script provides a **simple yet powerful solution** to back up your project directory, upload it to Google Drive, and manage old backups using a rotational strategy. It also notifies you of backup status via webhook.

---

## ✅ Features

* 🔁 **Rotational Backup** (Daily, Weekly, Monthly)
* ☁️ **Integration with Google Drive** via `rclone`
* 🧹 **Auto-cleanup of older backups**
* 🔔 **Webhook notifications** using `curl`
* ⚙️ **Customizable** configuration (project name, backup folder, remote name, etc.)

---

## ⚙️ Prerequisites

### 1. Install Required Tools

Run the following in your terminal:

```bash
sudo apt update
sudo apt install zip curl rclone
```

---

## ☁️ Google Drive Setup (One-time)

Set up `rclone` to connect with your Google Drive:

```bash
rclone config
```

Follow these steps:

1. Type `n` to create a **new remote**
2. Enter a name (e.g., `gdrive` or `enacton`)
3. Choose the type: `drive`
4. Leave defaults as-is unless needed
5. Open the browser URL when prompted, sign in, and authorize
6. Say `yes` to auto config and save with `y`
7. Press `q` to quit the config

---

## 🚀 Clone Any GitHub Repo (for Demo/Test)

You can use any small GitHub repo for testing. Example:

```bash
git clone https://github.com/HarriiM04/ansible-playbook.git
cd ansible-playbook
```

---

## 📝 Script Configuration

Before running the script, open it with `nano`:

```bash
nano backup_script.sh
```

And update these key parts:

### 🔹 Set the remote name and folder:

```bash
# Remote drive name and folder
REMOTE_NAME="enacton"
REMOTE_FOLDER="ansible-playbook"
```

> Replace `enacton` with the remote name you added in `rclone config`.

---

### 🔹 Set webhook URL:

Go to [https://webhook.site](https://webhook.site), copy the generated URL, and update:

```bash
# Webhook URL for backup notification
WEBHOOK_URL="https://webhook.site/your-generated-url"
```

---

### 🔹 Set project name:

Make it the same as your GitHub repo:

```bash
# Project name
PROJECT_NAME="ansible-playbook"
```

---

### 💾 Save and Exit Nano

After editing in `nano`, save with:

* `Ctrl + O` (then press Enter)
* `Ctrl + X` to exit

---

## ▶️ Run the Backup Script

Now run the script like this:

```bash
bash backup_script.sh ~/ansible-playbook ~/mybackups
```

> This will create a backup, upload it to Drive, log the output, and send a webhook notification.

---

## 📌 Notes

* Make sure the first argument is the **project folder path**
* Second argument is the **backup folder path**
* The script creates `daily`, `weekly`, and `monthly` folders inside your backup directory
* Logs are written to: `~/mybackups/backup.log`

---

## ✅ Success Criteria

* ✅ Proper implementation of backup and rotation
* ✅ Upload to Google Drive via CLI
* ✅ Auto-deletion of expired backups
* ✅ Webhook notification on success

---

Let me know if you want this in `.md` file format or GitHub-optimized version with badges and more sections like "License", "Contributors", etc.
