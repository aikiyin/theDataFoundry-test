variable "function_name" {
  type        = string
  description = "The name of the function to be created"
}

variable "timeout" {
  type    = number
  default = 60
}

variable "memory_size" {
  type    = number
  default = 128
}
