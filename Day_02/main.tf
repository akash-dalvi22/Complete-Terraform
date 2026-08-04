provider "github" {
  token = ""
}

resource "github_repository" "first_repo" {
  name        = "sample-repo"
  description = "This resource created by Terraform"

  visibility = "public"
  auto_init = true

}
