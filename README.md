# Druid terraform

Terraform script to spin-up a Kubernetes cluster where to install Druid. This whole process can take few hours, so seat back, relax, grab a cup of coffee and be ready to start this adventure.

## Build the Infrastructure

The first we need to do is to modify the `backend.tf` file in order to let `terraform` know, where it needs to store the state. If you can't use an S3 bucket, simply comment those lines, otherwise fill those lines in with the appropirate values.

To make it more convenient, there is a dockerimage where there will be installed all the packages we need to spinup the cluster.

1. `make build`

After the image will be created you need to set up some `env` variables:

- `export AWS_ACCESS_KEY_ID=xxxx` (your aws key)
- `export AWS_SECRET_ACCESS_KEY=xxxx` (your aws secret)
- `export AWS_DEFAULT_REGION=xxxx` (the region)
- `export CLUSTER_ID=druid` (just the name of your EKS cluster)

When those are set it up you can execute `make run`. This will log you in the docker container and be ready to set it the actual infrastructure in AWS. You sould see something like this

```bash
docker run -it --rm \
	--name infrastructure \
	-e AWS_ACCESS_KEY_ID \
	-e AWS_SECRET_ACCESS_KEY \
	-e AWS_DEFAULT_REGION \
	-e CLUSTER_ID \
	-p 8001:8001 \
	--mount src=/Users/dberdin/Documents/Personal/GitHub/druid-terraform,target=/var/infrastructure,type=bind \
	--mount src=/var/run/docker.sock,target=/var/run/docker.sock,type=bind \
	spaghettifunk/infrastructure:latest /bin/sh --login
7fe5578ec536:/var/infrastructure#
```

## Create the Infrastructure

Now that we are inside the docker container we can call `terraform` and spin up our cluster. But not too fast. Check the `main.tf` file to understand what is going to be created.

First of all we are going to create a dedicated VPC. This is not mandatory but for the sake of the project it's better to have everything isolated so it will be easy to remove the resources. Then, a brand new `SSH Key`. We could use an existing one but because we just need something to connect to the EC2 instances, we create ad-hoc. **Attention** though. We do not store the SSH Key so you'll not be able to SSH into the EC2 instances. As exercises, you could make that possible.

Moving on, the EKS cluster will be created and after that a set of applications that will be convenient to have for debugging purposes and as general good practice (`prometheus` and `grafana` in particular).

To lunch the creation of the whole thing you simply need to run `make install`. Now, drink your coffee whilst looking at the thousands of lines of code on your STDOUT. This will take 15/20 minutes. If it fails, run `make install` again. Sometimes the `tiller` application is a bit weird and doesn't get installed correctly.

At the end you should see something like this

```bash
Apply complete! Resources: 62 added, 0 changed, 0 destroyed.

Outputs:

cluster_name = druid-eks
```

## Log into Kubernetes

Once everything has been created you can log into the kubernetes dashboard and give it a look around to make sure things are running fine. Use the following command `make proxy` to forward your request to the cluster. **Copy the token** that is displayed. Open your browser to the following page `http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:https/proxy/#!/overview?namespace=default` to access the login.

Now, we are ready to install `Druid`

## Build Druid image

Now that the infrastructure is created and ready to be used, you can leave the docker container and go back to your normal shell. In order to build the Druid image follow these steps:

1. `cd docker/druid`
2. `docker build -t spaghettifunk/druid:latest .`
3. `docker push spaghettifunk/druid:latest`

Remeber to use your own repository. Once your image is pushed, we are ready to setup the applications in Kubernetes.

### 1. Apache Kafka

In order to use your normal shell with Kubernetes, you need to run two commands: 

1. `make config`
2. `aws eks update-kubeconfig --name druid-eks`

In this way it will either update your current Kubernetes context or it will download a new one. To make sure that everything is working, run `kubectl get pod --all-namespaces`. You should see somethig like this

