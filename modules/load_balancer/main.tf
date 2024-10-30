resource "oci_core_load_balancer" "active_load_balancer" {
  compartment_id = var.compartment_id
  display_name   = "my-active-load-balancer"
  shape          = "100Mbps"
  subnet_ids     = [oci_core_subnet.oke_app_subnet.id] # Specify the active AD subnet
}

resource "oci_core_load_balancer" "passive_load_balancer" {
  compartment_id = var.compartment_id
  display_name   = "my-passive-load-balancer"
  shape          = "100Mbps"
  subnet_ids     = [oci_core_subnet.oke_backend_subnet.id] # Specify the passive AD subnet
}

resource "oci_core_load_balancer_backend_set" "active_backend_set" {
  load_balancer_id = oci_core_load_balancer.active_load_balancer.id
  name             = "my-active-backend-set"
  policy           = "ROUND_ROBIN"
}

resource "oci_core_load_balancer_backend_set" "passive_backend_set" {
  load_balancer_id = oci_core_load_balancer.passive_load_balancer.id
  name             = "my-passive-backend-set"
  policy           = "ROUND_ROBIN"
}

resource "oci_core_load_balancer_listener" "active_listener" {
  load_balancer_id = oci_core_load_balancer.active_load_balancer.id
  name             = "my-active-listener"
  port             = 80
  protocol         = "HTTP"
  backend_set_name = oci_core_load_balancer_backend_set.active_backend_set.name
}

resource "oci_core_load_balancer_listener" "passive_listener" {
  load_balancer_id = oci_core_load_balancer.passive_load_balancer.id
  name             = "my-passive-listener"
  port             = 80
  protocol         = "HTTP"
  backend_set_name = oci_core_load_balancer_backend_set.passive_backend_set.name
}

resource "oci_core_load_balancer_health_checker" "active_health_checker" {
  load_balancer_id = oci_core_load_balancer.active_load_balancer.id
  backend_set_name = oci_core_load_balancer_backend_set.active_backend_set.name
  port             = 80
  protocol         = "HTTP"
  url_path         = "/health"
}

resource "oci_core_load_balancer_health_checker" "passive_health_checker" {
  load_balancer_id = oci_core_load_balancer.passive_load_balancer.id
  backend_set_name = oci_core_load_balancer_backend_set.passive_backend_set.name
  port             = 80
  protocol         = "HTTP"
  url_path         = "/health"
}
