#!/bin/bash
exec > /var/log/user-data.log 2>&1
echo "Starting Datadog agent install..."

yum update -y
yum install -y curl bash

# Set Datadog API key and site
export DD_API_KEY=${dd_api_key}
export DD_SITE="datadoghq.com"

echo "Injected API Key: $DD_API_KEY"
echo "Datadog Site: $DD_SITE"

# Download and run the install script
curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh -o /tmp/install_script_agent7.sh
bash /tmp/install_script_agent7.sh

# Confirm agent is running
systemctl status datadog-agent

echo "Datadog agent install complete."

