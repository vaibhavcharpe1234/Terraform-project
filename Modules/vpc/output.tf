output "pri-sub-1-id" {
  value = aws_subnet.Private-sub-1.id
}

output "pri-sub-2-id" {
  value = aws_subnet.Private-sub-2.id
}

output "pub-sub-1-id" {
  value = aws_subnet.Public-sub-1.id
}

output "vpc-id-value" {
  value = aws_vpc.my-vpc.id
}

output "cidr_block_value" {
  value = aws_vpc.my-vpc.cidr_block
}