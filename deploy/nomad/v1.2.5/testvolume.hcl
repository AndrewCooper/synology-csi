id        = "test"
name      = "test"
type      = "csi"
plugin_id = "synology"

capacity_min = "1GiB"
capacity_max = "2GiB"

capability {
  access_mode = "single-node-writer"
  attachment_mode = "file-system"
}

mount_options {
  mount_flags = ["rw"]
}
