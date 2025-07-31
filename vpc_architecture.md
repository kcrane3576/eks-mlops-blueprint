# Terraform AWS VPC Architecture

This diagram illustrates the VPC architecture created by the Terraform AWS VPC module.

## Diagram

```mermaid
graph TD
  VPC["VPC (10.0.0.0/16)"]
  IGW["Internet Gateway"]
  NAT["NAT Gateway (1x shared)"]
  PubRT["Public Route Table"]
  PrivRT["Private Route Table"]
  Flow["Flow Logs to CloudWatch"]
  NACL["Custom Network ACLs\n(Deny all inbound, Allow all outbound)"]
  SG["Default Security Group\n(Restrictive)"]

  PubSub1["Public Subnet (AZ1)"]
  PubSub2["Public Subnet (AZ2)"]
  PrivSub1["Private Subnet (AZ1)"]
  PrivSub2["Private Subnet (AZ2)"]

  VPC --> IGW
  VPC --> NAT
  VPC --> PubSub1
  VPC --> PubSub2
  VPC --> PrivSub1
  VPC --> PrivSub2
  VPC --> Flow
  VPC --> NACL
  VPC --> SG

  PubSub1 --> IGW
  PubSub2 --> IGW
  PrivSub1 --> NAT
  PrivSub2 --> NAT
  PubSub1 --> PubRT
  PubSub2 --> PubRT
  PrivSub1 --> PrivRT
  PrivSub2 --> PrivRT
```


## Resources Created

- VPC with CIDR range `10.0.0.0/16`
- Public and private subnets across multiple Availability Zones
- Internet Gateway for public subnets
- Shared NAT Gateway for private subnets
- Public and private route tables
- Flow Logs enabled to CloudWatch
- Custom Network ACLs:
  - Deny all inbound
  - Allow all outbound
- Default Security Group locked down
