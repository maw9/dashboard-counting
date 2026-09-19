variable "vpc-region" {
  type    = string
  default = "ap-southeast-1"
}

variable "vpc-cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public-subnet-1-cidr" {
  type    = string
  default = "10.0.112.0/20"
}

variable "public-subnet-2-cidr" {
  type    = string
  default = "10.0.96.0/20"
}

variable "public-subnet-3-cidr" {
  type    = string
  default = "10.0.128.0/20"
}

variable "private-subnet-1-cidr" {
  type    = string
  default = "10.0.16.0/20"
}

variable "private-subnet-2-cidr" {
  type    = string
  default = "10.0.32.0/20"
}

variable "private-subnet-3-cidr" {
  type    = string
  default = "10.0.48.0/20"
}

variable "private-subnet-4-cidr" {
  type    = string
  default = "10.0.0.0/20"
}

variable "private-subnet-5-cidr" {
  type    = string
  default = "10.0.64.0/20"
}

variable "private-subnet-6-cidr" {
  type    = string
  default = "10.0.80.0/20"
}

