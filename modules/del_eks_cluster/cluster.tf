resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn

  enabled_cluster_log_types = ["api", "audit"]
  tags = var.cluster_tags

  vpc_config {
    subnet_ids = var.cluster_subnet_list
    endpoint_private_access = true
    endpoint_public_access = true
    public_access_cidrs = var.cluster_access_cidr_list
    security_group_ids = [aws_security_group.cluster_sg.id]
  }

  kubernetes_network_config {
      service_ipv4_cidr = var.container_network_cidr

  }
  version = var.k8s_version

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSVPCResourceController,
    aws_cloudwatch_log_group.cluster
  ]
}



resource "aws_cloudwatch_log_group" "cluster" {
  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 5
  tags = var.cluster_tags

  # ... potentially other configuration ...
}


resource "aws_security_group" "cluster_sg" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "Allow Traffic between node and eks plane"
  vpc_id      = var.vpc_id
  tags = var.cluster_tags
}



resource "aws_security_group_rule" "cluster_self" {
  type              = "ingress"
  source_security_group_id = aws_security_group.cluster_sg.id
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  security_group_id = aws_security_group.cluster_sg.id
}

resource "aws_security_group_rule" "cluster_nodegroup" {
  type              = "ingress"
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = aws_security_group.node_sg.id
  from_port         = 0
  security_group_id = aws_security_group.cluster_sg.id
}

resource "aws_security_group_rule" "cluster-out" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  from_port         = 0
  security_group_id = aws_security_group.cluster_sg.id
}

resource "aws_security_group" "node_sg" {
  name        = "${var.cluster_name}-node-sg"
  description = "Allow Traffic between node and eks plane"
  vpc_id      = var.vpc_id
  tags = var.cluster_tags
}

resource "aws_security_group_rule" "nodegroup_self" {
  type              = "ingress"
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = aws_security_group.node_sg.id
  from_port         = 0
  security_group_id = aws_security_group.node_sg.id
}

resource "aws_security_group_rule" "allow_all" {
  type              = "ingress"
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = aws_security_group.cluster_sg.id
  from_port         = 0
  security_group_id = aws_security_group.node_sg.id
}

resource "aws_security_group_rule" "node-out" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  from_port         = 0
  security_group_id = aws_security_group.node_sg.id
}

resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-cluster-iam-role"
  tags = var.cluster_tags

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY  
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster.name
}


#data "tls_certificate" "example" {
#  url = aws_eks_cluster.example.identity[0].oidc[0].issuer
#}

#resource "aws_iam_openid_connect_provider" "example" {
#  client_id_list  = ["sts.amazonaws.com"]
#  thumbprint_list = [data.tls_certificate.example.certificates[0].sha1_fingerprint]
#  url             = aws_eks_cluster.example.identity[0].oidc[0].issuer
#}

#data "aws_iam_policy_document" "example_assume_role_policy" {
#  statement {
#    actions = ["sts:AssumeRoleWithWebIdentity"]
#    effect  = "Allow"
#
#    condition {
#      test     = "StringEquals"
#      variable = "${replace(aws_iam_openid_connect_provider.example.url, "https://", "")}:sub"
#      values   = ["system:serviceaccount:kube-system:aws-node"]
#    }
#
#    principals {
#      identifiers = [aws_iam_openid_connect_provider.example.arn]
#      type        = "Federated"
#    }
#  }
#}

#resource "aws_iam_role" "example" {
#  assume_role_policy = data.aws_iam_policy_document.example_assume_role_policy.json
#  name               = "example"
#}




data "aws_eks_cluster_auth" "cluster_auth" {
  name = var.cluster_name

  depends_on = [
    aws_eks_cluster.cluster
  ]
}


provider "kubernetes" {
  host                   = aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
  load_config_file = false
}


resource "kubernetes_config_map" "aws_auth_configmap" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
data = {
    mapRoles = <<YAML
- rolearn: ${aws_iam_role.node.arn}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
YAML
  }

  depends_on = [
    aws_eks_cluster.cluster
  ]
}

