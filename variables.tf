variable "region" {
  description = "The AWS region to deploy the ALB"
  type        = string
  default     = "us-east-2"  
}
variable "alb_name" {
  description = "The name of the Application Load Balancer"
  type        = string
  default     = "my-alb"
}
variable "alb_internal" {
  description = "Whether the load balancer is internal or external"
  type        = bool
  default     = false
}

variable "security_group_id" {
  description = "The ID of the security group to assign to the load balancer"
  type        = string
  default     = "sg-0d56d6beb4c1bc48f"
}

variable "subnet_id" {
  description = "The ID of the subnet to attach to the load balancer"
  type        = string
  default     = "subnet-062078177a35b5fbb"
}

variable "enable_deletion_protection" {
  description = "Whether deletion protection is enabled"
  type        = bool
