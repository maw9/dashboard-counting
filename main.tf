# VPC & subnets
resource "aws_vpc" "main" {
  cidr_block           = var.vpc-cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public-subnet-1-cidr
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public-subnet-2-cidr
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
  }
}

resource "aws_subnet" "public-subnet-3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public-subnet-3-cidr
  availability_zone       = "ap-southeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-3"
  }
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private-subnet-1-cidr
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private-subnet-2-cidr
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "private-subnet-2"
  }
}

resource "aws_subnet" "private-subnet-3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private-subnet-3-cidr
  availability_zone = "ap-southeast-1c"

  tags = {
    Name = "private-subnet-3"
  }
}

resource "aws_subnet" "private-subnet-4" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private-subnet-4-cidr
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "private-subnet-4"
  }
}

resource "aws_subnet" "private-subnet-5" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private-subnet-5-cidr
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "private-subnet-5"
  }
}

resource "aws_subnet" "private-subnet-6" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private-subnet-6-cidr
  availability_zone = "ap-southeast-1c"

  tags = {
    Name = "private-subnet-6"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my-igw"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-RT"
  }
}

resource "aws_route_table_association" "pub_rt_pub_subnet_1_association" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "pub_rt_pub_subnet_2_association" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "pub_rt_pub_subnet_3_association" {
  subnet_id      = aws_subnet.public-subnet-3.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-RT"
  }
}

resource "aws_route_table_association" "pri_rt_pri_subnet_1_association" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "pri_rt_pri_subnet_2_association" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "pri_rt_pri_subnet_3_association" {
  subnet_id      = aws_subnet.private-subnet-3.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "pri_rt_pri_subnet_4_association" {
  subnet_id      = aws_subnet.private-subnet-4.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "pri_rt_pri_subnet_5_association" {
  subnet_id      = aws_subnet.private-subnet-5.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "pri_rt_pri_subnet_6_association" {
  subnet_id      = aws_subnet.private-subnet-6.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_eip" "my-eip" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "my-nat" {
  allocation_id     = aws_eip.my-eip.id
  subnet_id         = aws_subnet.public-subnet-2.id
  availability_mode = "zonal"
  connectivity_type = "public"

  tags = {
    Name = "nat-gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route" "nat-route" {
  route_table_id         = aws_route_table.private-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.my-nat.id
}

resource "aws_security_group" "public-sgp" {
  name        = "public-sgp"
  description = "Security group for public instance"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "public-sgp"
  }
}

resource "aws_security_group_rule" "public-sgp-ssh-inbound" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.public-sgp.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "public-sgp-allow-all-outbound" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  security_group_id = aws_security_group.public-sgp.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "dashboard-sgp" {
  name        = "dashboard-sgp"
  description = "Security group for dashboard service"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "dashboard-sgp"
  }
}

resource "aws_security_group_rule" "dashboard-sgp-ssh-inbound" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.dashboard-sgp.id
  source_security_group_id = aws_security_group.public-sgp.id
}

resource "aws_security_group_rule" "dashboard-sgp-tcp8080-inbound" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.dashboard-sgp.id
  source_security_group_id = aws_security_group.dashboard-alb-sgp.id
}

resource "aws_security_group_rule" "dashboard-sgp-allow-all-outbound" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  security_group_id = aws_security_group.dashboard-sgp.id
  cidr_blocks       = ["0.0.0.0/0"]
}

// ami-0532913178263be11
// key => dev-sg
resource "aws_instance" "console" {
  ami                    = "ami-0532913178263be11"
  instance_type          = "t3.micro"
  availability_zone      = "ap-southeast-1b"
  key_name               = "dev-sg"
  vpc_security_group_ids = [aws_security_group.public-sgp.id]
  subnet_id              = aws_subnet.public-subnet-2.id

  tags = {
    Name = "console"
  }
}

resource "aws_security_group" "dashboard-alb-sgp" {
  name        = "dashboard-alb-sgp"
  description = "Security group for dashboard ALB"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "dashboard-alb-sgp"
  }
}

resource "aws_security_group_rule" "dashboard-alb-sgp-allow-http-inbound" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.dashboard-alb-sgp.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "dashboard-alb-sgp-allow-all-outbound" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  security_group_id = aws_security_group.dashboard-alb-sgp.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_lb" "dashboard-alb" {
  name               = "dashboard-alb"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups    = [aws_security_group.dashboard-alb-sgp.id]
  subnets = [
    aws_subnet.public-subnet-1.id,
    aws_subnet.public-subnet-2.id,
    aws_subnet.public-subnet-3.id,
  ]
}

resource "aws_lb_target_group" "dashboard-target-gp" {
  name                 = "dashboard-target-gp"
  port                 = 8080
  protocol             = "HTTP"
  vpc_id               = aws_vpc.main.id
  deregistration_delay = "10"
}

resource "aws_lb_listener" "dashboard-listener" {
  load_balancer_arn = aws_lb.dashboard-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashboard-target-gp.arn
  }
}

