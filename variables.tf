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

variable "security_groups" {
  description = "A list of security group IDs to assign to the load balancer"
  type        = list(string)
  default     = ["sg-0d56d6beb4c1bc48f"]
}

variable "subnets" {
  description = "The IDs of the subnets to attach to the load balancer"
  type        = list(string)
  default     = ["subnet-062078177a35b5fbb"]
}

variable "enable_deletion_protection" {
  description = "Whether deletion protection is enabled"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {}
}
