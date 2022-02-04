job "plugin-synology-node" {

  # you can run node plugins as service jobs as well, but this ensures
  # that all nodes in the DC have a copy.
  type = "system"

  datacenters = ["dc1"]
  group "nodes" {
    task "plugin" {
      driver = "docker"

      config {
        image = "docker.io/synology/synology-csi:v1.0.0"

        args = [
          "--nodeid=${node.unique.name}",
          "--endpoint=unix://csi/csi.sock",
          "--client-info=/etc/csi.yaml",
          "--log-level=debug"
        ]

        volumes = [
            "local/csi.yaml:/etc/csi.yaml",
            "/:/host",
        ]

        # node plugins must run as privileged jobs because they
        # mount disks to the host
        privileged = true
      }

      csi_plugin {
        id        = "synology"
        type      = "node"
        mount_dir = "/csi"
      }

      resources {
        cpu    = 256
        memory = 256
      }

      template {
          destination = "local/csi.yaml"
          data = <<EOF
---
clients:
- host: 192.168.0.2
  port: 5000
  https: false
  username: nomad
  password: "dsm_password"
EOF
      }

    }
  }
}
