variable "resource_group_name" {
	default = "sandbox"
	description = "Name of the resource group."
}

variable "resource_group_location" {
	default = "eastus"
	description = "Location of the resource group."
}

variable "storage_name" {
	default = "stgsandbox1"
	description = "Storage account Name"
}

variable "storage_container_name" {
	default = "cnsandbox"
	description = "Storage account container name"
}

variable "computer_name" {
	default = "flask"
	description = "Virtual machine hostname."
}

variable "admin_user" {
	default = "LogisticaSur"
	description = "Name of the admin user."
}
