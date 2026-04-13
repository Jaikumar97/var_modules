resource "aws_instance" "app" {
  count         = 2
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.private_subnets[count.index]
  key_name      = var.key_name

  user_data = file("${path.module}/docker_setup.sh")
}