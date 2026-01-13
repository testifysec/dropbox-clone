output "app_role_arn" {
  description = "ARN of the IAM role for application pods"
  value       = aws_iam_role.app.arn
}

output "app_role_name" {
  description = "Name of the IAM role for application pods"
  value       = aws_iam_role.app.name
}

output "github_actions_role_arn" {
  description = "ARN of the IAM role for GitHub Actions"
  value       = var.create_github_oidc ? aws_iam_role.github_actions[0].arn : ""
}

output "github_oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  value       = var.create_github_oidc ? aws_iam_openid_connect_provider.github[0].arn : ""
}
