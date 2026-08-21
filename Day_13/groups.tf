resource "aws_iam_group" "education" {   
  name = "Education"
  path = "/groups/"
}

resource "aws_iam_group" "engineer" { 
  name = "Engineer"
  path = "/groups/"
}

resource "aws_iam_group" "manager" {
  name = "Manager"
  path = "/groups/"
}

resource "aws_iam_group_membership" "education_membership" {
  name = "education-membership"
  group = aws_iam_group.education.name

  users = [
    for user in aws_iam_user.users : user.name if user.tags.Department == "Education"
  ]
}
resource "aws_iam_group_membership" "engineer_membership" {
  name = "engineer-membership"
  group = aws_iam_group.engineer.name

  users = [
    for user in aws_iam_user.users : user.name if user.tags.Department == "Engineering"
  ]
}

resource "aws_iam_group_membership" "manager_membership" {
  name = "manager-membership"
  group = aws_iam_group.manager.name

  users = [
    for user in aws_iam_user.users : user.name if strcontains(user.tags.JobTitle, "Manager")
  ]
}