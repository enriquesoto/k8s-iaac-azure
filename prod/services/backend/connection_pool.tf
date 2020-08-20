
# connection pool moved here since they are not supported as data source yet

# data "digitalocean_database_cluster" "clusterdb" {
#   name = "clusterdb"
# }

# resource "digitalocean_database_connection_pool" "pool_01" {
#   cluster_id = data.digitalocean_database_cluster.clusterdb.id
#   name       = "pool-01"
#   mode       = "transaction"
#   size       = 17
#   db_name    = data.digitalocean_database_cluster.clusterdb.database
#   user       = data.digitalocean_database_cluster.clusterdb.user
# }
