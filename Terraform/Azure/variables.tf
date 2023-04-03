variable "resource_group_location" {
  default     = "eastus"
  description = "Location del grupo de recursos"
}

variable "prefix" {
  type        = string
  default     = "win-vm-iis"
  description = "Prefijo de el numero de recursos"
}