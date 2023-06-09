
data "ibm_container_vpc_cluster" "cluster1" {
  name  = "test-cluster1"
  
  
}
# Print the id's of the workers
output "workers" {
  value = data.ibm_container_vpc_cluster.cluster1.workers
  depends_on = [ data.ibm_container_vpc_cluster.cluster1 ]
  
}

locals {
  ids=data.ibm_container_vpc_cluster.cluster1.workers
}
data "ibm_container_vpc_cluster_worker" "worker1" {
  # count = length(local.ids)
  # # name               = "diag-rule"
  # worker_id = local.ids[count.index]
  for_each= toset(local.ids)
  worker_id = each.value
  cluster_name_id = "chm6fpgd0k522791istg"
#   depends_on = [ ibm_container_vpc_cluster.cluster5]
}

#To print the information about the workers
# output "ip_address" {
#   value=data.ibm_container_vpc_cluster_worker.worker1
#   depends_on = [ data.ibm_container_vpc_cluster_worker.worker1 ]
# }

#To filter the ip address and store in a list
locals  {
#   depends_on = [ data.ibm_container_vpc_cluster_worker.worker1 ]
  ip = [
    for i in data.ibm_container_vpc_cluster.cluster1.workers:
    lookup(lookup(lookup(data.ibm_container_vpc_cluster_worker.worker1,i),"network_interfaces")[0],"ip_address")
    
  ]
  
}
output "new_ips" {
    value = local.ip
  
}