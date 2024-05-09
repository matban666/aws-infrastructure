
Create an aws EC2 instance with ssh and https access from the internet.

Prerequisites
1. Create an IAM account with policies AmazonEC2FullAccess and AmazonS3FullAccess
2. Give the IAM account Console access with MFA
3. Create an AWS access key for the IAM account and store in github secrets AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
4. Create an AWS Bucket
5. Create RSA keypair (outside) and put the public key in the github secret SSH_PUBLIC_KEY
6. Configure bucket and region etc in main.tf

Provisioning
1. Run github action 'Provision EC2 Instance'

Checking Provisioned Sustem
1. AWS console should have an instance, keypair, VPC, subnet etc.
2. ssh -i <PRIVATE_RSA_KEY> ec2-user@<DYNAMIC_IP>  # DYNAMIC_IP can be found in aws console page for the new instance "My Web Server"

Teardown
1. Run github action 'Teardown EC2 Instance'

Checking Teardown
1. Everythng should be gone from the AWS console

Potential Improvements
1. Pare down AmazonEC2FullAccess and AmazonS3FullAccess to the minimum required
2. Use an encrypted bucket
3. Investigate temporary access keys
4. Get a fixed IP address
