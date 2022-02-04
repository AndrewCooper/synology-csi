job "plugin-synology" {
  type = "system"
  group "controller" {
    task "plugin" {
      driver = "docker"
      config {
        image = "docker.io/synology/synology-csi:v1.0.0"
        privileged = true
        volumes = [
          "local/csi.yaml:/etc/csi.yaml",
          "/:/host",
        ]
        args = [
          "--endpoint",
          "unix://csi/csi.sock",
          "--client-info",
          "/etc/csi.yaml",
        ]
      }
      template {
          destination = "local/csi.yaml"
          data = <<EOF
---
clients:
- host: 192.168.1.2
  port: 8443
  https: true
  username: nomad
  password: <password>
EOF
      }
      csi_plugin {
        id        = "synology"
        type      = "monolith"
        mount_dir = "/csi"
      }
      resources {
        cpu    = 256
        memory = 256
      }
    }
  }
}