resource "aws_launch_template" "dashboard-template" {
  name          = "dashboard-template"
  image_id      = "ami-0532913178263be11"
  instance_type = "t3.micro"
  key_name      = "dev-sg"
  vpc_security_group_ids = [
    aws_security_group.dashboard-sgp.id
  ]
  #   user_data = filebase64("${path.module}/user-data/dashboard_user_data.txt")
  user_data = base64encode(templatefile(
    "${path.module}/user-data/dashboard_user_data.txt",
    {
      counting_service_url = "http://${aws_route53_record.counting-record.fqdn}:8090",
    }
  ))
}

resource "aws_autoscaling_group" "dashboard-asg" {
  desired_capacity = 2
  max_size         = 3
  min_size         = 2
  vpc_zone_identifier = [
    aws_subnet.private-subnet-4.id,
    aws_subnet.private-subnet-5.id,
    aws_subnet.private-subnet-6.id
  ]

  launch_template {
    id      = aws_launch_template.dashboard-template.id
    version = "$Latest"
  }
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "dashboard-asg-target-gp-attachment" {
  autoscaling_group_name = aws_autoscaling_group.dashboard-asg.id
  lb_target_group_arn    = aws_lb_target_group.dashboard-target-gp.arn
}

resource "aws_security_group" "counting-alb-sgp" {
  name        = "counting-alb-sgp"
  description = "Security group for counting ALB"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "counting-alb-sgp"
  }
}

resource "aws_security_group_rule" "counting-alb-sgp-allow-http-inbound" {
  type                     = "ingress"
  from_port                = 8090
  to_port                  = 8090
  protocol                 = "tcp"
  security_group_id        = aws_security_group.counting-alb-sgp.id
  source_security_group_id = aws_security_group.dashboard-sgp.id
}

resource "aws_security_group_rule" "counting-alb-sgp-allow-all-outbound" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  security_group_id = aws_security_group.counting-alb-sgp.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_lb" "counting-alb" {
  name               = "counting-alb"
  internal           = true
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups    = [aws_security_group.counting-alb-sgp.id]
  subnets = [
    aws_subnet.private-subnet-4.id,
    aws_subnet.private-subnet-5.id,
    aws_subnet.private-subnet-6.id,
  ]
}

resource "aws_lb_target_group" "counting-target-gp" {
  name                 = "counting-target-gp"
  port                 = 8090
  protocol             = "HTTP"
  vpc_id               = aws_vpc.main.id
  deregistration_delay = "10"
}

resource "aws_lb_listener" "counting-listener" {
  load_balancer_arn = aws_lb.counting-alb.arn
  port              = 8090
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.counting-target-gp.arn
  }
}

resource "aws_security_group" "counting-sgp" {
  name        = "counting-sgp"
  description = "Security group for counting service"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "counting-sgp"
  }
}

resource "aws_security_group_rule" "counting-sgp-ssh-inbound" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.counting-sgp.id
  source_security_group_id = aws_security_group.public-sgp.id
}

resource "aws_security_group_rule" "dashboard-sgp-tcp8090-inbound" {
  type                     = "ingress"
  from_port                = 8090
  to_port                  = 8090
  protocol                 = "tcp"
  security_group_id        = aws_security_group.counting-sgp.id
  source_security_group_id = aws_security_group.counting-alb-sgp.id
}

resource "aws_security_group_rule" "counting-sgp-allow-all-outbound" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  security_group_id = aws_security_group.counting-sgp.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_launch_template" "counting-template" {
  name          = "counting-template"
  image_id      = "ami-0532913178263be11"
  instance_type = "t3.micro"
  key_name      = "dev-sg"
  vpc_security_group_ids = [
    aws_security_group.counting-sgp.id
  ]
  user_data = filebase64("${path.module}/user-data/counting_user_data.txt")
}

resource "aws_autoscaling_group" "counting-asg" {
  desired_capacity = 2
  max_size         = 3
  min_size         = 2
  vpc_zone_identifier = [
    aws_subnet.private-subnet-1.id,
    aws_subnet.private-subnet-2.id,
    aws_subnet.private-subnet-3.id
  ]

  launch_template {
    id      = aws_launch_template.counting-template.id
    version = "$Latest"
  }
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "counting-asg-target-gp-attachment" {
  autoscaling_group_name = aws_autoscaling_group.counting-asg.id
  lb_target_group_arn    = aws_lb_target_group.counting-target-gp.arn
}

# Private Hosted Zone for Route 53
resource "aws_route53_zone" "private" {
  name = "team9.ai"

  vpc {
    vpc_id = aws_vpc.main.id
  }
}

resource "aws_route53_record" "dashboard-record" {
  zone_id = aws_route53_zone.private.id
  name    = "dashboard"
  type    = "A"

  alias {
    name                   = aws_lb.dashboard-alb.dns_name
    zone_id                = aws_lb.dashboard-alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "counting-record" {
  zone_id = aws_route53_zone.private.id
  name    = "counting"
  type    = "A"

  alias {
    name                   = aws_lb.counting-alb.dns_name
    zone_id                = aws_lb.counting-alb.zone_id
    evaluate_target_health = true
  }
}

