 #Bootstrap Jenkins installation and start  
 #!/bin/bash #specifies the interpreter
sudo yum update -y  # updates the package list and upgrades installed packages on the system
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo  #downloads the Jenkins repository configuration file and saves it to /etc/yum.repos.d/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key  #imports the GPG key for the Jenkins repository. This key is used to verify the authenticity of the Jenkins packages
sudo yum upgrade -y #  upgrades packages again, which might be necessary to ensure that any new dependencies required by Jenkins are installed
sudo dnf install java-11-amazon-corretto -y  # installs Amazon Corretto 11, which is a required dependency for Jenkins.
sudo yum install jenkins -y  #installs Jenkins itself
sudo systemctl enable jenkins  #enables the Jenkins service to start automatically at boot time
sudo systemctl start jenkins   #starts the Jenkins service immediately