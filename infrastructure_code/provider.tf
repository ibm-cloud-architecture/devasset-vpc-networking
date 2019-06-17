
#This terraform file defines the terraform provider that will be used
#to deploy this architecture. In this case, the IBM Cloud provider is
#the only provider that will be used. The two variables provide the
#means to deploy workloads. However, the APIkey and ibmid must have
#the permissions to deploy this archiecture's resources.

provider "ibm" {
  bluemix_api_key    = "${var.paasapikey}"
  softlayer_username = "${var.iaasusername}"
  softlayer_api_key  = "${var.iaasapikey}"
  region             = "${var.ibm_region}"
  resource_group     = "${var.resource_group}"
  riaas_endpoint     = "${var.riaas_endpoint}"
}
