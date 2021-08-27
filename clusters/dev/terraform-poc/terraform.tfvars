cluster_name = "terraform-poc"
cluster_subnet_list = ["subnet-8b3ad6","subnet-1d323f2aas","subnet-a408oaidhf"]
cluster_access_cidr_list = ["0.0.0.0/0"]
container_network_cidr = "10.100.0.0/16"
k8s_version = "1.21"
vpc_id = "vpc-6asdf0"
cluster_tags = {
                 Environment = "Development"
                 }

nodegroup_configs = {
    "nodegroup1" = {
          nodegroup_name = "test"
          node_subnet_list = ["subnet-12asdf37","subnet-ajsdaecf9b5ee08"]
          instance_types = ["c5a.2xlarge","m5a.2xlarge","m5ad.2xlarge","c5.2xlarge","c5n.2xlarge","m5d.2xlarge"]
          ssh_key_name = "my_key"
          is_spot = true
          instance_desired = 1
          instance_max = 10
          instance_min =1
          tags = {
                 Environment = "Development"
                 }
      }
    "nodegroup3" = {
          nodegroup_name = "test3"
          node_subnet_list = ["subnet-12asdf37","subnet-ajsdaecf9b5ee08"]
          instance_types = ["c5a.2xlarge","m5a.2xlarge","m5ad.2xlarge","c5.2xlarge","c5n.2xlarge","m5d.2xlarge"]
          ssh_key_name = "devops"
          is_spot = false
          instance_desired = 1
          instance_max = 8
          instance_min =1
          tags = {
                 Environment = "Development"
                 }
      }
}