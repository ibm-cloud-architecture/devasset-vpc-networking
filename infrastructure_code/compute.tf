#This terraform file provisions the compute components for the vpc networking solution. 
# a common ssh key is created and assigned to all virtual servers.

#Create each  compute, there is a variable that defines the number of instances to
#be deployed. The name, subnets, floating IPs and security groups are also index based
#on the number of virtual servers.
resource "ibm_is_instance" "basic_networking_is" {
  count   = "4"
  name    = "bn-${count.index < 2 ? "appserv" : "mysql"}-${((count.index+1) % 2) == 0 ? 1 : 2}"
  image   = "${var.image_template_id}"
  profile = "${var.machine_type}"

  primary_network_interface = {
    subnet          = "${element(ibm_is_subnet.basic_networking_subnet.*.id, count.index < 2 ? 0 : 1)}"
    security_groups = ["${element(ibm_is_security_group.basic_networking_security_group.*.id, count.index < 2 ? 0 : 1)}"]
  }

  vpc  = "${ibm_is_vpc.basic_networking_vpc.id}"
  zone = "${var.availability_zone}"
  keys = ["${ibm_is_ssh_key.basic_networking_key.id}"]
}

resource "ibm_is_floating_ip" "basic_networking_fip" {
  count  = "4"
  name   = "bn_${count.index < 2 ? "appserv" : "mysql"}_${((count.index+1) % 2) == 0 ? 1 : 2}"
  target = "${element(ibm_is_instance.basic_networking_is.*.primary_network_interface.0.id, count.index)}"
}

