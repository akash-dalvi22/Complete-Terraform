resource "aws_iam_user" "user" {
  for_each = {for user in local.users: user.first_name => user}
  name = "${substr(each.value.first_name, 0, 1)}${each.value.last_name}"

  path = "/users/"

  tags = {
    DisplayName = "${each.value.first_name} ${each.value.last_name}"
    Department  = each.value.department
    JobTitle    = each.value.job_title
  }
}
