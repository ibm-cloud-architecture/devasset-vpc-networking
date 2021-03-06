# Define IBM and Terraform versions
terraform {
  required_version = ">= 0.13"
  required_providers {
    ibm = {
       source = "ibm-cloud/ibm"
       version = "1.14.0"
    }
  }
}
