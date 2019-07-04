resource "google_container_cluster" "gke-cluster" {
  name               = "${var.clustername}"
  network            = "${var.network}"
  location           = "${var.zone}"
  initial_node_count = "${var.nodecount}"
  node_config   {
      machine_type = "${var.machinetype}"
  }
}
output cluster_name {
  value = "${google_container_cluster.gke-cluster.name}"
}
output cluster_zone {
  value = "${google_container_cluster.gke-cluster.zone}"
}