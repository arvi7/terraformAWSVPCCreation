# terraformProjects
In this Project we are mainly focusing on creating a AWS VPC , along with public and private subnets also create a Second RouteTable and associate it with public subnets.

---> AWS VPC
A Virtual Private Cloud is something like your own space(Maybe a Kingdom in World Cloud) in the vast world of Cloud. where we can create organize and implement our own infrastruture.
we can control in the incoming and outgoing traffic(like an immigration check in real world)

How to Declare a AWS VPC in Terraform:

we have to use Resources tag with "AWS_VPC", we should also mainly declare CIDR block with
a Range of IP addresses defined.

ex:
resource "aws_vpc" "webapp_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "webapp_vpc_tag"
  }
}

Here the name the tag attribute is optional which will be helpul for us to identify the resource in the vast infra resources of our cloud provider.

-->Subnet:
We can further divide a VPC into subnets, to be clear it is something like assigning a set of ip address from CIDR block. These subnets are 2 types public and private subnets.
--> AWS Public Subnets
Public subnets are subnets which can be accessed from Internet through Internet Gateway.
ex:
resource "aws_subnet" "public_subnets" {
  vpc_id = aws_vpc.webapp_vpc.id
  count = length(var.public_subnets)
  cidr_block = element(var.public_subnets,count.index)
  availability_zone = element(var.azs,count.index)
  tags = {
    Name = "Public subnet ${count.index+1} tag"
  }
}
Here we mainly have tags like vpc_id, cidr_block
vpc_id is to attach this subnet to this specific VPC
cidr_block is to specify the amount of ip address in the subnet.
--> AWS Private Subnets
Private Subnets are not accessable from Internet except from any other resource with in VPC
--> AWS Internet Gateway
Internet Gateway(IGW) is a VPC component which will allow or block communication between intances and public subnets in your VPC to Internet.
ex:
resource "aws_internet_gateway" "IG" {
    vpc_id = aws_vpc.webapp_vpc.id
    tags = {
      Name = "Internet Gateway tag"
    }
}
Here we mainly have tags like vpc_id, and tag Name is optional
vpc_id is to attach this subnet to this specific VPC

How to Run this Project:
-->Go to directory where main.tf is present, and intialize terraform with command
 "Terraform init"

-->The next command is "Terraform Plan"
This command will provide a detailed analysis where all the changes that are shown on your command line.
if you are not satisfied with any of those changes , you can make changes in the code again.

-->Once if you are satisfied with all the changes the next command will be "Terraform Apply"
This command will execute the new required changes in the infrastructure.