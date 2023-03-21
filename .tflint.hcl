plugin "aws" {
    enabled = true
    version = "0.21.1"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

config {
#Enables module inspection
module = false
force = false
}

# Required that all AWS resources have specified tags.
rule "aws_resource_missing_tags" {
  enabled = true
  tags = [
    "Name",
    "Environment",
  ]
}

# Disallow deprecated (0.11-style) interpolation
rule "terraform_deprecated_interpolation" {
enabled = true
}

# Disallow legacy dot index syntax.
rule "terraform_deprecated_index" {
enabled = true
}

# Disallow variables, data sources, and locals that are declared but never used.
rule "terraform_unused_declarations" {
enabled = true
}

# Disallow // comments in favor of #.
rule "terraform_comment_syntax" {
enabled = false
}

# Disallow output declarations without description.
rule "terraform_documented_outputs" {
enabled = true
}

# Disallow variable declarations without description.
rule "terraform_documented_variables" {
enabled = true
}

# Disallow variable declarations without type.
rule "terraform_typed_variables" {
enabled = true
}

# Disallow specifying a git or mercurial repository as a module source without pinning to a version.
rule "terraform_module_pinned_source" {
enabled = true
}

# Enforces naming conventions
rule "terraform_naming_convention" {
enabled = true

#Require specific naming structure
variable {
format = "snake_case"
}

locals {
format = "snake_case"
}

output {
format = "snake_case"
}

#Allow any format
resource {
format = "none"
}

module {
format = "none"
}

data {
format = "none"
}

}

# Disallow terraform declarations without require_version.
rule "terraform_required_version" {
enabled = true
}

# Require that all providers have version constraints through required_providers.
rule "terraform_required_providers" {
enabled = true
}

# Ensure that a module complies with the Terraform Standard Module Structure
rule "terraform_standard_module_structure" {
enabled = true
}

# terraform.workspace should not be used with a "remote" backend with remote execution.
rule "terraform_workspace_remote" {
enabled = true
}
