variable "project_id" {
    default = "firstccprojecttry"
    description = "project id"
}

variable "region" {
    default = "europe-west3"
    description = "region"
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}
