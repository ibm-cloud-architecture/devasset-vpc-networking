# This terraform file contains the variables and default values for 
# this architecture. Default values will be used unless changed at 
# deployment time.


# The Infrastructure API Key needed to deploy all resources. 
variable iaasapikey {}

# The Platform as a Service API Key needed to deploy all resources. 
variable paasapikey {}

# Username for provided API Keys, needed to deploy all resources. 
variable iaasusername {}

# The actual public key that will be created in IBM Cloud and
# assigned to the virtual servers
variable ssh_key {}

# The region to deploy architecture.ssh
variable ibm_region {}

# The zone to deploy the architecture. The tutorial uses a
# single zone.
variable availability_zone {}

# The next generation infrastructure service API endpoint . 
# It can also be sourced from the RIAAS_ENDPOINT. 
# Default value: us-south.iaas.cloud.ibm.com
variable  riaas_endpoint {}

# Resource group to which these resources will belong 
variable resource_group {}

# Address Prefix used for creating VPC.
variable address_prefix1 {}

variable address_prefix2 {}

# Used by Security Group to give access to given resource.
variable access_to_any_ip {
  description = "Give access to any ip"
  default = "0.0.0.0/0"
}

# OS image template used while provisioning VM. Default image is of Ubuntu.
variable  image_template_id {}

# Machine type used while provisioning VM.
variable machine_type {}

# Port speed used while provisioning VM.
variable port_speed  {}

# CIDR value for subnet.
variable subnet_cidr {}

variable security_group_port {}
# CIDR value for ACL ingress/egress.
variable ACLsource_ingress {
  description = "Used for creating ACL source ingress cidr"
  default = "0.0.0.0/1"
}
variable ACLdest_ingress {
  description = "Used for creating ACL destination ingress cidr"
  default = "0.0.0.0/1"
}
variable ACLsource_egress {
  description = "Used for creating ACL source egress cidr"
  default = "0.0.0.0/1"
}
variable ACLdest_egress {
  description = "Used for creating ACL destination egress cidr"
  default = "0.0.0.0/1"
}
