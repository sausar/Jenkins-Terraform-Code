provider "aws" {
  region = "eu-west-3" # Adjust to your preferred region
}

resource "aws_security_group" "allow_ssh_tcp" {
  name        = "allow_ssh_tcp"
  description = "Allow SSH and TCP inbound traffic"

  # Allow SSH (Port 22) from anywhere 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow TCP (Port 8080) for Jenkins access
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Create an EC2 instance with a public IP
resource "aws_instance" "jenkins_instance" {
  ami             = "ami-0160e8d70ebc43ee1" # Adjust with your preferred Jenkins AMI
  instance_type   = "t2.medium"              # Adjust instance type as needed
  key_name        = "paris"                 # Adjust with your SSH key name
  security_groups = [aws_security_group.allow_ssh_tcp.name]

  # Tags for the instance
  tags = {
    Name = "Jenkins Instance"
  }

  # Provisioner to install Jenkins
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y openjdk-17-jdk",
      "sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian/jenkins.io-2023.key",
      "echo 'deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/' | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
      "sudo apt update",
      "sudo apt install -y jenkins",
      "sudo systemctl start jenkins",
      "sudo systemctl enable jenkins"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"            # Replace with the correct user for your AMI
      private_key = file("/root/paris") # Adjust path to your private key
      host        = aws_instance.jenkins_instance.public_ip
    }
  }
}

# Outputs
output "jenkins_public_ip" {
  value = aws_instance.jenkins_instance.public_ip
}

output "jenkins_url" {
  value = "http://${aws_instance.jenkins_instance.public_ip}:8080"
}

output "jenkins_name" {
  value = aws_instance.jenkins_instance.tags["Name"]
}
