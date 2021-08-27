module "del_eks_cluster" {
    source = "../../../modules/del_eks_cluster"
    cluster_name = var.cluster_name
    cluster_subnet_list = var.cluster_subnet_list
    cluster_access_cidr_list = var.cluster_access_cidr_list
    container_network_cidr = var.container_network_cidr
    k8s_version = var.k8s_version
    vpc_id = var.vpc_id
    cluster_tags = var.cluster_tags
}

variable "cluster_name" {
    type = string 
}
variable "cluster_subnet_list" {
    type = list
}
variable "cluster_access_cidr_list" {
    type = list
}
variable "container_network_cidr" {
    type = string
}
variable "k8s_version" {
    type = string
}
variable "vpc_id" {
    type = string
}
variable "cluster_tags" {
    type = map(string)
}