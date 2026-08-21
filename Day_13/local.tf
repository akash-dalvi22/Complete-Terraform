locals {
  users = csvdecode(file("${path.module}/users.csv"))
}
