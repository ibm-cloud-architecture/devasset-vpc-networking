#This terraform file defines the terraform provider that will be used
#to deploy this architecture. In this case, the IBM Cloud provider is
#the only provider that will be used. The two variables provide the
#means to deploy workloads. However, the APIkey and ibmid must have
#the permissions to deploy this archiecture's resources.

provider "ibm" {
  ibmcloud_api_key   = var.iaasapikey
  region             = var.ibm-region
  resource_group     = var.resource-group
}

