### **📂 Project: Jenkins-Terraform-Code**
#### **Setting up a Jenkins server on an Ubuntu machine using Terraform**
✅ **Prerequisites:**  
- AWS account with **AdminAccess** policy for the instance  
- Terraform installed on your local machine  
- SSH key pair for AWS EC2 access  

---

## **🚀 Setup Instructions**

### **Step 1: Clone the Repository**
```bash
git clone https://github.com/your-repo/Jenkins-Terraform-Code.git
cd Jenkins-Terraform-Code
```

### **Step 2: Initialize Terraform**
```bash
bash jenkins.sh
```

### **Step 3: Access Jenkins**
Once the Terraform script is applied, you will see the output:  
```
jenkins_public_ip = "YOUR_PUBLIC_IP"
jenkins_url = "http://YOUR_PUBLIC_IP:8080"
```
Open the **Jenkins URL** in a browser:  
```bash
http://YOUR_PUBLIC_IP:8080
```

### **Step 4: Get the Jenkins Admin Password**
Run the following command on the EC2 instance to retrieve the initial admin password:  
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
Use this password to unlock Jenkins and complete the setup.

---
