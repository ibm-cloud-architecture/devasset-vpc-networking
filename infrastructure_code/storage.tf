#This file creates a single Object Storage resource instance that will be used
#by the application instances.

resource "ibm_resource_instance" "cos-resource-instance" {
  name              = "vpc-cos"
  service           = "cloud-object-storage"
  plan              = "standard"
  location          = "global" // global or any region.
  resource_group_id = var.resource-group
  tags              = ["asset-development"]

  parameters = {
    "HMAC"            = true
    service-endpoints = "private"
  }

  //User can increase timeouts 
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

