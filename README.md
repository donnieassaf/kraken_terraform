# AWS RDS Aurora & DMS Terraform Module with Terragrunt

## Overview

This project contains a Terraform module for setting up an AWS RDS Aurora PostgreSQL cluster with a writer and reader instance, as well as configuring AWS Database Migration Service (DMS) to facilitate database migrations. The setup uses Terragrunt for managing infrastructure as code across different environments and includes configuration for remote state storage in S3 and state locking using DynamoDB.

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


## AWS Database Migration Service (DMS) Integration

This section describes the setup of AWS Database Migration Service (DMS) to work with the AWS RDS Aurora PostgreSQL cluster. The DMS configuration is managed using Terraform with Terragrunt, which relies on outputs from the RDS module.

### Dependencies on RDS Outputs

To ensure that DMS is correctly set up to work with the Aurora RDS cluster, we use outputs from the RDS module. Terragrunt allows us to reference these outputs for seamless integration. The following are key points:

- **DMS Replication Instance**: Configured to interact with the Aurora RDS cluster, utilizing security groups and other settings derived from the RDS setup.
- **DMS Endpoints**: Created to connect to the RDS cluster using the DNS address provided by the RDS module's outputs.

### Terraform Configuration

Here is the basic configuration for DMS:

#### Replication Instance

- **`replication_instance_class`**: Defines the instance type for the DMS replication instance.
- **`allocated_storage`**: Specifies the amount of storage allocated for the replication instance.
- **`replication_instance_id`**: Unique identifier for the replication instance.
- **`vpc_security_group_ids`**: Security group IDs associated with the DMS instance, typically sourced from RDS outputs.
- **`publicly_accessible`**: Set to `false` to ensure the instance is not accessible from outside the VPC.

#### Source Endpoint

- **`endpoint_id`**: Unique identifier for the DMS source endpoint.
- **`endpoint_type`**: Type of endpoint, set to `source`.
- **`engine_name`**: Specifies the database engine, in this case, `aurora-postgresql`.
- **`username`** and **`password`**: Credentials for the source database, configured via Terraform variables.
- **`server_name`**: The DNS address of the RDS cluster, provided by the RDS module's outputs.
- **`port`** and **`database_name`**: Configuration details for connecting to the database.
- **`ssl_mode`**: Enforces SSL connection for added security.

#### IAM Role for DMS

- **IAM Role**: Created to allow DMS to interact with VPC resources.
- **IAM Policy Attachment**: Attaches the necessary policy to the role to enable DMS functionality.

### Usage

1. **Set Up DMS**: Apply the DMS configuration after deploying the RDS cluster. Ensure the RDS module outputs are properly referenced in the DMS configuration to integrate seamlessly.
   
2. **Verify Integration**: Check that DMS endpoints and replication instances are correctly connected to the Aurora cluster by verifying connectivity and performing test migrations.
