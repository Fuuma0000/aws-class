variable "name" {
    description = "The name of the server"
    type = string
}

variable "subnet_id" {
    description = "The ID of the subnet to create the security group in."
    type = string
}

variable "security_group_id" {
    description = "The ID of the security group."
    type = string
}

variable "key_pair_name" {
    description = "The name of the key pair."
    type = string
}
