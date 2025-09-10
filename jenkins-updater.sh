#!/bin/bash
installed_version=$(dpkg -s jenkins 2>/dev/null | grep '^Version:' | awk '{print $2}')
latest_version=$(curl -sL https://updates.jenkins.io/current/latestCore.txt)

echo "Updating Jenkins from version $installed_version to $latest_version"

        # Update apt repo info
        sudo apt-get update

        #Upgrade Jenkins package to latest available from Jenkins repo
        sudo apt-get install --only-upgrade jenkins -y
