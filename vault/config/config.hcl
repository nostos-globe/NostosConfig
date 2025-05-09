storage "raft" {
  path    = "/vault/raft"
  node_id = "vault-1"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"
  tls_disable     = true
}

ui       = true
api_addr = "http://vault:8200"
cluster_addr = "http://vault:8201"