variable "rg_name" {
  type        = string
  default     = "RG-DEVTEST-EU01"
  description = "Resource group name."
}

variable "rg_location" {
  type        = string
  default     = "East US"
  description = "Resource group location."
}

variable "vnet_name" {
  type        = string
  default     = "VNET-DEVTEST-EU01"
  description = "Virtual network name."
}

variable "subnet_address" {
  type = map
  default = {
      "BACKEND-PROD-SUB-DEVTEST-EU01" = "10.0.3.0/24"
      "BACKEND-STAG-SUB-DEVTEST-EU01" = "10.0.5.0/24"
    }
  description = "Backend Subnet address."
}

variable "mysql_server_name" {
  type        = string
  default     = "mysqldevtest1"
  description = "Server name."
}

variable "admin_username" {
  type        = string
  default     = "admin"
  description = "Admin name."
}

variable "admin_password" {
  type        = string
  default     = ""
  description = "Admin password."
}