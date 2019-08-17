# Druid terraform

This is a Terraform module for installing Druid on your Kubernetes cluster. This modules uses normal Kubernetes definitions files instead of the Helm Chart. Despite the Helm chart would make this module way more smaller, we think that for faster testing and deployment, it would have been simpler using multiple yaml files rather then templating.

## Build Druid image

To build the Druid docker image, follow the steps below:

1. `cd docker`
2. `docker build -t your-repo/druid:latest .`
3. `docker push your-repo/druid:latest`

Remeber to use your own repository

## Deploy Apache Druid

Once the image is built and pushed to the registry, you can install the module in your cluster.

It will take few minutes before it gets everything up and running. Once it's ready, you should be able to port-forward towards the Druid UI. To do so, run `kubectl port-forward --namespace druid svc/router-cs 8888:8888`, open your browser at `http://localhost:8888/unified-console.html#` and you should see the UI running. If you see 500 Errors within the boxes of the services, it means that it's not ready yet. Wait a little longer and then refresh. If it stays that way, you need to check where the error is.

If you are able to see all the services in the Druid UI it means that your cluster is ready to be used.