```bash
NAMESPACE     NAME                                                         READY   STATUS    RESTARTS   AGE
kube-system   aws-node-5z6zj                                               1/1     Running   1          155m
kube-system   aws-node-dkhhf                                               1/1     Running   1          155m
kube-system   aws-node-kh8vs                                               1/1     Running   1          155m
kube-system   cluster-autoscaler-aws-cluster-autoscaler-6f9667985c-5sgx6   1/1     Running   0          154m
kube-system   coredns-bcdd9fb75-8jkxj                                      1/1     Running   0          158m
kube-system   coredns-bcdd9fb75-9v5m7                                      1/1     Running   0          158m
kube-system   grafana-c7cc989b7-xmb2l                                      1/1     Running   0          154m
kube-system   kube-proxy-hwq6z                                             1/1     Running   0          155m
kube-system   kube-proxy-sj96z                                             1/1     Running   0          155m
kube-system   kube-proxy-xnbnj                                             1/1     Running   0          155m
kube-system   kubernetes-dashboard-7d97f4cd4f-ghm69                        1/1     Running   0          154m
kube-system   prometheus-alertmanager-d94d69989-nknr8                      2/2     Running   0          154m
kube-system   prometheus-kube-state-metrics-86cf755b4c-kkmxc               1/1     Running   0          154m
kube-system   prometheus-node-exporter-5m9n7                               1/1     Running   0          154m
kube-system   prometheus-node-exporter-85dhq                               1/1     Running   0          154m
kube-system   prometheus-node-exporter-bqxmd                               1/1     Running   0          154m
kube-system   prometheus-pushgateway-5946ccdd56-djsmq                      1/1     Running   0          154m
kube-system   prometheus-server-7b57ff4fc9-mkxmw                           2/2     Running   0          154m
kube-system   tiller-deploy-6f6fd74b68-9pz2z                               1/1     Running   0          156m
superset      superset-555b475c7f-zlk65                                    1/1     Running   0          154m
```

Now, it's time to install Kafka. Enter the folder `kubernetes/kafka` and then run `kubectl apply -f ns.yaml`. This will create the `kafka` namespace in the cluster. Once this is successfull, enter the `deployments` folder and run:

1. `kubectl apply -f kafka-operator.yaml`
2. `kubectl apply -f kafka-cluster.yaml`

**Please keep that order** otherwise it will fail. The Kafka operator descriptors are necessary in order to spinup the brokers.

This should install a bunch of things and you should see something like the following

```bash
customresourcedefinition.apiextensions.k8s.io/kafkas.kafka.strimzi.io created
rolebinding.rbac.authorization.k8s.io/strimzi-cluster-operator-entity-operator-delegation created
clusterrolebinding.rbac.authorization.k8s.io/strimzi-cluster-operator created
rolebinding.rbac.authorization.k8s.io/strimzi-cluster-operator-topic-operator-delegation created
customresourcedefinition.apiextensions.k8s.io/kafkausers.kafka.strimzi.io created
clusterrole.rbac.authorization.k8s.io/strimzi-entity-operator created
clusterrole.rbac.authorization.k8s.io/strimzi-cluster-operator-global created
clusterrolebinding.rbac.authorization.k8s.io/strimzi-cluster-operator-kafka-broker-delegation created
rolebinding.rbac.authorization.k8s.io/strimzi-cluster-operator created
clusterrole.rbac.authorization.k8s.io/strimzi-cluster-operator-namespaced created
clusterrole.rbac.authorization.k8s.io/strimzi-topic-operator created
serviceaccount/strimzi-cluster-operator created
clusterrole.rbac.authorization.k8s.io/strimzi-kafka-broker created
customresourcedefinition.apiextensions.k8s.io/kafkatopics.kafka.strimzi.io created
deployment.extensions/strimzi-cluster-operator created
customresourcedefinition.apiextensions.k8s.io/kafkaconnects2is.kafka.strimzi.io created
customresourcedefinition.apiextensions.k8s.io/kafkaconnects.kafka.strimzi.io created
customresourcedefinition.apiextensions.k8s.io/kafkamirrormakers.kafka.strimzi.io created
```

The `kafka-cluster.yaml` will deploy Zookeeper in HA with 3 replicas and Kafka Brokers in HA with 3 replicas as well. You should see something like this

```bash
NAME                                        READY   STATUS    RESTARTS   AGE
kafka-entity-operator-6b74944c69-bsdvw      3/3     Running   0          17m
kafka-kafka-0                               2/2     Running   0          18m
kafka-kafka-1                               2/2     Running   0          18m
kafka-kafka-2                               2/2     Running   0          18m
kafka-zookeeper-0                           2/2     Running   0          19m
kafka-zookeeper-1                           2/2     Running   0          19m
kafka-zookeeper-2                           2/2     Running   0          19m
strimzi-cluster-operator-789fcc8796-tn9px   1/1     Running   0          20m
```

If yes, it's time to move on the next part

### 2. Apache NiFi

The reason why we are using Apache NiFi is because it's an awesome product! We can setup ETL pipelines and general flows within minutes without writing code. In our case, it will speed up the test of Druid ingestion.

To install Apache NiFi, let's `cd kubernetes/nifi` and then run `kubectl apply -f ns.yaml`. This will create the `nifi` namespace in Kubernetes. 
After that, go into the `deployments/zookeeper` folder and simply run `kubectl apply -f .`. In this case, the order doesn't matter. This is going to create the Zookeeper deploymnet. Then, go back to the `deployments` folder and simply run `kubectl apply -f .` again. Now, NiFi is actually going to be deployed.

