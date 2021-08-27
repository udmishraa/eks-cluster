cluster_name = "data-ext"
cluster_subnet_list = ["subnet-00715ea28bca01189","subnet-0e05a23e3f546f430","subnet-0907f8e2f3c7d0b47"]
cluster_access_cidr_list = ["3.1.252.128/32","3.130.90.3/32","3.6.213.217/32","3.7.27.185/32"]
container_network_cidr = "10.100.0.0/16"
k8s_version = "1.21"
vpc_id = "vpc-0bcb06a59947edd51"
cluster_tags = {
                  Environment = "Production"
                  Team  = "Data Dev"
                  Owner = "data-dev-infra@delhivery.com"
                  TechnologyUnit = "Data"
                  Project =  "Externalization"
                 }

nodegroup_configs = {
    "nodegroup1" = {
          nodegroup_name = "memory-intensive"
          node_subnet_list = ["subnet-09e363420f4d25843","subnet-0b245229dd5a0d919","subnet-057188f95eb9ddfa6"]
          instance_types = ["r5a.2xlarge","r5ad.4xlarge","r5n.4xlarge","r5d.4xlarge","r5.4xlarge"]
          ssh_key_name = "data-ext"
          is_spot = false
          instance_desired = 1
          instance_max = 10
          instance_min =1
          tags = {
                  Environment = "Production"
                  Team  = "Data Dev"
                  Owner = "data-dev-infra@delhivery.com"
                  TechnologyUnit = "Data"
                  Project =  "Externalization"
                  Infra-Alerts-Email = "data-dev-infra@delhivery.com"
                  }
      }
}