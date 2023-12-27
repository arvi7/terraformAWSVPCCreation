# public_subnets which contain all values required for public subnets in our VPC
variable "public_subnets" {
  description = "The list of strings which consist 3 public subnet values."
  type = list(string)
  default = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
}

# private_subnets which contain all values required for private subnets in our VPC
variable "private_subnets" {
  description = "The list of strings which consist 3 private subnet values."
  type = list(string)
  default = ["10.0.4.0/24","10.0.5.0/24","10.0.6.0/24"]
}

# variable azs where we will deploy our subnets.
variable "azs" {
    description = "Availability Zones for the subnets"
    type = list(string)
    default = [ "us-east-1", "us-east-2", "us-west-1" ]
  
}