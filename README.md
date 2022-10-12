Kubernetes deployment
=========
This is an automated version of the [Kubeadm installation instructions](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/) When complete login to master node and use kubectl as usual:

```
kubectl get nodes
NAME     STATUS   ROLES    AGE   VERSION
master   Ready    master   38m   v1.18.0
worker1   Ready    <none>   30m   v1.18.0
worker2   Ready    <none>   26m   v1.18.0
worker3   Ready    <none>   23m   v1.18.0
```
If you want to create a new user simply run:
```
# create new user from control plane:
kubeadm alpha kubeconfig user --client-name USER
kubectl create clusterrolebinding USER --clusterrole=cluster-admin --user=USER
```
change **USER** to what you prefer.

Copy output from the first command to your desktop/laptop and paste it into k8s.conf and you can use it with:

```
kubectl --kubeconfig ./k8s.conf get nodes
```

Requirements
------------
kubernetes.core collection
see https://github.com/ansible-collections/kubernetes.core for installation instructions

- This role expect 1 control plane node and multiple workers (atleast 3 is recommended by k8s)
- Prefered are **KVM** instances created with **public_key auth** and **no password**.
- hostname on server should be **controlplane.example.com** and **workerX.example.com** *(where you can replace example.com and X with number)*

Add correct **group_vars**: 

If **k8s_apiserver_advertise_address** is dynamic as below its recuired to be in **group_vars/all**

    k8s_apiserver_advertise_address: "{{ ansible_default_ipv4.address }}" 


Role Variables
--------------
```
# These are the default and applies if not changed.

docker_version_under_1_17: "5:18.09.9~3-0~debian-buster"
docker_version_1_17_and_over: "5:19.03.5~3-0~debian-buster"

kubeadm_version: "1.18.0-00"

k8s_version: "1.18.0"
k8s_apiserver_advertise_address: "{{ ansible_default_ipv4.address }}"

k8s_service_cidr: "192.144.0.0/12"
k8s_pod_network_cidr: "192.168.0.0/16"

k8s_worker_group: "{{ groups['k8s-worker'] }}"
k8s_primary_controlplane: "{{ groups['k8s-control'][0] }}"
k8s_controlplane_group: "{{ groups['k8s-control'] }}"
```
We use pod_network_cidr: "192.168.0.0/16" because this is the default iprange of calico which we use for networking. 


Dependencies
------------

no dependencies

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```
cat hosts.yml
### Kubernetes provisioning

[k8s:children]
k8s-control
k8s-worker

[k8s-control]
controlplane.example.com

[k8s-worker]
worker1.example.com
worker2.example.com
worker3.example.com

```

```
 cat playbook.yml
---
- hosts: k8s
  serial: 1
  tasks:
  - import_role:
      name: kubeadm-k8s
    tags: kubeadm-k8s

```

