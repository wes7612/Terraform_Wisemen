variable "compartment_id" {
  description = "The OCID of the compartment in which to create resources."
  type        = string
}

variable "vcn_id" {
  description = "The OCID of the VCN where the subnets and resources will reside."
  type        = string
}

variable "region" {
  description = "The OCI region where resources will be created."
  type        = string
  default     = "us-ashburn-1"  # Change to your preferred region
}

variable "dmz_subnet_id" {
  description = "The OCID of the DMZ subnet."
  type        = string
}

variable "oke_app_subnet_id" {
  description = "The OCID of the OKE APP subnet."
  type        = string
}

variable "oke_backend_subnet_id" {
  description = "The OCID of the OKE Backend subnet."
  type        = string
}

variable "storage_subnet_id" {
  description = "The OCID of the Storage subnet."
  type        = string
}

variable "elk_subnet_id" {
  description = "The OCID of the ELK subnet."
  type        = string
}

variable "backup_region_id" {
  description = "The OCID of the backup region."
  type        = string
}

variable "database_name" {
  description = "Name of the database."
  type        = string
  default     = "my_database"
}

variable "block_storage_size" {
  description = "Size of block storage in GB."
  type        = number
  default     = 50
}

variable "object_storage_bucket_name" {
  description = "The name of the Object Storage bucket."
  type        = string
  default     = "my-object-bucket"
}

variable "msql_version" {
  description = "Version of MySQL to be deployed."
  type        = string
  default     = "8.0"
}

variable "load_balancer_shape" {
  description = "Shape of the Load Balancer."
  type        = string
  default     = "100Mbps"
}

variable "auto_scaling_min_nodes" {
  description = "Minimum number of nodes in the OKE cluster."
  type        = number
  default     = 2
}

variable "auto_scaling_max_nodes" {
  description = "Maximum number of nodes in the OKE cluster."
  type        = number
  default     = 5
}

variable "image_ocid" {
  description = "The OCID of the image to use for the compute instances."
  type        = string
}

variable "ssh_public_key" {
  description = "The SSH public key for accessing the compute instances."
  type        = string
}
