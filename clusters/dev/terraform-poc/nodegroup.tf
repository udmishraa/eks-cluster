data "aws_eks_cluster" "cluster" {
  name = module.del_eks_cluster.cluster_name
  depends_on = [
    module.del_eks_cluster
  ]
}

data "aws_ami" "eks_ami" {
  most_recent = true
  
  filter {
    name   = "name"
    values = ["amazon-eks-node-${data.aws_eks_cluster.cluster.version}-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}


module "del_nodegroup" {
    source = "../../../modules/del_eks_unmanaged_nodegroup"
    for_each = var.nodegroup_configs
    cluster_name = module.del_eks_cluster.cluster_name
    cluster_endpoint = module.del_eks_cluster.cluster_endpoint
    cluster_ca = module.del_eks_cluster.kubeconfig-certificate-authority-data
    node_iam_instace_profile = module.del_eks_cluster.node_iam_profile_name
    node_sg_ids = [module.del_eks_cluster.node_sg_id]
    ami_id = data.aws_ami.eks_ami.image_id
    is_spot = each.value["is_spot"]
    node_subnet_list = each.value["node_subnet_list"]
    instance_types = each.value["instance_types"]
    ssh_key_name = each.value["ssh_key_name"]
    nodegroup_name = each.value["nodegroup_name"]
    instance_desired = each.value["instance_desired"]
    instance_max = each.value["instance_max"]
    instance_min = each.value["instance_min"]
    tags = each.value["tags"]
    depends_on = [
      module.del_eks_cluster
    ]

}

variable "nodegroup_configs" {
  default = {
      "nodegroup1" = {
          nodegroup_name = "Test"
          node_subnet_list = []
          instance_types = []
          ssh_key_name = "devops"
          is_spot = true
          instance_desired = 1
          instance_max = 1
          instance_min =1
          tags = {
                 }
      }
  }
  }