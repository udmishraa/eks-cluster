###### Node variables ######
variable "node_subnet_list" {
    type = list
    description = "node subnet list"
}

variable "ami_type" {
    type = string
    default = "AL2_x86_64"
    description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group"
}
variable "ami_id" {
    type = string
    description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group"
}
variable "capacity_type" {
    type = string
    default = "SPOT"
    description = "Type of capacity associated with the EKS Node Group. Valid values: ON_DEMAND, SPOT"
}

variable "volume_size" {
    type = string
    default = "100"
    description = "Disk size in GiB for worker nodes"   
}

variable "instance_types" {
    type = list
    default = ["c5a.2xlarge","m5a.2xlarge","m5ad.2xlarge","c5.2xlarge","c5n.2xlarge","m5d.2xlarge"]
}

#variable "release_version" {
#    type = string
#    default = "latest"
#    description = "AMI version of the EKS Node Group."
#}

variable "ssh_key_name" {
    type = string
    description = "EC2 Key Pair name that provides access for SSH communication with the worker nodes in the EKS Node Group."
}

variable "cluster_name" {
    type = string
    description = ""
}

variable "cluster_endpoint" {
    type = string
    description = ""
}

variable "cluster_ca" {
    type = string
    description = ""
}

variable "node_iam_instace_profile" {
    type = string
    description = ""
  
}

variable "node_sg_ids" {
    type = list
    description = ""
  
}

variable "nodegroup_name" {
    type = string
  
}

variable "is_spot" {
    type = bool
  
}
variable "instance_desired" {
    type = number
    default =1
  
}
variable "instance_min" {
    type = number
    default = 1
  
}
variable "instance_max" {
    type = number
    default = 1
  
}

variable "tags" {
    type = map(string)
  
}