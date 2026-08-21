output "user_password" {
  value = {
    for user,profile in aws_iam_user_login_profile.user_login_profile : 
    user => "Password created - user must reset password on first login"
  }
}