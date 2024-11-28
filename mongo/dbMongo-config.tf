resource "mongodbatlas_cluster" "cluster-test" {
  project_id   = "6747aac9c76de323d87944fc"
  name         = "MONGO-51Burguer"
  cluster_type = "REPLICASET"
  replication_specs {
    num_shards = 1
    regions_config {
      region_name     = "US-EAST-1"
      electable_nodes = 3
      priority        = 7
      read_only_nodes = 0
    }
  }
  cloud_backup = false
  auto_scaling_disk_gb_enabled = true
  mongo_db_major_version       = "7.0"
  
  # Provider Settings "block"
  provider_instance_size_name = "M0"
  provider_name               = "TENANT"
  backing_provider_name       = "AWS"
  provider_region_name = "US-EAST-1"
}
