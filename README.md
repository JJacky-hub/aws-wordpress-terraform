# AWS WordPress Multi-Tier Infrastructure with Terraform (IaC)

Terraform project demonstrating the provisioning of a small AWS web infrastructure for WordPress using **Terraform (Infrastructure as Code)**.

---

##  Architecture & Components

```text
[ Internet / Clients ]
          │ (Port 80 HTTP / 22 SSH)
          ▼
   [ AWS EC2 Instance ]      <-- Web Server (Nginx + PHP-FPM)
          │
          │ (Port 3306 MySQL - Restricted to EC2 SG)
          ▼
   [ AWS RDS MySQL ]         <-- Database Layer (Isolated)
```

* **AWS EC2 (Ubuntu 22.04 LTS):** Compute layer provisioned with dynamic `user_data` script to pre-install Nginx and PHP-FPM runtime.
* **AWS RDS (MySQL 8.0):** Managed database tier isolated within a dedicated Security Group, accessible exclusively from the EC2 instance on Port `3306`.
* **Security Groups:** Multi-tier network isolation enforcing Least Privilege access rules.
* **Terraform Outputs:** Automated exposure of the instance Public IP and RDS Endpoint immediately post-deployment.

---

##  Repository Structure

```text
.
├── providers.tf      # AWS Provider and version requirements
├── variables.tf      # Input variables definitions
├── main.tf           # Core AWS resource definitions (EC2, RDS, Security Groups)
├── outputs.tf        # Output values (EC2 Public IP, RDS Endpoint)
├── .gitignore        # Exclusion rules for sensitive state/variable files
└── README.md         # Project documentation
```

---

##  Usage Guide

### Prerequisites
* **Terraform** `>= 1.3.0`
* **AWS CLI** configured with valid Access Keys (`aws configure`)

### Quick Deployment

1. **Clone the repository:**
   ```bash
   git clone https://github.com/JJacky-hub/aws-wordpress-terraform.git
   cd aws-wordpress-terraform
   ```

2. **Define secrets:**
   Create a `terraform.tfvars` file to store sensitive variables:
   ```terraform
   terraform apply \
  -var='ssh_cidr=YOUR_IP/32' \
  -var='db_password=YOUR_SECURE_PASSWORD'"
  
   ```

3. **Initialize and Provision:**
   ```bash
   terraform init
   terraform plan
   terraform apply -auto-approve
   ```

### Teardown / Cleanup
To completely destroy all provisioned infrastructure in AWS and avoid unexpected charges:
```bash
terraform destroy -auto-approve
```

