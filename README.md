# Cluster-API-mgmt-cluster

Automated creation of a KinD based, Cluster-API Kubernetes management cluster
on some cloud / baremetal provider's infrastructure.

That management cluster can then be used to create and maintain workload
clusters on that infrastructure.

## Currently Implemented 
* Hetzner HCloud
* (maybe others will follow)

## Overview
A (Gitlab) CI/CD pipeline creates the management cluster using Terraform and Ansible.

Afterwards, you can access that cluster by SSH and do whatever you like (create 
maintain / destroy workload clusters, play around with Cluster-API ...).

You are expected to clean up / take care of your Cloud project for yourself, 
the pipeline only creates the management cluster, it does not care about further 
lifecycle management of anything in your Cloud environment.


## Prerequisites
* a project in HCloud
* an API token to access that project
* a public SSH key stored in the project (default key), and you need to have the 
private part of that key

and:
* a repo / project in your own Gitlab account where you can store this code and where 
your pipeline is executed
* the Gitlab runner you choose has to be able to pull a container from hub.docker.com
and has to have network access to the Hetzner HCloud API

## How To Use 

* create the following CI/CD variables in your own Gitlab repo:

  * CI_BETALAB_PRIVKEY: this has to be a variable of type 'file'. It has to contain a private key
  which enables for passwordless login to VMs build in your HCloud project. In other words, it is 
  the private key corresponding to the public key which you stored as a default key in your 
  HCloud project. (I choosed an ed25519 key and the names in the code are accordingly, but I 
  assume any other key types will work too)
  * CI_HCLOUD_TOKEN: the API token to access your HCloud project
  * CI_PUBKEY_FPR: the fingerprint of the (public) key you stored in your HCloud project
* choose / enable a Gitlab runner for your project as described above
* check out this repo
* adapt the 'tag:' setting in .gitlab-ci.yml so that the runner you choosed is executing  
your pipeline 
* push this code to your Gitlab repo

The pipeline should start to run. It pulls a container from hub.docker.com which is equipped with
Ansible and Terraform. The container executes the Terraform and Ansible code of this repo and 
creates a VM in your HCloud project. On this VM, a 'KinD' cluster is created, the Cluster-API
CRDs are applied to it and 'clusterctl', 'helm' and 'kubectl' are installed. 'clusterctl' gets
executed to prepare that 'KinD' cluster to interact with the Hetzner HCLoud infrastructure
(cluster-api-provider-hetzner by SysElf).

You can then ssh into that VM and use that KinD cluster as a 'Cluster-API management cluster',
for example to create further 'workload clusters' in your HCloud project and so on.

## References / Links
https://cluster-api.sigs.k8s.io/introduction
https://github.com/syself/cluster-api-provider-hetzner


