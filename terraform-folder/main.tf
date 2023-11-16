# GKE cluster
data "google_container_engine_versions" "gke_version" {
  location = var.region
  version_prefix = "1.27."
}


resource "google_container_cluster" "gke_cluster" {
  name = "${var.project_id}-gke-cluster"
  location = "${var.region}-a"
  initial_node_count = 2
  remove_default_node_pool = true

  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
      
    }
  }
  
}

resource "google_sql_database_instance" "cloud_sql_instance" {
  name = "firstproject-cloud-sql-instance"
  database_version = "MYSQL_5_7"
  region = "europe-west3"
  settings {
    tier = "db-f1-micro"
    backup_configuration {
      enabled = true
      start_time = "09:00"
      
    }
    ip_configuration {
      ipv4_enabled = true
      private_network = google_compute_network.vpc.self_link 
    }
  }
}

resource "google_container_node_pool" "gke_node_pool" {
    name = google_container_cluster.gke_cluster.name
    location = "${var.region}-a"
    cluster = google_container_cluster.gke_cluster.name
    
    version = data.google_container_engine_versions.gke_version.release_channel_latest_version["STABLE"]
    node_count = var.gke_num_nodes

    node_config {
      machine_type = "e2-micro"
      oauth_scopes = [
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
        "https://www.googleapis.com/auth/cloud-platform",
      ]
    
    labels = {
        env = var.project_id
    } 

    tags = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
    }


    autoscaling{
        min_node_count = 2
        max_node_count = 7

    }
  
}
# VPC

resource "google_compute_network" "vpc" {
  name = "${var.project_id}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name = "${var.project_id}-subnet"
  region = var.region
  network = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}
