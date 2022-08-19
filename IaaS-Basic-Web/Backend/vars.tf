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
      "BACKEND-PROD-SUB-DEVTEST-EU01" = "10.0.2.0/24"
      "BACKEND-STAG-SUB-DEVTEST-EU01" = "10.0.3.0/24"
    }
  description = "Backend Subnet address."
}

variable "nic_subnet" {
  type = map
  default = {
      "BACKEND-PROD-NIC-DEVTEST-EU01" = "BACKEND-PROD-SUB-DEVTEST-EU01"
      "BACKEND-STAG-NIC-DEVTEST-EU01" = "BACKEND-STAG-SUB-DEVTEST-EU01"
    }
  description = "Backend network interface."
}

variable "nsg_prod_name" {
  type        = string
  default     = "BACKEND-PROD-NSG-DEVTEST-EU01"
  description = "Production Network security group."
}

variable "nsg_stag_name" {
  type        = string
  default     = "BACKEND-STAG-NSG-DEVTEST-EU01"
  description = "Staging Network security group."
}

variable "vm_nic" {
  type = map
  default = {
	
      "BACKEND-PROD-VM-DEVTEST-EU01" = "BACKEND-PROD-NIC-DEVTEST-EU01"
      "BACKEND-STAG-VM-DEVTEST-EU01" = "BACKEND-STAG-NIC-DEVTEST-EU01"
  }
  description = "Virtual machines and network interfaces."
}

variable "computer_name" {
  type        = string
  default     = "backend"
  description = "Computer name."
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