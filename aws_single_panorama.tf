/*
  Create the VPC
*/
resource "aws_vpc" "main" {
  cidr_block = "${var.vpccidr}"

  tags = {
    "Project" = "${var.tags}"
    "Name"    = "${var.vpcname}"
  }
}

resource "aws_subnet" "publicsubnet" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.publicsubnetcidr}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  #map_public_ip_on_launch = true
  tags {
    "Name"    = "publicsubnet"
    "Project" = "${var.tags}"
  }
}

resource "aws_vpc_dhcp_options" "dopt21c7d043" {
  domain_name         = "us-west-2.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]
}

resource "aws_network_acl" "aclb765d6d2" {
  vpc_id = "${aws_vpc.main.id}"

  subnet_ids = [
    "${aws_subnet.publicsubnet.id}",
  ]
}

resource "aws_network_acl_rule" "acl1" {
  network_acl_id = "${aws_network_acl.aclb765d6d2.id}"
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "acl2" {
  network_acl_id = "${aws_network_acl.aclb765d6d2.id}"
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_route_table" "publicroutetable" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    "Name"    = "publicroutetable"
    "Project" = "${var.tags}"
  }
}

resource "aws_network_interface" "panoramamanagementeth0" {
  subnet_id       = "${aws_subnet.publicsubnet.id}"
  security_groups = ["${aws_security_group.sgWideOpen.id}"]

  tags {
    "Name"    = "panoramamanagementeth0"
    "Project" = "${var.tags}"
  }
}

resource "aws_eip" "managementelasticip" {
  vpc        = true
  depends_on = ["aws_vpc.main", "aws_internet_gateway.internetgateway"]

  tags {
    "Name"    = "panoramamanagementeip"
    "Project" = "${var.tags}"
  }
}

resource "aws_internet_gateway" "internetgateway" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    "Name"    = "internetgateway"
    "Project" = "${var.tags}"
  }
}

resource "aws_eip_association" "panoramaeipmanagementassociation" {
  network_interface_id = "${aws_network_interface.panoramamanagementeth0.id}"
  allocation_id        = "${aws_eip.managementelasticip.id}"
}

resource "aws_route_table_association" "publicsubnetroute" {
  subnet_id      = "${aws_subnet.publicsubnet.id}"
  route_table_id = "${aws_route_table.publicroutetable.id}"
}

resource "aws_route" "igwroute" {
  route_table_id         = "${aws_route_table.publicroutetable.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internetgateway.id}"
}

resource "aws_vpc_dhcp_options_association" "dchpassoc1" {
  vpc_id          = "${aws_vpc.main.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dopt21c7d043.id}"
}

resource "aws_security_group" "sgWideOpen" {
  name        = "sgWideOpen"
  description = "Wide open security group"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    "Name"    = "wideopensecuritygroup"
    "Project" = "${var.tags}"
  }
}

resource "aws_instance" "panoramainstance" {
  disable_api_termination              = false
  instance_initiated_shutdown_behavior = "stop"
  ebs_optimized                        = true
  ami                                  = "${var.panoramaregionmappanos812[var.aws_region]}"
  instance_type                        = "m4.2xlarge"

  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_type           = "gp2"
    delete_on_termination = true
    volume_size           = 81
  }

  key_name   = "${var.serverkeyname}"
  monitoring = false

  network_interface {
    device_index         = 0
    network_interface_id = "${aws_network_interface.panoramamanagementeth0.id}"
  }

  tags {
    "Name"    = "panorama"
    "Project" = "${var.tags}"
  }
}

output "PanoramaManagementURL" {
  value = "${join("", list("https://", "${aws_eip.managementelasticip.public_ip}"))}"
}
