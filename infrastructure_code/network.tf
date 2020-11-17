# This file creates the network components for the vpc that will be used by the compute 
# resources. The vpc includes the vpc, gateway, subnets and load balancers.

# Create an IBM Cloud infrastructure SSH key. You can find the SSH key surfaces in the infrastructure console under Devices > Manage > SSH Keys
resource "ibm_is_ssh_key" "basic-networking-key" {
  name       = "basic-networking-key"
  public_key = var.ssh-key
}

# Create a IS VPC and instance
resource "ibm_is_vpc" "basic-networking-vpc" {
  name = "basic-networking-vpc"
}

resource "ibm_is_vpc_address_prefix" "basic-networking-prefix" {
  count = "2"
  name  = "basic-networking-prefix-${count.index + 1}"
  zone  = var.availability-zone
  vpc   = ibm_is_vpc.basic-networking-vpc.id
  cidr  = count.index == 0 ? var.address-prefix1 : var.address-prefix2
}

resource "ibm_is_public_gateway" "basic-networking-gateway" {
  name = "basic-networking-gateway"
  vpc  = ibm_is_vpc.basic-networking-vpc.id
  zone = var.availability-zone
}

resource "ibm_is_subnet" "basic-networking-subnet" {
  count = "2"
  name  = "basic-networking-subnet-${count.index + 1}"
  vpc   = ibm_is_vpc.basic-networking-vpc.id
  zone  = var.availability-zone
  ipv4_cidr_block = element(
    ibm_is_vpc_address_prefix.basic-networking-prefix.*.cidr,
    count.index,
  )
  public_gateway = ibm_is_public_gateway.basic-networking-gateway.id
}

resource "ibm_is_lb" "basic-networking-lb" {
  count          = "2"
  name           = "bn-${count.index == 0 ? "app" : "data"}-lb"
  subnets        = [element(ibm_is_subnet.basic-networking-subnet.*.id, count.index)]
  resource_group = var.resource-group
  type           = count.index == 0 ? "public" : "private"
}

resource "ibm_is_lb_pool" "basic-networking-lb-pool" {
  count          = "2"
  name           = "bn-${count.index == 0 ? "app" : "data"}-lb-pool"
  lb             = element(ibm_is_lb.basic-networking-lb.*.id, count.index)
  algorithm      = count.index == 0 ? "round_robin" : "least_connections"
  protocol       = "http"
  health_delay   = 20
  health_retries = 3
  health_timeout = 5
  health_type    = "http"
}

resource "ibm_is_lb_pool_member" "basic-networking-lb_mem" {
  count = "2"
  lb    = element(ibm_is_lb.basic-networking-lb.*.id, count.index)
  pool = replace(
    element(ibm_is_lb_pool.basic-networking-lb-pool.*.id, count.index),
    "/.+//",
    "",
  ) // ibm_is_lb_pool.basic-networking-app-pool.id
  port = 80
  target_address = element(
    ibm_is_instance.basic-networking-is.*.primary_network_interface.0.primary_ipv4_address,
    count.index,
  )
  weight = 50
}

resource "ibm_is_lb_listener" "basic-networking-lb-listener" {
  count    = "2"
  lb       = element(ibm_is_lb.basic-networking-lb.*.id, count.index)
  port     = count.index == 0 ? 80 : 3306
  protocol = "http"
  default_pool = replace(
    element(ibm_is_lb_pool.basic-networking-lb-pool.*.id, count.index),
    "/.+//",
    "",
  )
}

