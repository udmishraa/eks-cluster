cluster_name = "terraform-poc"
cluster_subnet_list = ["subnet-8b3a90d6","subnet-08516cdd21d323f2a","subnet-0efa408a8252ecb50"]
cluster_access_cidr_list = ["0.0.0.0/0","30.0.0.0/16"]
container_network_cidr = "10.100.0.0/16"
k8s_version = "1.21"
vpc_id = "vpc-68ff7710"
cluster_tags = {
                 Environment = "Development"
                 Team  = "Devops"
                 Owner = "infrasupport@delhivery.com"
                 }

nodegroup_configs = {
    "nodegroup1" = {
          nodegroup_name = "test"
          node_subnet_list = ["subnet-12379d4f","subnet-032c78aecf9b5ee08"]
          instance_types = ["c5a.2xlarge","m5a.2xlarge","m5ad.2xlarge","c5.2xlarge","c5n.2xlarge","m5d.2xlarge"]
          ssh_key_name = "devops"
          is_spot = true
          instance_desired = 1
          instance_max = 10
          instance_min =1
          tags = {
                 Environment = "Development"
                 Team  = "Devops"
                 Owner = "infrasupport@delhivery.com"
                 }
      }
    "nodegroup3" = {
          nodegroup_name = "test3"
          node_subnet_list = ["subnet-12379d4f","subnet-032c78aecf9b5ee08"]
          instance_types = ["c5a.2xlarge","m5a.2xlarge","m5ad.2xlarge","c5.2xlarge","c5n.2xlarge","m5d.2xlarge"]
          ssh_key_name = "devops"
          is_spot = true
          instance_desired = 1
          instance_max = 8
          instance_min =1
          tags = {
                 Environment = "Development"
                 Team  = "Devops"
                 Owner = "infrasupport@delhivery.com"
                 }
      }
}