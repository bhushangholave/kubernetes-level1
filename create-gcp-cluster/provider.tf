provider "google" {
  credentials = "${file("./creads/serviceaccount.json")}"
  project = "gcp-tf-gke-test"
  region = "asia-south1"
}
