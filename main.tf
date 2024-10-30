provider "oci" {
  region = var.region
}

# Create the VCN
resource "oci_core_virtual_network" "my_vcn" {
  compartment_id = var.compartment_id
  display_name   = "my_vcn"
  cidr_block     = "10.0.0.0/16"
}

# Networking Module
module "networking" {
  source         = "./modules/networking"
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.my_vcn.id
}

# Security Module
module "security" {
  source = "./modules/security"
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.my_vcn.id
  dmz_subnet_id  = module.networking.dmz_subnet_id
  oke_app_subnet_id = module.networking.oke_app_subnet_id
  oke_backend_subnet_id = module.networking.oke_backend_subnet_id
  storage_subnet_id = module.networking.storage_subnet_id
  elk_subnet_id  = module.networking.elk_subnet_id
}

# Load Balancer Module
module "load_balancer" {
  source = "./modules/load_balancer"
  compartment_id = var.compartment_id
  dmz_subnet_id  = module.networking.dmz_subnet_id
  oke_app_subnet_id = module.networking.oke_app_subnet_id
}

# Create the OKE Cluster
module "oke" {
  source              = "./modules/oke"
  compartment_id      = var.compartment_id
  oke_app_subnet_id   = module.networking.oke_app_subnet_id
  image_ocid          = var.image_ocid
  auto_scaling_min_nodes = var.auto_scaling_min_nodes
  auto_scaling_max_nodes = var.auto_scaling_max_nodes
}

# Storage Module
module "storage" {
  source         = "./modules/storage"
  compartment_id = var.compartment_id
  storage_subnet_id = module.networking.storage_subnet_id
  backup_region_id = var.backup_region_id
  database_name = var.database_name
  block_storage_size = var.block_storage_size
  object_storage_bucket_name = var.object_storage_bucket_name
}

# Output the Load Balancer IP
output "load_balancer_ip" {
  value = module.load_balancer.load_balancer_ip
}

# Output OKE Cluster Info
output "oke_cluster_info" {
  value = module.oke.oke_cluster_info
}

# Output Storage Information
output "database_info" {
  value = module.storage.database_info
}

output "object_storage_bucket_info" {
  value = module.storage.object_storage_info
}
