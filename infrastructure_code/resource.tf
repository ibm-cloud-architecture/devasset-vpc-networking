##############################################################################
# Optional block. This example uses a varialble to define an exisitng resource
# group to use for provisioning the VPC architecture. If you desire to create 
# and use a new resource group. You should
# - ensure your userid has the appropriate permissions to create a resource group
# - remove comment below
# - remove or comment out the resource_group variable if the varialbe.tf
# - change all references to a resource group  to refer to the output ID of the
#   block below replacing with "ibm_resource_group.resourceGroup.id"
##############################################################################


#resource "ibm_resource_group" "resourceGroup" {
#  name = "${var.resource_group}"
#}
