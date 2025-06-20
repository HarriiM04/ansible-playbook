---

# Automated Backup Script with Google Drive & Webhook Integration

This script provides a **simple yet powerful solution** to back up your project directory, upload it to Google Drive, and manage old backups using a rotational strategy. It also notifies you of backup status via webhook.

---

## Features

* **Rotational Backup** (Daily, Weekly, Monthly)
* **Integration with Google Drive** via `rclone`
* **Auto-cleanup of older backups**
* **Webhook notifications** using `curl`
* **Customizable** configuration (project name, backup folder, remote name, etc.)

---

## Prerequisites

### 1. Install Required Tools

Run the following in your terminal:

```bash
sudo apt update
sudo apt install zip curl rclone
```

---

## Google Drive Setup (One-time)

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

## Clone Any GitHub Repo (for Demo/Test)

You can use any small GitHub repo for testing. Example:

```bash
git clone https://github.com/HarriiM04/ansible-playbook.git
cd ansible-playbook
```

---

## Script Configuration

Before running the script, open it with `nano`:

```bash
nano backup_script.sh
```

And update these key parts:

### Set the remote name and folder:

```bash
# Remote drive name and folder
REMOTE_NAME="enacton"
REMOTE_FOLDER="ansible-playbook"
```

> Replace `enacton` with the remote name you added in `rclone config`.

---

### Set webhook URL:

Go to [https://webhook.site](https://webhook.site), copy the generated URL, and update:

```bash
# Webhook URL for backup notification
WEBHOOK_URL="https://webhook.site/your-generated-url"
```

---

### Set project name:

Make it the same as your GitHub repo:

```bash
# Project name
PROJECT_NAME="ansible-playbook"
```

---

### Save and Exit Nano

After editing in `nano`, save with:

* `Ctrl + O` (then press Enter)
* `Ctrl + X` to exit

---

## Run the Backup Script

Now run the script like this:

```bash
bash backup_script.sh ~/ansible-playbook ~/mybackups
```

> This will create a backup, upload it to Drive, log the output, and send a webhook notification.

---

## Now all Set 

now go and check the google drive there's folder named ansible-playbook is created and inside that folder zip folder of the project is uploaded whenever the user execute the script
and it is also stores the backup zip file inside local folder backuptask you can check on it also.

---


* Make sure the first argument is the **project folder path**
* Second argument is the **backup folder path**
* The script creates `daily`, `weekly`, and `monthly` folders inside your backup directory
* Logs are written to: `~/mybackups/backup.log`

---
