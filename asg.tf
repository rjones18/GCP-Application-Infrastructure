resource "google_compute_instance_template" "my_template" {
  name_prefix = "my-template-"
  machine_type = "n1-standard-2"

  disk {
    source_image = "projects/alert-flames-286515/global/images/wordpress-image-1678576988"
  }

  network_interface {
    network = "project-vpc"
  }

resource "google_compute_target_pool" "my_target_pool" {
  name = "my-target-pool"
  region = "us-central1"
  instances = google_compute_instance_group_manager.my_group.self_link
}

resource "google_compute_instance_group_manager" "my_group" {
  name = "my-group"
  region = "us-central1"
  base_instance_name = "my-instance"
  instance_template = google_compute_instance_template.my_template.self_link
  target_size = 1
  autoscaler {
    cool_down_period_sec = 60
    min_num_replicas = 1
    max_num_replicas = 5
    target_cpu_utilization = 0.6
  }
}

resource "google_compute_forwarding_rule" "my_forwarding_rule" {
  name = "my-forwarding-rule"
  region = "us-central1"
  ip_address = google_compute_global_address.my_global_address.address
  load_balancing_scheme = "INTERNAL"
  network = "default"
  subnetwork = "default"
  target = google_compute_target_pool.my_target_pool.self_link
}


resource "google_compute_global_address" "my_global_address" {
  name = "my-global-address"
}

resource "google_compute_global_forwarding_rule" "my_global_forwarding_rule" {
  name = "my-global-forwarding-rule"
  target = google_compute_forwarding_rule.my_forwarding_rule.self_link
  ip_address = google_compute_global_address.my_global_address.address
}




# resource "google_compute_autoscaler" "default" {
#   provider = google-beta

#   name   = "my-autoscaler"
#   zone   = "us-central1-f"
#   target = google_compute_instance_group_manager.default.id

#   autoscaling_policy {
#     max_replicas    = 3
#     min_replicas    = 2
#     cooldown_period = 60

#     metric {
#       name                       = "pubsub.googleapis.com/subscription/num_undelivered_messages"
#       filter                     = "resource.type = pubsub_subscription AND resource.label.subscription_id = our-subscription"
#       single_instance_assignment = 65535
#     }
#   }
# }

# resource "google_compute_instance_template" "default" {
#   provider = google-beta

#   name           = "my-instance-template"
#   machine_type   = "e2-micro"
#   can_ip_forward = false

#   tags = ["foo", "bar"]

#   disk {
#     source_image = "projects/alert-flames-286515/global/images/wordpress-image-1678576988"
#   }

#   network_interface {
#     network = "project-vpc"
#   }

#   metadata = {
#     foo = "bar"
#   }

#   service_account {
#     scopes = ["userinfo-email", "compute-ro", "storage-ro"]
#   }
# }

# resource "google_compute_target_pool" "default" {
#   provider = google-beta

#   name = "my-target-pool"
# }

# resource "google_compute_instance_group_manager" "default" {
#   provider = google-beta

#   name = "my-igm"
#   zone = "us-central1-f"

#   version {
#     instance_template = google_compute_instance_template.default.id
#     name              = "primary"
#   }

#   target_pools       = [google_compute_target_pool.default.id]
#   base_instance_name = "autoscaler-sample"
# }


# provider "google-beta" {
#   region = "us-central1"
#   zone   = "us-central1-a"

# }
