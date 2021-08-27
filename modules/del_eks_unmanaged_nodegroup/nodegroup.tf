
data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

resource "aws_autoscaling_group" "bar" {
  name                      = "${var.cluster_name}-${var.nodegroup_name}-asg"
  max_size                  = var.instance_max
  min_size                  = var.instance_min
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = var.instance_desired
  force_delete              = true
  vpc_zone_identifier       = var.node_subnet_list
  
  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/enabled"
    value               = "true"
    propagate_at_launch = true
  }

  dynamic "tag" {
  for_each = var.tags
  content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
      }
  }



  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = var.is_spot == true ? 0 : 100
      spot_allocation_strategy                 = "capacity-optimized"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.foobar.id
        version = "$Latest"
      }
      
      dynamic "override" {
          for_each = var.instance_types
          content {
              instance_type = override.value
          }
      }
    }
    
  }

  
  }


data "template_file" "user_data" {
  template = file("${path.module}/user-data.tpl")

  vars = {
    CLUSTER_NAME         = var.cluster_name
    CLUSTER_ENDPOINT     = var.cluster_endpoint
    CLUSTER_CA           = var.cluster_ca

  }
}

resource "aws_launch_template" "foobar" {
  name = "${var.cluster_name}-${var.nodegroup_name}-lt"
  

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.volume_size
      delete_on_termination = true
    }
    
  }

 
  iam_instance_profile {
    name = var.node_iam_instace_profile
  }
  tags = var.tags
  image_id = var.ami_id
  instance_type = var.instance_types[0]
  key_name = var.ssh_key_name
  vpc_security_group_ids = var.node_sg_ids
  
  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
  }

  lifecycle {
    create_before_destroy = true
  }
  user_data = base64encode(data.template_file.user_data.rendered)

  update_default_version = true
}
