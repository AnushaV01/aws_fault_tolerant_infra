# AWS Fault-Tolerant Infrastructure

### ✅ Phase 1: VPC Module
- Created VPC with 3 public & 3 private subnets
- Added Internet Gateway, NAT Gateways (one per AZ)
- Configured route tables and subnet associations
- Used modular structure for scalability

---

### ✅ Phase 2: Security Module
- Created Security Groups for ALB, EC2, and RDS
- ALB SG → allows inbound HTTP (80) from internet (0.0.0.0/0)
- EC2 SG → allows inbound HTTP (80) from ALB SG only
- RDS SG → allows inbound MySQL (3306) from EC2 SG only
- Outbound open (stateful SGs allow response traffic automatically)

---

### ✅ Phase 3: IAM Module
- Created IAM Role for EC2 with `CloudWatchAgentServerPolicy`
- Created Instance Profile and attached to Launch Template
- Enables EC2 → CloudWatch metrics & logs without static credentials
- Role can be extended for S3 or Secrets Manager if needed

---

### ✅ Phase 4: Compute Module
- Launch Template created with:
  - Amazon Linux AMI
  - User data script (auto installs & runs web server)
  - IAM Instance Profile for CloudWatch access
- Auto Scaling Group (ASG) deployed across 3 private subnets
- Application Load Balancer (ALB) deployed in public subnets
- ALB forwards HTTP traffic → EC2 instances (private subnets)
- Ensures scalability and fault tolerance across AZs

---

### ✅ Phase 5: Database Module
- Deployed RDS (MySQL) with:
  - Multi-AZ enabled (automatic failover)
  - Private subnets only (no public access)
  - Linked RDS SG to accept 3306 from EC2 SG
  - `enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]`
- AWS internally uses `AWSServiceRoleForRDS` to push logs → CloudWatch

---

### ✅ Phase 6: Monitoring & Validation
- Verified resource creation via AWS Console:
  - VPC, Subnets, NAT, IGW
  - ALB, Target Groups, EC2 instances
  - RDS Multi-AZ deployment
- Checked CloudWatch:
  - EC2 and RDS metrics under CloudWatch → Metrics
  - RDS logs under `/aws/rds/instance/<db_name>/`
- Confirmed flow: Internet → ALB (Public) → EC2 (Private) → RDS (Private)