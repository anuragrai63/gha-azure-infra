variable "resource_group_name" {
  type        = string
  description = "Name of the existing Resource Group"
  default     = "1-99a23bdf-playground-sandbox"
  }

variable "location" {
  type        = string
  description = "Azure Region"
  default     = "eastus"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "admin_password" {
  type      = string
  default   = "Oneforall123"
  sensitive = true
}
