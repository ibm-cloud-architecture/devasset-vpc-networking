#This file creates the network components for the vpc that will be used by the compute 
#resources. The vpc includes the vpc, gateway, subnets and load balancers.


# Create an IBM Cloud infrastructure SSH key. You can find the SSH key surfaces in the infrastructure console under Devices > Manage > SSH Keys
resource "ibm_is_ssh_key" "basic_networking_key" {
  name       = "basic_networking_key"
  public_key = "${var.ssh_key}"
}


# Create a IS VPC and instance
resource "ibm_is_vpc" "basic_networking_vpc" {
  name = "basic_networking_vpc"
}

resource "ibm_is_vpc_address_prefix" "basic_networking_prefix" {
 count       = "2"
 name        = "basic_networking_prefix_${count.index + 1}"
 zone        = "${var.availability_zone}"
 vpc         = "${ibm_is_vpc.basic_networking_vpc.id}"
 cidr        = "${count.index == 0 ? var.address_prefix1 : var.address_prefix2}"
}

resource "ibm_is_public_gateway" "basic_networking_gateway" {
  name = "basic_networking_gateway"
  vpc = "${ibm_is_vpc.basic_networking_vpc.id}"
  zone = "${var.availability_zone}"
}

resource "ibm_is_subnet" "basic_networking_subnet" {
  count           = "2"
  name            = "basic_networking_subnet_${count.index + 1}"
  vpc             = "${ibm_is_vpc.basic_networking_vpc.id}"
  zone            = "${var.availability_zone}"
  ipv4_cidr_block = "${element(ibm_is_vpc_address_prefix.basic_networking_prefix.*.cidr, count.index)}"
  public_gateway  = "${ibm_is_public_gateway.basic_networking_gateway.id}"
}

resource "ibm_is_lb" "basic_networking_lb" {
    count          = "2"
    name           = "bn-${count.index == 0 ? "app" : "data"}-lb"
    subnets        =  ["${element(ibm_is_subnet.basic_networking_subnet.*.id, count.index)}"]
    resource_group = "${var.resource_group}"
    type           = "${count.index == 0 ? "public" : "private"}"
}

resource "ibm_is_lb_pool" "basic_networking_lb_pool" {
  count          = "2"
  name           = "bn-${count.index == 0 ? "app" : "data"}-lb-pool"
  lb             = "${element(ibm_is_lb.basic_networking_lb.*.id, count.index)}"
  algorithm      = "${count.index == 0 ? "round_robin" : "least_connections"}"
  protocol       = "http"
  health_delay   = 20
  health_retries = 3
  health_timeout = 5
  health_type    = "http"
}

resource "ibm_is_lb_pool_member" "basic_networking_lb_mem" {
  count          = "2"
  lb             = "${element(ibm_is_lb.basic_networking_lb.*.id, count.index)}"
  pool           = "${replace("${element(ibm_is_lb_pool.basic_networking_lb_pool.*.id, count.index)}", "/.+//", "" )}" // ibm_is_lb_pool.basic_networking_app_pool.id
  port           = 80
  target_address = "${element(ibm_is_instance.basic_networking_is.*.primary_network_interface.0.primary_ipv4_address, count.index)}"
  weight         = 50
}

resource "ibm_is_lb_listener" "basic_networking_lb_listener" {
  count        = "2"
  lb           = "${element(ibm_is_lb.basic_networking_lb.*.id, count.index)}"
  port         = "${count.index == 0 ? 80 : 3306}"
  protocol     = "http"
  default_pool = "${replace("${element(ibm_is_lb_pool.basic_networking_lb_pool.*.id, count.index)}", "/.+//", "" )}"
}
