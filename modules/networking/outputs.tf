output "configuration" {
  description = "Networking identifiers used by the EKS module."
  value = {
    vpc_id             = aws_vpc.petclinic.id
    public_subnet_ids  = aws_subnet.public[*].id
    private_subnet_ids = aws_subnet.private[*].id
    nat_gateway_ids    = aws_nat_gateway.petclinic[*].id
  }
}