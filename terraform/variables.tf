variable "project_id" {
  description = "GCP Project ID (example: skilful-firefly-464217-t5)"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-east1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-east1-b"
}

variable "network_name" {
  description = "VPC network name"
  type        = string
  default     = "vpc-whs-dev"
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
  default     = "subnet-epic-dev"
}

variable "subnet_cidr" {
  description = "Subnet CIDR"
  type        = string
  default     = "10.10.0.0/24"
}

variable "private_google_access" {
  description = "Enable Private Google Access on subnet"
  type        = bool
  default     = false
}

variable "vm_name" {
  description = "Compute Engine VM name"
  type        = string
  default     = "epic-dev-interconnect"
}

variable "machine_type" {
  description = "GCE machine type"
  type        = string
  default     = "e2-standard-4"
}

variable "boot_image" {
  description = "Boot image for VM"
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "boot_disk_size_gb" {
  description = "Boot disk size (GB)"
  type        = number
  default     = 10
}

variable "boot_disk_type" {
  description = "Boot disk type"
  type        = string
  default     = "pd-standard"
}

variable "instance_tags" {
  description = "Network tags applied to the instance"
  type        = list(string)
  default     = ["dev", "epic", "whs"]
}

variable "instance_metadata" {
  description = "Metadata key/value pairs for the instance"
  type        = map(string)
  default = {
    application = "epic-interconnect"
    department  = "clinical-systems"
    environment = "dev"
    owner       = "whs-epic-team"
  }
}

# Firewall source ranges (RECOMMENDED: restrict to your public IP /32)
variable "ssh_source_ranges" {
  description = "Source CIDRs allowed to SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "rdp_source_ranges" {
  description = "Source CIDRs allowed to RDP"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "icmp_source_ranges" {
  description = "Source CIDRs allowed to ping (ICMP)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "create_internal_allow_rule" {
  description = "Create an internal allow rule for the subnet CIDR"
  type        = bool
  default     = true
}
