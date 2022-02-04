job "plugin-synology-controller" {
  datacenters = ["dc1"]
  group "controller" {
    task "plugin" {
      driver = "docker"

      config {
        image = "docker.io/synology/synology-csi:v1.0.0"

        args = [
          "--nodeid=NotUsed",
          "--endpoint=unix://csi/csi.sock",
          "--client-info=/etc/csi.yaml",
          "--log-level=debug"
        ]

        volumes = [
            "local/csi.yaml:/etc/csi.yaml",
            "/:/host",
        ]
      }

      csi_plugin {
        id        = "synology"
        type      = "controller"
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
