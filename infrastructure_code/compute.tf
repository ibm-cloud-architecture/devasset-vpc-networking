# This terraform file provisions the compute components for the vpc networking solution. 
# A common ssh key is created and assigned to all virtual servers.

# Create each instance, there is a variable that defines the number of instances to
# be deployed. The name, subnets, floating IPs and security groups are also index based
# on the number of virtual servers.
resource "ibm_is_instance" "basic-networking-is" {
  count   = "4"
  name    = "bn-${count.index < 2 ? "appserv" : "mysql"}-${count.index + 1 % 2 == 0 ? 1 : 2}"
  image   = var.image-template-id
  profile = var.machine-type

  primary_network_interface {
    subnet = element(
      ibm_is_subnet.basic-networking-subnet.*.id,
      count.index < 2 ? 0 : 1,
    )
    security_groups = [element(
      ibm_is_security_group.basic-networking-security-group.*.id,
      count.index < 2 ? 0 : 1,
    )]
  }

  vpc  = ibm_is_vpc.basic-networking-vpc.id
  zone = var.availability-zone
  keys = [ibm_is_ssh_key.basic-networking-key.id]
}

resource "ibm_is_floating_ip" "basic-networking-fip" {
  count = "4"
  name  = "bn-${count.index < 2 ? "appserv" : "mysql"}-${count.index + 1 % 2 == 0 ? 1 : 2}"
  target = element(
    ibm_is_instance.basic-networking-is.*.primary_network_interface.0.id,
    count.index,
  )
}

