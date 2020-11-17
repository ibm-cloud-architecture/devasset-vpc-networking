resource "ibm_is_network_acl" "basic-networking-acl" {
  name = "basic-networking-acl"
  rules {
    name        = "egress"
    action      = "allow"
    source      = var.access-to-any-ip
    destination = var.access-to-any-ip
    direction   = "inbound"
    icmp {
      code = 1
      type = 1
    }
  }
  rules {
    name        = "ingress"
    action      = "allow"
    source      = var.access-to-any-ip
    destination = var.access-to-any-ip
    direction   = "inbound"
    icmp {
      code = 1
      type = 1
    }
  }
}

resource "ibm_is_security_group" "basic-networking-security-group" {
  count = "2"
  name  = "bn-${count.index == 0 ? "data" : "app"}-sg-1"
  vpc   = ibm_is_vpc.basic-networking-vpc.id
}

resource "ibm_is_security_group_rule" "basic-networking-security-group-rule-all" {
  count = "2"
  group = element(
    ibm_is_security_group.basic-networking-security-group.*.id,
    count.index,
  )
  direction = "outbound"
  remote    = count.index == 0 ? ibm_is_security_group.basic-networking-security-group[0].id : ibm_is_lb.basic-networking-lb.0.private_ips[0]
}

resource "ibm_is_security_group_rule" "basic-networking-app-security-rule1" {
  group = element(
    ibm_is_security_group.basic-networking-security-group.*.id,
    1,
  )
  direction = "inbound"
  remote    = var.access-to-any-ip
  tcp {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "basic-networking-app-security-rule2" {
  group = element(
    ibm_is_security_group.basic-networking-security-group.*.id,
    1,
  )
  direction = "inbound"
  remote    = var.access-to-any-ip
  tcp {
    port_min = 80
    port_max = 80
  }
}

resource "ibm_is_security_group_rule" "basic-networking-data-security-rule" {
  group = element(
    ibm_is_security_group.basic-networking-security-group.*.id,
    0,
  )
  direction = "inbound"
  remote    = var.access-to-any-ip
  tcp {
    port_min = 3306
    port_max = 3306
  }
}

