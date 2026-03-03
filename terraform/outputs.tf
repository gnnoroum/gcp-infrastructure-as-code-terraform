output "network_name" {
  value = google_compute_network.vpc.name
}

output "subnet_name" {
  value = google_compute_subnetwork.subnet.name
}

output "vm_name" {
  value = google_compute_instance.epic_interconnect_vm.name
}

output "vm_internal_ip" {
  value = google_compute_instance.epic_interconnect_vm.network_interface[0].network_ip
}

output "vm_external_ip" {
  value = try(google_compute_instance.epic_interconnect_vm.network_interface[0].access_config[0].nat_ip, null)
}
