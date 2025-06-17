variable "PREFIX" {
  type        = string
  description = "Prefix for all the resources"

}

variable "ENVIRONMENT" {
  type        = string
  description = "Environment of the resources"
}

variable "REGION" {
  type        = string
  description = "Region where the resources are deployed"
}

variable "VPC_CIDR_BLOCK" {
  type        = string
  description = "CIDR Block for the VPC"
}

variable "NAT_GATEWAY_CIDR_BLOCK" {
  type        = string
  description = "CIDR block for the NAT Gateway (keep it as small as possible)"

}

variable "subnets" {
  type = map(object({
    subnet_cidr = string
    public      = bool
  }))
  description = "Map of Subnets"

}
