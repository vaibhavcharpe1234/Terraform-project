module "vpc" {
  source = "../Modules/vpc"
  cidr_block_value = "10.0.0.0/16"
  cidr_block_value_Public-sub-1 = "10.0.1.0/24"
  cidr_block_value_Public-sub-2 = "10.0.2.0/24"
  cidr_block_value_Private-sub-1 = "10.0.3.0/24"
  cidr_block_value_Private-sub-2 = "10.0.4.0/24"
}

module "ec2" {
  source = "../Modules/ec2"
  pri-sub-1-id = module.vpc.pri-sub-1-id
  pri-sub-2-id = module.vpc.pri-sub-2-id
  pub-sub-1-id = module.vpc.pub-sub-1-id
  vpc-id-value = module.vpc.vpc-id-value
  cidr_block_value = module.vpc.cidr_block_value
  ami-id-value = "ami-03f0544597f43a91d"
  instance_type_value = "t2.micro"
}