variable "region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-west-2"
}

variable "instance_type" {
  description = "The instance type for the EC2 instance."
  type        = string
  default     = "t2.micro"
}

variable "hcp_bucket_ubuntu" {
  description = "The HCP Packer bucket name for the Ubuntu image."
  type        = string
}

variable "hcp_channel" {
  description = "The HCP Packer channel for the Ubuntu image."
  type        = string
}

variable "cidr_vpc" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "cidr_subnet" {
  description = "The CIDR block for the subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "tags" {
  description = "Tags to be applied to resources."
  type        = map(string)
  default     = {}
}
