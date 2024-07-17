variable "region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-west-2"
}

variable "alb_name" {
  description = "The name of the ALB."
  type        = string
}

variable "alb_internal" {
  description = "Whether the ALB is internal."
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "The VPC ID where resources will be created."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs."
  type        = list(string)
}

variable "subnet_cidrs" {
  description = "List of subnet CIDR blocks."
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "Whether to enable deletion protection for the ALB."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to be applied to resources."
  type        = map(string)
  default     = {}
}

variable "security_groups" {
  description = "A list of security group IDs to assign to the load balancer"
  type        = list(string)
}

variable "subnets" {
  description = "A list of subnet IDs to attach to the load balancer"
  type        = list(string)
}
