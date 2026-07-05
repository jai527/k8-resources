locals {
  common_tags = {
    project = var.project
    environment = var.environment
    terraform = true
  }
  igw_final_tags = merge(
    {
        Name = "${var.project}-${var.environment}"
    }
  )
  ami_id = data.aws_ami.joindevops.id
}