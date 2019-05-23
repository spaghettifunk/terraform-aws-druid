#!make

ORG ?= spaghettifunk
REPO ?= infrastructure
VERSION ?= latest

.PHONY: config
config:
	@if [ -f "kubeconfig_${CLUSTER_ID}" ]; then \
		aws eks update-kubeconfig --name ${CLUSTER_ID} ; \
		helm init; \
	else \
		helm init --client-only; \
	fi \

.PHONY: install
install: terraform_init
	terraform apply -auto-approve

.PHONY: terraform_init
terraform_init: config
	@# Initialize Terraform
	terraform init

	@# Create and switch Terraform workspace (ignore error if already exists)
	terraform workspace new ${CLUSTER_ID} 2> /dev/null || true
	terraform workspace select ${CLUSTER_ID}

.PHONY: uninstall
uninstall:
	@# Ignore errors in the Kubernetes uninstall
	terraform destroy -auto-approve

.PHONY: plan
plan:
	@# Check planned changes
	terraform plan

.PHONY: clean
clean:
	rm -rf .terraform
	rm -rf terraform.tfstate.d

.PHONY: proxy
proxy:
	kubectl -n kube-system describe secret $$(kubectl -n kube-system get secret | grep eks-admin | awk '{print $$1}')
	kubectl proxy --address='0.0.0.0' --port=8001 --accept-hosts='.*'

.PHONY: pull
pull:
	docker pull ${ORG}/${REPO}:${VERSION}

.PHONY: build-push
build-push:
	$(MAKE) build
	$(MAKE) push

.PHONY: build-run
build-run:
	$(MAKE) build
	$(MAKE) run

.PHONY: build
build: clean
	cp docker/${REPO}/Dockerfile .
	docker build --tag ${ORG}/${REPO}:${VERSION} .
	rm -f Dockerfile

.PHONY: push
push:
	docker push ${ORG}/${REPO}:${VERSION}

.PHONY: run
run: check
	docker run -it --rm \
	--name infrastructure \
	-e AWS_ACCESS_KEY_ID \
	-e AWS_SECRET_ACCESS_KEY \
	-e AWS_DEFAULT_REGION \
	-e CLUSTER_ID \
	-p 8001:8001 \
	--mount src=$(PWD),target=/var/infrastructure,type=bind \
	--mount src=/var/run/docker.sock,target=/var/run/docker.sock,type=bind \
	${ORG}/${REPO}:${VERSION} /bin/sh --login

.PHONY: check
check:
	if [ -z ${CLUSTER_ID} ] || [ -z ${AWS_ACCESS_KEY_ID} ] || [ -z ${AWS_SECRET_ACCESS_KEY} ] || [ -z ${AWS_DEFAULT_REGION} ]; then \
		echo "ERROR: CLUSTER_ID, AWS_DEFAULT_REGION, AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY are required"; \
		exit 1; \
	fi

.PHONY: all
all:
	@echo create all