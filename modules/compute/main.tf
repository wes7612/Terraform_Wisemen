resource "oci_containerengine_cluster" "oke_cluster" {
  name                = "my-oke-cluster"
  compartment_id      = var.compartment_id
  vcn_id              = var.vcn_id
  kubernetes_version  = "v1.21.5"
}

resource "oci_containerengine_node_pool" "oke_node_pool" {
  cluster_id               = oci_containerengine_cluster.oke_cluster.id
  name                     = "my-node-pool"
  compartment_id           = var.compartment_id
  node_shape               = "VM.Standard.E3.Flex"
  
  node_count               = 2
  autoscaling_config {
    min_nodes = 2
    max_nodes = 5
  }

  node_config {
    size_in_gbs = 50
  }
}

output "oke_cluster_id" {
  value = oci_containerengine_cluster.oke_cluster.id
}
