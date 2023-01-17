# k3s-multi-node-cluster-with-external-db
This repo contains the terraform configuration files to setup k3s cluster with below nodes:

- k3s master nodes (No. of nodes: 2)
- k3s worker nodes (No. of nodes: 2)
- k3s ETCD as external DB node (No. of nodes: 1)
- k3s HAproxy load balancer node (No. of nodes: 1)

## Pre-requisites:
This setup assumes following pre-requisies:
- AWS account (with Access key ID & Secret access key)
- `terraform` to be installed from the machine where this is being configured

## Steps to deploy & setup:
- Configure AWS credentials using following command:
```
aws configure
```
- Clone the repository to the local machine:
```
git clone git@github.com:nazim-deriv/k3s-multi-node-with-external-db.git
```
- Generate SSH key pair inside the present directory (This is essential to configure the k3s cluster since it needs to perform `remote-exec` through TF)
```
ssh-keygen -t rsa -b 4096
```
- Update the public key inside `key.tf` file under `public_key` value
- Also, please make sure private key is named as `id_rsa` and is present inside the present module directory (This is essential since this key will be used to SSH to nodes to perform configuration)
- Initialize the TF
```
terraform init
```
- Format & validate the TF configuration files
```
terraform fmt
terraform validate
```
- Perform the dry run
```
terraform plan
```
- If dry run looks good, run following command to setup & configure the cluster
```
terraform apply --auto-approve
```

## How it is being configured:
- This TF configuration basically perform the following:
  - Creates all required resources (SSH keys, Security groups & instances)
  - Login to each of the nodes in following sequence and configure required setup on them:
    - ETCD as external DB
    - HAproxy load balancer
    - Master nodes
    - Worker nodes

## Destroy the setup:
> **Warning**
> This is a destructive command. So before you execute it, please make sure you are destroying only required resources and it is not impacting any other resources. You may use following command to perform a dry run to see the resources being deleted are the ones which are intended to be.
>```
>terraform destroy
>```
- Destroying the setup is as simple as creating it. Execute following command to destroy the setup:
```
terraform destroy --auto-approve
```

## Troubleshoot
- In the event the installation fails or remains stuck at Null resource creation stage, please make sure the private key configured has appropriate permissions and is named as `id_rsa`
- Also, please make sure the public key used in `key.tf` file is exactly the one associated with the private key

