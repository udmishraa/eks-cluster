variable "cluster_name" {
  type        = string
  description = "Kubernetes Cluster Name"
}

variable "cluster_subnet_list" {
  type        = list
  description = "Kubernetes Cluster subnets"
}

variable "cluster_access_cidr_list" {
  type        = list
  default = ["0.0.0.0/0"]
  description = "List of Access CIDRs"
}

variable "container_network_cidr" {
  type        = string
  description = "Contaner Network CIDR Range, should not conflict with other VPCs"
}

variable "k8s_version" {
  type        = string
  description = "Kubernetes Version"
}
variable "vpc_id" {
    type =  string
    description = "VPC ID for EKS cluster"
}

variable "cluster_tags" {
    type = map(string) 
}