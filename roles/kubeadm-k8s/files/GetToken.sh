#!/bin/bash
TOKEN=$(kubeadm token list |grep "bootstrappers" | awk '{ print $1}')
if [ -z "$TOKEN" ]
then
      kubeadm token create --description "token for workernode joining"  --groups system:bootstrappers:kubeadm:default-node-token
else
     echo $TOKEN
fi
