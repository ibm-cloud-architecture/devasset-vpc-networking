# This terraform file contains the variables and default values for 
# this architecture. Default values will be used unless changed at 
# deployment time.

# The Infrastructure API Key needed to deploy all resources. 
variable "iaasapikey" {
  description = "The IBM Cloud infrastructure API key"
  default     = ""
}

# The Platform as a Service API Key needed to deploy all resources. 
variable "paasapikey" {
  description = "The IBM Cloud platform API key"
  default     = ""
}

# Username for provided API Keys, needed to deploy all resources. 
variable "iaasusername" {
  description = "The IBM Cloud infrastructure user name"
  default     = ""
}

# The actual public key that will be created in IBM Cloud and
# assigned to the virtual servers
variable "ssh-key" {
  description = "ssh public key"
  default     = ""
}

# The region to deploy architecture.ssh
variable "ibm-region" {
  description = "IBM Cloud region"
  default     = ""
}

# The zone to deploy the architecture. The tutorial uses a
# single zone.
variable "availability-zone" {
  default = "us-south-1"
}

# Resource group to which these resources will belong 
variable "resource-group" {
  description = "resource group"
  default     = "vpc-test"
}

# Address Prefix used for creating VPC.
variable "address-prefix1" {
  description = "address prefix used in vpc"
  default     = "172.21.0.0/21"
}

variable "address-prefix2" {
  description = "address prefix used in vpc"
  default     = "172.21.8.0/21"
}

# Used by Security Group to give access to given resource.
variable "access-to-any-ip" {
  description = "Give access to any ip"
  default     = "0.0.0.0/0"
}

# OS image template used while provisioning VM. Default image is of Ubuntu 20.04.
variable "image-template-id" {
  default = "r006-988caa8b-7786-49c9-aea6-9553af2b1969"
}

# Machine type used while provisioning VM.
variable "machine-type" {
  description = "VM machine type"
  default     = "cx2-2x4"
}

# CIDR value for subnet.
variable "subnet-cidr" {
  description = "Used for creating subnet with given cidr"
  default     = "172.21.0.0/24"
}

variable "security-group-port" {
  description = "Used for adding rule for security group"
  default     = 3389
}

# CIDR value for ACL ingress/egress.
variable "ACLsource-ingress" {
  description = "Used for creating ACL source ingress cidr"
  default     = "0.0.0.0/1"
}

variable "ACLdest-ingress" {
  description = "Used for creating ACL destination ingress cidr"
  default     = "0.0.0.0/1"
}

variable "ACLsource-egress" {
  description = "Used for creating ACL source egress cidr"
  default     = "0.0.0.0/1"
}

variable "ACLdest-egress" {
  description = "Used for creating ACL destination egress cidr"
  default     = "0.0.0.0/1"
}

