resource "oci_identity_group" "database_engineers" {
  name           = "database_engineers"
  compartment_id = var.compartment_id
}

resource "oci_identity_group" "elk_engineers" {
  name           = "elk_engineers"
  compartment_id = var.compartment_id
}

resource "oci_identity_group" "on_prem_users" {
  name           = "on_prem_users"
  compartment_id = var.compartment_id
}

resource "oci_identity_policy" "on_prem_access_policy" {
  name           = "on-prem-users-access-policy"
  description    = "Policy for on-prem users to access shared storage"
  compartment_id = var.compartment_id

  statements = [
    "Allow group on_prem_users to manage objects in compartment <compartment_name>",
  ]
}

resource "oci_identity_policy" "elk_access_policy" {
  name           = "elk-engineers-access-policy"
  description    = "Policy for ELK Engineers to access the ELK network"
  compartment_id = var.compartment_id

  statements = [
    "Allow group elk_engineers to manage all-resources in compartment <compartment_name>",
  ]
}

resource "oci_identity_policy" "db_engineer_access_policy" {
  name           = "db-engineers-access-policy"
  description    = "Policy for Database Engineers to access the DB network"
  compartment_id = var.compartment_id

  statements = [
    "Allow group database_engineers to manage all-resources in compartment <compartment_name>",
  ]
}

resource "oci_identity_dynamic_group" "dynamic_group" {
  name           = "dynamic-group"
  compartment_id = var.compartment_id
  matching_rule  = "all(tenancy.id = '<tenancy_id>')"
}

resource "oci_core_security_list" "dmz_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 80
      max = 80
    }
  }
  
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }
}

resource "oci_core_security_list" "oke_app_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 80
      max = 80
    }
  }

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }
}

resource "oci_core_security_list" "oke_backend_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 80
      max = 80
    }
  }

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }
}

resource "oci_core_security_list" "storage_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 3306
      max = 3306
    }
  }

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }
}

resource "oci_core_security_list" "elk_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 9200
      max = 9200
    }
  }

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }
}

resource "oci_core_firewall" "firewall" {
  compartment_id = var.compartment_id
  display_name   = "my-firewall"
}

resource "oci_core_network_security_group" "network_security_group" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  display_name   = "my-nsg"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
  }
}
