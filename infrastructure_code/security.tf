resource "ibm_is_network_acl" "basic_networking_acl" {
  name = "basic_networking_acl"
  rules=[
    {
        name = "egress"
        action = "allow"
        source = "${var.access_to_any_ip}"
        destination = "${var.access_to_any_ip}"
        direction = "egress"
        icmp {
          code = 1
          type = 1
        }
    },
    {
        name = "ingress"
        action = "allow"
        source = "${var.access_to_any_ip}"
        destination = "${var.access_to_any_ip}"
        direction = "ingress"
        icmp {
          code = 1
          type = 1
        }
    }
  ]
}

resource "ibm_is_security_group" "basic_networking_security_group" {
    count = "2"
    name  = "bn_${count.index == 0 ? "data" : "app"}_sg_1"
    vpc   = "${ibm_is_vpc.basic_networking_vpc.id}"
}

resource "ibm_is_security_group_rule" "basic_networking_security_group_rule_all" {
    count     = "2"
    group     = "${element(ibm_is_security_group.basic_networking_security_group.*.id, count.index)}"
    direction = "egress"
    remote    = "${count.index == 0 ? ibm_is_security_group.basic_networking_security_group.0.id : ibm_is_lb.basic_networking_lb.0.private_ips[0]}"
}

resource "ibm_is_security_group_rule" "basic_networking_app_security_rule1" {
    group = "${element(ibm_is_security_group.basic_networking_security_group.*.id, 1)}"
    direction = "ingress"
    remote = "${var.access_to_any_ip}"
    tcp = {
        port_min = 22
        port_max = 22
    }
}

resource "ibm_is_security_group_rule" "basic_networking_app_security_rule2" {
    group = "${element(ibm_is_security_group.basic_networking_security_group.*.id, 1)}"
    direction = "ingress"
    remote = "${var.access_to_any_ip}"
    tcp = {
        port_min = 80
        port_max = 80
    }
}

resource "ibm_is_security_group_rule" "basic_networking_data_security_rule" {
   group = "${element(ibm_is_security_group.basic_networking_security_group.*.id, 0)}"
   direction = "ingress"
   remote = "${var.access_to_any_ip}"
   tcp = {
       port_min = 3306
       port_max = 3306
   }
}