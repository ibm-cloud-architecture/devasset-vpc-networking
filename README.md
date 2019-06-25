## Deploy IBM Cloud Virtual Private Cloud Basic Networking

Deploy a VPC with multiple subnets, ACLs, gateway and virtual servers with security groups using Terraform.


### Architecture

![Reference Architecture](./imgs/architecture.png)


### Prerequisites

1. Complete the [IBM Cloud Terraform tutorial](https://www.ibm.com/cloud/garage/tutorials/public-cloud-infrastructure) prior to running this example. 

2. Obtain the variable values need in the [variables.tf](./infrastructure_code/network.tf) file.

3. Refer to [IBM Cloud documentation on VPC](https://cloud.ibm.com/docs/vpc-on-classic?topic=vpc-on-classic-getting-started) for detailed information. 


### Steps to deploy this asset

1. **Build** the IBM Cloud Terraform docker container using the steps in the tutorial noted above.
   - Log into the Docker container.
   - Clone this repository.
     `$ git clone https://github.com/ibm-cloud-architecture/refasset-public-VPC-basic-networking`

2. **Deploy** this solution to IBM Cloud.

   - Change directory to the folder containing the terraform - [./infrastructure_code](./infrastructure_code).
   - Review the terraform files (main and variables) in that folder.
   - Edit the bootstrap.sh and add your API key and Auth token at line: 25,26.
   - Edit the variable.tf and add your values for the variables.
   - Run Terraform (init, plan, apply).

3. **Test** the deployment
   - To test the deployment, you can [use these steps](https://github.com/ibm-cloud-architecture/tutorial-vpc-3tier-networking/blob/master/WebApp.md) to install and run a 3-tier application. 

 4. **Enjoy!**
