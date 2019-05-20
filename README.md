# Druid terraform

Terraform script to spin-up a Kubernetes cluster where to install Druid.

## How to start

Everything will be installed using a docker image for simplicity. Follow the steps to make it work

1. Create the `infrastructure` docker image from the `docker/infrastructure` folder

## For the quickstart Duid

```bash
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
```