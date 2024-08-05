
# AWS RDS Aurora Terraform Module with Terragrunt

## Overview

This project contains a Terraform module for setting up an AWS RDS Aurora PostgreSQL cluster with a writer and reader instance, using Terragrunt for managing infrastructure as code across different environments. It includes configuration for remote state storage in S3 and state locking using DynamoDB.

## Project Structure

```
kraken_terraform/
├── modules/
│   └── aws_rds_cluster/
│       ├── main.tf
│       └── variables.tf
├── production/
│   ├── ap-southeast-2/
│   │   ├── app/
│   │   │   └── aws_rds_cluster/
│   │   │       ├── terragrunt.hcl
│   │   │       └── main.tf
│   └── common_vars.yaml
└── README.md
```

## Requirements

- **Terraform v1.0.0+**
- **Terragrunt v0.28+**
- **AWS CLI** configured with appropriate credentials
- **AWS Account** with necessary permissions to create RDS clusters, S3 buckets, and DynamoDB tables

## Features

- **AWS RDS Aurora PostgreSQL Cluster**:
  - Configures a highly available Aurora cluster with one writer and one reader instance.
  - Customizable via input variables for instance class, engine version, and more.
  
- **Remote State Management**:
  - Stores Terraform state files in an S3 bucket.
  - Uses DynamoDB for state locking to prevent concurrent modifications.

- **Terragrunt Integration**:
  - Terragrunt is used to manage Terraform configurations and handle environment-specific variables and state management.

## Usage

### 1. Clone the Repository


git clone https://github.com/your-username/kraken_terraform.git
cd kraken_terraform/production/ap-southeast-2/app/aws_rds_cluster


### 2. Configure AWS CLI

Ensure your AWS CLI is configured with credentials that have the necessary permissions:


aws configure


### 3. Update `module_repo` Path

Before running Terragrunt, update the `module_repo` path in `common_vars.yaml` to reflect the correct path on your local machine:


module_repo: "/Users/andrew/code/kraken_terraform/modules"


This path should point to the location of your Terraform modules directory.

### 4. Initialize Terragrunt


terragrunt init


This will set up the backend configuration, download necessary providers, and prepare the environment for deployment.

### 5. Deploy the Infrastructure

Review the plan and apply the changes:

terragrunt plan
terragrunt apply


This will create the AWS RDS Aurora PostgreSQL cluster along with the necessary security groups and subnet configurations.

## Configuration

### Input Variables

The following are some key input variables that can be customized in `variables.tf` or directly in `terragrunt.hcl`:

- `vpc_id`: The ID of the VPC where the RDS cluster will be deployed.
- `subnet_ids`: List of subnet IDs for the database instances.
- `security_groups`: List of security group IDs for the cluster.
- `instance_class`: The instance type for the RDS instances (e.g., `db.r5.large`).
- `master_username`: The master username for the RDS cluster.
- `master_password`: The master password for the RDS cluster.

### Outputs

- `security_group_id`: The ID of the security group attached to the RDS cluster.
- `endpoint`: The DNS address of the cluster.
- `reader_endpoint`: The DNS address of the read replica.

## Notes

- **Reserved Words**: Ensure the `master_username` is not a reserved word like `admin`.
- **Naming Conventions**: The database name must start with a letter and contain only alphanumeric characters.

## Cleanup

To destroy the infrastructure:

terragrunt destroy


This will remove all resources created by this module.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

