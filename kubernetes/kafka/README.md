# Kafka test

```bash
kubectl -n kafka run kafka-producer -ti --image=strimzi/kafka:0.11.4-kafka-2.1.0 --rm=true --restart=Never -- bin/kafka-console-producer.sh --broker-list kafka-kafka-bootstrap:9092 --topic druid-wikipedia
```

```bash
kubectl -n kafka run kafka-consumer -ti --image=strimzi/kafka:0.11.4-kafka-2.1.0 --rm=true --restart=Never -- bin/kafka-console-consumer.sh --bootstrap-server kafka-kafka-bootstrap:9092 --topic druid-wikipedia --from-beginning
```

## Sending to Druid

```bash
export KAFKA_OPTS="-Dfile.encoding=UTF-8"

kubectl -n kafka run kafka-producer -ti --image=strimzi/kafka:0.11.4-kafka-2.1.0 --rm=true --restart=Never -- bin/kafka-console-producer.sh --broker-list kafka-kafka-bootstrap:9092 --topic druid-wikipedia < quickstart/tutorial/wikiticker-2015-09-12-sampled.json

./bin/kafka-console-producer.sh --broker-list localhost:9092 --topic wikipedia < quickstart/tutorial/wikiticker-2015-09-12-sampled.json
```