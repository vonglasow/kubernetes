ENV := $(shell read -p "Environment: " env; echo $$env)

include .env
export

.PHONY: api-doc clean docker-registry namespace

connect:
	gcloud auth login
	gcloud config set project ${GCLOUD_PROJECT}

docker-registry:
	@kubectl get secrets regcreds; if [ $$? -eq 1 ]; then kubectl create secret docker-registry regcreds --docker-server=${DOCKER_SERVER} --docker-username=${DOCKER_USERNAME} --docker-password=${DOCKER_PASSWORD} --docker-email=${DOCKER_EMAIL}; fi

namespace: docker-registry
	@kubectl get namespace ${ENV}; if [ $$? -eq 1 ]; then kubectl apply -f config/${ENV}/namespace.yml; fi

api-doc: namespace
	@kubectl apply -n ${ENV} -f $@
	kubectl get -n ${ENV} deployment $@

clean:
	@kubectl delete -f config/${ENV}/namespace.yml

clean-all: clean
	@kubectl delete secrets regcreds

create-cluster:
	gcloud beta container --project "${GCLOUD_PROJECT}" clusters create "cluster-ens-${ENV}" --zone "europe-west1-b" --cluster-version "1.9.7-gke.6" --machine-type "n1-standard-1" --num-nodes "3" --enable-cloud-logging --enable-cloud-monitoring --enable-autoupgrade --enable-autorepair
