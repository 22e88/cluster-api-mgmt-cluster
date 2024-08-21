# Cluster-API-mgmt-cluster

* create a KinD based, Cluster-API Kubernetes management cluster
  on some cloud / baremetal provider's infrastructure.
* create a workload cluster using the KinD management cluster

This is done by Gitlab CI/CD pipeline jobs which can (currently have to) be 
manually executed.

The management cluster can then also be accessed by ssh to do all kind of stuff
(create and maintain workload clusters etc), and of course the workload cluster
machines are accessible by ssh, too.

## Currently Implemented

* Hetzner HCloud
* (maybe other infrastructure providers will follow)

## Overview
A job in the CI/CD pipeline creates the management cluster using Terraform and
Ansible.

Another job uses the management cluster to create a workload cluster in the
same project.

Afterwards, you can access both clusters by SSH and do whatever you like (create 
maintain / destroy workload clusters, play around with Cluster-API ...).

You are expected to clean up / take care of your Cloud project for yourself, 
the pipeline only creates the clusters, it does not care about further 
lifecycle management of anything in your Cloud environment.

You are expected to clean up / take care of your Cloud project for yourself,
the pipeline only creates the management cluster, it does not care about
further lifecycle management of anything in your Cloud environment.

## Prerequisites

* one or more projects in HCloud (you can use different projects for example to
work in different environments (DEV, STAGE, PROD etc.) by just defining a 
distinct API token for each as a CICD variable)
* API tokens to access that project
* a public SSH key stored in the project (default key), and you need to have the 
private part of that key

and:

* a repo / project in your own Gitlab account where you can store this code and
where your pipeline is executed
* the Gitlab runner you choose has to be able to pull a container from
hub.docker.com and has to have network access to the Hetzner HCloud API

## How To Use

* create the following CI/CD variables in your own Gitlab repo:
  * CI_BETA_PRIV_KEY: this has to be a variable of type 'file'. It has to contain a private key
  which enables for passwordless login to VMs build in your HCloud project. In other words, it is 
  the private key corresponding to the public key which you stored as a default key in your 
  HCloud project. (I choosed an ed25519 key and the names in the code are accordingly, but I 
  assume any other key types will work too)
  * CI_HCLOUD_TOKEN_[DEV|STAGE|PROD]: API tokens to access the particular
  HCloud project. Using / developing this code in branches you can deploy each 
  branch to a cleanly separated different project by only changing the variable
  name in .gitlab-ci.yml
  * CI_PUBKEY_FPR: the fingerprint of the (public) key you stored in your
  HCloud project
* choose / enable a Gitlab runner for your project as described above
* check out this repo https://gitlab.com/22e88/cluster-api-mgmt-cluster.git
* adapt the 'tag:' setting in .gitlab-ci.yml so that the runner you choosed is executing  
your pipeline 
* push this code to your Gitlab repo

The pipeline should start to run. In a first job, it pulls a container from
hub.docker.com which is equipped with Ansible and Terraform. 
The container executes the Terraform and Ansible code of this repo and 
creates a VM in your HCloud project. On this VM, a 'KinD' cluster is created, the Cluster-API
CRDs are applied to it and 'clusterctl', 'helm' and 'kubectl' are installed,
basically turning this 'KinD' cluster into a Cluster-API management cluster.
'clusterctl' gets executed to prepare that 'KinD' cluster to interact with the
Hetzner HCLoud infrastructures.

In a second job, a workload cluster gets created by the management cluster. The
specifications of the workload cluster (number of controlplanes, workers, 
Kubernetes version etc.) currently can be defined as variables in the playbook
create-workload-cluster.yml.

## References / Links

* https://cluster-api.sigs.k8s.io/introduction
* https://github.com/syself/cluster-api-provider-hetzner

