# Secure Three-Tier Cloud Architecture with Terraform

A modular, production-grade Infrastructure as Code (IaC) project designed to provision a secure, multi-tier cloud network layout using **Terraform** and automated via **GitHub Actions CI**.

---

## 🏗️ Architecture Overview

This project establishes a secure network topology that isolates workloads based on security sensitivity:

1. **Public Tier (Load Balancer Subnet):** Connects directly to the Internet Gateway (`0.0.0.0/0`), intended for public-facing Application Load Balancers (ALBs).
2. **Private Application Tier:** Hosts internal compute workloads (virtual machines/containers) with **no public IP addresses**, keeping them shielded from direct external threats.
3. **Isolated Database Tier:** Completely hidden backend subnet reserved for managed relational databases, accepting inbound traffic **only** from the Application security group.

### Traffic Flow Diagram
