cat << 'EOF' > README.md
# AWS WordPress Multi-Tier Infrastructure with Terraform (IaC)

Automated provisioning of a secure, production-ready AWS multi-tier infrastructure for WordPress using **Terraform (Infrastructure as Code)**.

---

## 🏗 Architecture & Components

```text
[ Internet / Clients ]
          │ (Port 80 HTTP / 22 SSH)
          ▼
   [ AWS EC2 Instance ]      <-- Web Server (Nginx + PHP-FPM)
          │
          │ (Port 3306 MySQL - Restricted to EC2 SG)
          ▼
   [ AWS RDS MySQL ]         <-- Database Layer (Isolated)
