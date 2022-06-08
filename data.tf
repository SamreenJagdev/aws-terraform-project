###################DATA FILE######################
/* data "aws_vpc" "selected"{
  filter {
    name= "tag:Name"
    values= ["main"]
  }
} */

data "aws_subnet" "selected" {
  filter{
    name = "tag:Name"
    values = [ var.subnet_name ]
  } 
} 