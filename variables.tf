# General Variables
variable "project_name" {
    type = string
    description = "(Requiered) Project Name"
}
variable "location" {
    type = string
    description = "(Required) Resources location"
}

variable "tags" {
    type = map(any)
    description = "(Optional) A mapping of tags to assign to the resource"
    default = {
        "project" = "personal-resume"
    }
}

# Cosmos DB Variables
variable "sql_db_name" {
    type = string
    description = "(Required) SQL db name"
}
variable "sql_db_container_name" {
    type = string
    description = "(Required) SQL container name"
}