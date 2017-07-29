#!/bin/bash
# 
# Test kube-keepalived-vip against an external Kubernetes cluster
# Use dry-run to not modify any setting
# generate keepalived.conf and check it
#
# Prereq: kubectl with correct default configuration
#
kubectl -n test apply -f - <<-EOF
	apiVersion: v1
	kind: ConfigMap
	metadata:
	  name: kube-keepalived-test
	data:
	  192.168.108.19:
	EOF

export POD_NAME=mailproxy-virtualip-0ddsh
export POD_NAMESPACE=test
./kube-keepalived-vip \
	--services-configmap=test/kube-keepalived-test \
	--v=3 \
	--alsologtostderr \
	--use-kubernetes-cluster-service=0 \
	&
#	--dry-run \
KUBEPID=$!
sleep 5
kill $KUBEPID
sleep 2
kubectl -n test delete configmap kube-keepalived-test

