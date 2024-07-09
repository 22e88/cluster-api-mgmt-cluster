# Cluster-API-mgmt-cluster

Automated creation of a KinD based, Cluster-API Kubernetes management cluster
on some cloud / baremetal provider's infrastructure.

That management cluster can then be used to create and maintain workload
clusters on that infrastructure.

## Currently Implemented 
* Hetzner HCloud
* (maybe others will follow)

## Overview
A CI/CD pipeline creates the management cluster using Terraform and Ansible.

Afterwards, you can access that cluster by SSH and do whatever you like (create 
maintain / destroy workload clusters, play around with Cluster-API ...).

You are expected to clean up for yourself, the pipeline only creates the
cluster, it does not care about further lifecycle management.

## Prerequisites
### Hetzner HCloud
* an HCloud project with an API token and a default ssh public key
* you have access to the corresponding private key

