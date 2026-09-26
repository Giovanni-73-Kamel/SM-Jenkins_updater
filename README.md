# Jenkins Update Notifier & Updater

A lightweight Bash-based automation tool for monitoring Jenkins versions, notifying administrators when a newer Jenkins release is available, and providing a script to upgrade the installed Jenkins package.

The project is designed for Jenkins servers running on Debian/Ubuntu-based Linux distributions.

## Overview

Keeping Jenkins up to date is important for receiving security patches, bug fixes, and new features.

This project automates the update-checking process using two Bash scripts:

- `jenkins-updater-notifier.sh` checks the currently installed Jenkins version and compares it with the latest available Jenkins release.
- `jenkins-updater.sh` upgrades the Jenkins package to the latest version available from the configured Jenkins APT repository.

When a newer Jenkins version is detected, the notifier sends an email to the administrator and attaches the update script.

## How It Works

```text
Installed Jenkins
       |
       v
Read installed version using dpkg
       |
       v
Retrieve latest Jenkins version
from Jenkins update servers
       |
       v
Compare Versions
       |
   +---+---+
   |       |
 Same    Different
   |       |
   v       v
Up to    Send Email
Date     Notification
             |
             v
      Attach Update Script
             |
             v
      Administrator runs
      jenkins-updater.sh
             |
             v
       Upgrade Jenkins
```

## Project Structure

```text
SM-Jenkins_updater/
├── jenkins-updater-notifier.sh
└── jenkins-updater.sh
```

### `jenkins-updater-notifier.sh`

The notification script:

1. Retrieves the installed Jenkins version using `dpkg`.
2. Retrieves the latest Jenkins version from the Jenkins update server using `curl`.
3. Compares the installed and latest versions.
4. Sends an email notification if a newer version is available.
5. Attaches `jenkins-updater.sh` to the email so the administrator can perform the upgrade.

If Jenkins is already running the latest version, the script prints a confirmation message instead.

### `jenkins-updater.sh`

The update script performs the Jenkins package upgrade by refreshing the APT package metadata and upgrading only the Jenkins package.

```bash
sudo apt-get update
sudo apt-get install --only-upgrade jenkins -y
```

This keeps the update process focused on Jenkins instead of upgrading all packages on the server.

## Requirements

The project expects a Debian/Ubuntu-based Linux system with:

- Jenkins installed through an APT repository
- Bash
- `curl`
- `dpkg`
- `apt`
- `sudo`
- Internet connectivity
- A configured Jenkins APT repository

Email notifications additionally require:

- `msmtp`
- `msmtp-mta`
- `mailutils`

## Email Notification Setup

Install the required packages:

```bash
sudo apt update
sudo apt install msmtp msmtp-mta mailutils -y
```

Create an `msmtp` configuration file:

```bash
nano ~/.msmtprc
```

Example configuration:

```text
defaults
auth on
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile ~/.msmtp.log

account gmail
host smtp.gmail.com
port 587
from YOUR_EMAIL
user YOUR_EMAIL
password YOUR_APP_PASSWORD

account default : gmail
```

Secure the configuration file:

```bash
chmod 600 ~/.msmtprc
```

> If Gmail is used, an App Password should be used instead of the normal account password.

Never commit email credentials or application passwords to the repository.

## Configuration

Before running the notifier, open:

```text
jenkins-updater-notifier.sh
```

Replace:

```text
<your email>
```

with the destination email address that should receive Jenkins update notifications.

For example:

```bash
mail -s "Jenkins Update" -A jenkins-updater.sh admin@example.com
```

## Usage

Make both scripts executable:

```bash
chmod +x jenkins-updater-notifier.sh
chmod +x jenkins-updater.sh
```

Run the Jenkins version checker:

```bash
./jenkins-updater-notifier.sh
```

If Jenkins is already up to date, the output will look similar to:

```text
Jenkins is already up-to-date (version X.X.X)
```

If an update is available:

```text
Notification sent: Jenkins update available from version X.X.X to Y.Y.Y
```

The configured administrator will also receive an email containing the Jenkins updater script.

## Updating Jenkins

When an update is available, run:

```bash
./jenkins-updater.sh
```

The script will:

1. Detect the currently installed Jenkins version.
2. Retrieve the latest Jenkins version.
3. Display the version being upgraded.
4. Refresh APT repository information.
5. Upgrade the Jenkins package.

## Optional Automation with Cron

The notifier can be scheduled using `cron` so Jenkins versions are checked automatically.

Open the user's crontab:

```bash
crontab -e
```

For example, to check once every day:

```cron
0 9 * * * /path/to/SM-Jenkins_updater/jenkins-updater-notifier.sh
```

This allows the Jenkins server to be monitored for new releases without manually running the script.

## Security Considerations

Do not store SMTP passwords, Gmail App Passwords, or other credentials directly in the repository.

Keep the `.msmtprc` file protected:

```bash
chmod 600 ~/.msmtprc
```

Before updating a production Jenkins server, it is also recommended to:

- Back up the Jenkins home directory.
- Review Jenkins release notes.
- Verify plugin compatibility.
- Perform the update during an appropriate maintenance window.

## Technologies Used

- Bash
- Linux
- Jenkins
- APT / dpkg
- curl
- msmtp
- mailutils
- Cron

## Purpose

This project demonstrates practical Linux and DevOps automation concepts including:

- Bash scripting
- Package management automation
- Jenkins administration
- Version monitoring
- Email alerting
- Linux task scheduling
- Server maintenance automation

## Future Improvements

Possible enhancements include:

- Automatically scheduling update checks during installation.
- Adding structured logging.
- Sending notifications through Slack or other messaging platforms.
- Adding Jenkins service health checks before and after upgrades.
- Creating automatic Jenkins backups before upgrades.
- Adding rollback support if an upgrade fails.
- Containerizing or packaging the monitoring utility for easier deployment.

## Author

**Giovanni Kamel George**

Cloud & DevOps Engineer