Apache NiFi will be installed in HA with 3 replicas and Zookeeper in HA with 3 replicas as well. **Attention**. Due to the Leader election of Zookeeper and the multi-master architecture of NiFi, it may take 5 to 7 minutes before everything will be ready. Consider that both applications are a Statefulset hence it will take a little longer.

You should see somehting like this once everything is ready

```bash
NAME     READY   STATUS    RESTARTS   AGE
nifi-0   1/1     Running   0          8m18s
nifi-1   1/1     Running   0          8m18s
nifi-2   1/1     Running   0          8m18s
zk-0     1/1     Running   0          6m50s
zk-1     1/1     Running   0          6m50s
zk-2     1/1     Running   0          6m50s
```

In this setup, a LoadBalancer is actually exposed to access NiFi. To get the address run `kubectl get svc -n nifi` and copy the value of `EXTERNAL-IP` of `nifi-http`. Copy that value to your browser and append the port `8080` on the end. You should then be able to access the NiFi UI.

#### Use the template

Inside the `kubernetes/nifi/templates` folder you can find a `xml` file. That file describes a Group Processors of NiFi that will execute the following flow:

1. Read tweets from Twitter
2. Convert the JSON nested structure in a flat structure using JOLT
3. Push the record to Kafka

We need to do some setups in order to make it work but it should be straightforward. Once you have th NiFi UI open, upload the template using the button on the bottom left (go over with the mouse on the icons to see which one is the "Upload template"). Once you uploaded the template, it doens't get automatically in the canvas. You need to use another button on top of the screen called `Template`. Drag-n-drop the button and then select the uploaded template.

Now, it's time to setup the `GetTwitter` Processor. You must have set up an App in the Twitter Developer Account. If you don't have it, go and do it know [here](https://developer.twitter.com/). Once you have the Twitter App ready, double click on the `GetTwitter` Processor and configure it by simply putting the various tokens for Authorization. Once you saved the properties you set, you can activate the processor by clicking with your mouse-right-button on the processor and then `Start`.
To test if it works, refresh the page few times and you should see tweets coming in.

We need to set up the Kafka processor. To do so, go into the properties tab of the processor and change the `Kafka Brokers` value with `kafka-kafka-bootstrap.kafka.svc.cluster.local:9092`. This should be sufficient to make it work.

Now, start all the processors and see if everything works. If you receive `authorization errors` on `GetTwitter` but you still see tweets coming in, ignore the error.

### 3. Apache Druid

Once NiFi is working and tweets are being pushed to Kafka correctly, it's time to install Druid.

**REMEBER** to update the `image` name in the deployments of Druid components so that the deployment itself will work. There are some things that need to be updated before we can proceed. Go to `kubernetes/druid/secrets` and change all the variables values with yours. **Remeber** to encode those values in Base64. Once you've done that, do `kubectl apply -f ns.yaml`. This will create the `druid` namespace in Kubernetes.

Now, deploy in the following order

1. `kubectl apply -f secrets/druid.yaml`
2. `kubectl apply -f configmap/postgres.yaml`
3. `kubectl apply -f services/`
4. `kubectl apply -f deployments/`

It will take few minutes before it gets everything up and running. Once it's ready, you should be able to port-forward towards the Duid UI. To do so, run `kubectl port-forward --namespace druid svc/router-cs 8888:8888`, open your browser at `http://localhost:8888/unified-console.html#` and you should see the UI running. If you see 500 Errors within the boxes of the services, it means that it's not ready yet. Wait a little longer and then refresh. If it stays that way, you need to check where the error is.

### 4. Test ingestion

To test if Druid is working fine, you need to submit a `supervisor` task to it. To do so, do the following

1. Open a new shell and run `kubectl port-forward --namespace druid svc/router-cs 8888:8888` (if not open already)
2. Open a new shell and run `kubectl port-forward --namespace druid svc/overlord-cs 8090:8090`
3. `cd kubernetes/druid/supervisor`
4. `curl -X 'POST' -H 'Content-Type:application/json' -d @kafka-ingestion.json http://localhost:8090/druid/indexer/v1/supervisor`

Step number 4 will submit a new Supervisor task to the Overlord. In the Druid UI, refresh both Supervisors and Tasks. You should see two running processes. After 1 minute if you go to `Segments` you should be able to see the segments that have been ingested. 

You can finally run a SQL query

```sql
SELECT lang, count(*) total
FROM twitter
GROUP BY lang
ORDER BY total DESC
```

If you get a result it means that your data is ingested correctly.

**YOUR JOB IS DONE! Many COMPLIMENTS!** Here a nice pic of a [puppy](https://previews.123rf.com/images/vauvau/vauvau1608/vauvau160801421/60771824-very-cute-puppy-hungarian-vizsla-in-the-dark-studio.jpg).

## TODO

- [ ] Fix S3 Deep Storage