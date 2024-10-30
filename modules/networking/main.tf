resource "oci_core_virtual_cloud_network" "vcn" {
  compartment_id = var.compartment_id
  cidr_block     = "10.0.0.0/16"
  display_name   = "my_vcn"
}

resource "oci_core_subnet" "dmz_subnet" {
  compartment_id      = var.compartment_id
  vcn_id              = oci_core_virtual_cloud_network.vcn.id
  cidr_block          = "10.0.1.0/24"
  display_name        = "dmz_subnet"
  route_table_id      = oci_core_route_table.default.id
  security_list_ids   = [oci_core_security_list.dmz_security_list.id]
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_subnet" "oke_app_subnet" {
  compartment_id      = var.compartment_id
  vcn_id              = oci_core_virtual_cloud_network.vcn.id
  cidr_block          = "10.0.2.0/24"
  display_name        = "oke_app_subnet"
}

resource "oci_core_subnet" "oke_backend_subnet" {
  compartment_id      = var.compartment_id
  vcn_id              = oci_core_virtual_cloud_network.vcn.id
  cidr_block          = "10.0.3.0/24"
  display_name        = "oke_backend_subnet"
}

resource "oci_core_subnet" "storage_subnet" {
  compartment_id      = var.compartment_id
  vcn_id              = oci_core_virtual_cloud_network.vcn.id
  cidr_block          = "10.0.4.0/24"
  display_name        = "storage_subnet"
}

resource "oci_core_subnet" "elk_subnet" {
  compartment_id      = var.compartment_id
  vcn_id              = oci_core_virtual_cloud_network.vcn.id
  cidr_block          = "10.0.5.0/24"
  display_name        = "elk_subnet"
}

output "vcn_id" {
  value = oci_core_virtual_cloud_network.vcn.id
}
