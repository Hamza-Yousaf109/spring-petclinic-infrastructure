output "configuration" {
  description = "KMS key ARN used for EKS secrets encryption."
  value       = aws_kms_key.eks.arn
}