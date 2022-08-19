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
      "FRONTEND-PROD-SUB-DEVTEST-EU01" = "10.0.5.0/24"
      "FRONTEND-STAG-SUB-DEVTEST-EU01" = "10.0.6.0/24"
    }
  description = "FRONTEND Subnet address."
}

variable "public_ip_names" {
  type        = set(string)
  default     = ["PIP-PROD-DEVTEST-EU01", "PIP-STAG-DEVTEST-EU01"]
  description = "Public IP names."
}

variable "nic_subnet" {
  type = map
  default = {
      "FRONTEND-PROD-NIC-DEVTEST-EU01" = "FRONTEND-PROD-SUB-DEVTEST-EU01"
      "FRONTEND-STAG-NIC-DEVTEST-EU01" = "FRONTEND-STAG-SUB-DEVTEST-EU01"
    }
  description = "FRONTEND network interface."
}

variable "nsg_prod_name" {
  type        = string
  default     = "FRONTEND-PROD-NSG-DEVTEST-EU01"
  description = "Production Network security group."
}

variable "nsg_stag_name" {
  type        = string
  default     = "FRONTEND-STAG-NSG-DEVTEST-EU01"
  description = "Staging Network security group."
}

variable "vm_nic" {
  type = map
  default = {
	
      "FRONTEND-PROD-VM-DEVTEST-EU01" = "FRONTEND-PROD-NIC-DEVTEST-EU01"
      "FRONTEND-STAG-VM-DEVTEST-EU01" = "FRONTEND-STAG-NIC-DEVTEST-EU01"
  }
  description = "Virtual machines and network interfaces."
}

variable "computer_name" {
  type        = string
  default     = "frontend"
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
