variable "resource_group_name" {
  type        = string
  description = "Name of the existing Resource Group"
  default     = "1-54b3b90d-playground-sandbox"
  }

variable "location" {
  type        = string
  description = "Azure Region"
  default     = "westus"
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
