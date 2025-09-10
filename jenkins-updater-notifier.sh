#!/bin/bash
set -e

# To send email notifications, ensure that the mail utility is installed and configured on your system.
# For example, on Debian/Ubuntu, you can install it using:


#sudo apt update
#sudo apt install msmtp msmtp-mta mailutils -y
#cat > ~/.msmtprc <<EOF
#defaults
#auth           on
#tls            on
#tls_trust_file /etc/ssl/certs/ca-certificates.crt
#logfile        ~/.msmtp.log

#account        gmail
#host           smtp.gmail.com
#port           587
#from           your email
#user           your email
#password       your-16-char-app-password

#account default : gmail
#EOF
#chmod 600 ~/.msmtprc



installed_version=$(dpkg -s jenkins 2>/dev/null | grep '^Version:' | awk '{print $2}')
latest_version=$(curl -sL https://updates.jenkins.io/current/latestCore.txt)

if [ "$installed_version" != "$latest_version" ]; then
    echo "there is an update for you jenkins server . If you want to update it, please use the bash script attached" | mail -s "Jenkins Update" -A jenkins-updater.sh <your email>
#you must replace <your email> with the desired email address
    echo "Notification sent: Jenkins update available from version $installed_version to $latest_version"
else
    echo "Jenkins is already up-to-date (version $installed_version)"
fi


