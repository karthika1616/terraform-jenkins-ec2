
#!/bin/bash
set -euxo pipefail

exec > >(tee -a /var/log/jenkins-install.log) 2>&1

echo "Updating Ubuntu packages..."
apt-get update -y

echo "Installing Java 21 and required tools..."
apt-get install -y fontconfig openjdk-21-jre wget curl

echo "Adding the Jenkins LTS repository..."
install -d -m 0755 /etc/apt/keyrings

wget -q -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  > /etc/apt/sources.list.d/jenkins.list

apt-get update -y

echo "Installing Jenkins..."
apt-get install -y jenkins

echo "Enabling and starting Jenkins..."
systemctl enable jenkins
systemctl start jenkins

echo "Waiting for Jenkins to become ready..."
for i in $(seq 1 60); do
  if systemctl is-active --quiet jenkins &&
     curl -fsS http://127.0.0.1:8080/login >/dev/null; then
    break
  fi
  sleep 10
done

echo "Checking Jenkins service..."
systemctl --no-pager --full status jenkins || true

echo "Saving initial setup password..."
if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
  install -o ubuntu -g ubuntu -m 600 \
    /var/lib/jenkins/secrets/initialAdminPassword \
    /home/ubuntu/jenkins_password.txt
fi

echo "Jenkins installation script finished."
