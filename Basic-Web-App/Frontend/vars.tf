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

variable "serviceplan_name" {
  type        = string
  default     = "SPLN-DEVTEST-EU01"
  description = "Virtual network name."
}

variable "webapp_name" {
  type        = string
  default     = "WAPP-DEVTEST-EU01"
  description = "Virtual network name."
}

variable "subnet_name" {
  type        = string
  default     = "FRONTEND-SUB-DEVTEST-EU01"
  description = "Virtual network name."
}

