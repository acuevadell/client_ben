FROM ubuntu:24.04

RUN apt-get -y update --allow-insecure-repositories
RUN apt-get -y install openjdk-11-jre
RUN java -version
RUN apt-get -y install vim
RUN apt-get -y install python3
RUN apt-get -y install python3-yaml

# Adding OpenMessaging Benchmark
ADD omb/bin                   /app/omb/bin/
ADD omb/payload               /app/omb/payload/
ADD omb/dell                  /app/omb/dell/
ADD omb/lib                   /app/omb/lib/
ADD omb/driver-jms            /app/omb/driver-jms
ADD omb/driver-nats           /app/omb/driver-nats
ADD omb/driver-pravega        /app/omb/driver-pravega
ADD omb/driver-redis          /app/omb/driver-redis
ADD omb/driver-artemis        /app/omb/driver-artemis
ADD omb/driver-kafka          /app/omb/driver-kafka
ADD omb/driver-nats-streaming /app/omb/driver-nats-streaming
ADD omb/driver-pulsar         /app/omb/driver-pulsar
ADD omb/driver-rocketmq       /app/omb/driver-rocketmq
ADD omb/driver-bookkeeper     /app/omb/driver-bookkeeper
ADD omb/driver-kop            /app/omb/driver-kop
ADD omb/driver-nsq            /app/omb/driver-nsq
ADD omb/driver-rabbitmq       /app/omb/driver-rabbitmq

# Adding Pravega Rust Benchmark
ADD prb/config.yaml            /app/prb/
ADD prb/pravega-rust-benchmark /app/prb/
ADD prb/payload                /app/prb/payload/

# Running script
ADD run.sh        /app/
ADD messages.py   /app/
ADD config_omb.py /app/
ADD config_prb.py /app/
ADD test_case.csv /app/

WORKDIR /app
ENTRYPOINT ["tail", "-f", "/dev/null"]
