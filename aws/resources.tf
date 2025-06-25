module "craftista_vpc" {
  source                 = "./modules/vpc"
  PREFIX                 = "craftista"
  REGION                 = "eu-central-1"
  ENVIRONMENT            = "development"
  VPC_CIDR_BLOCK         = "10.0.0.0/16"
  NAT_GATEWAY_CIDR_BLOCK = "10.0.0.0/28"
  subnets = {
    "web" = {
      subnet_cidr = "10.0.10.0/24",
      public      = true
    },
    "app" = {
      subnet_cidr = "10.0.15.0/24",
      public      = true
    }
  }
}


