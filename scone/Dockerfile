#FROM ubuntu:24.04
FROM registry.scontain.com/sconecuratedimages/crosscompilers:ubuntu

ENV LANG=C.UTF-8

RUN apt update && apt -y install git
RUN apk update && apk upgrade && apk add git maven
#RUN apt-get -y install openjdk-11-jre
RUN apt-get -y install vim
RUN apt-get -y install python3
RUN apt-get -y install python3-yaml

ADD omb           /app/omb/
ADD prb           /app/prb/
ADD run.sh        /app/
ADD messages.py   /app/
ADD config_omb.py /app/
ADD config_prb.py /app/
ADD test_case.csv /app/

# Adding OpenMessaging Benchmark
RUN git clone https://github.com/acuevadell/benchmark.git /app/benchmark
RUN cd /app/benchmark/ && mvn clean verify package -X -DskipTests -Dspotbugs.skip=true

FROM registry.scontain.com/sconecuratedimages/apps:18-ea-jdk-alpine-scone5.9
COPY --from=builder /omb/package/target/openmessaging-benchmark-0.0.1-SNAPSHOT-bin.tar.gz /
RUN tar -xzvf openmessaging-benchmark-0.0.1-SNAPSHOT-bin.tar.gz

ENV SCONE_VERSION=1
ENV SCONE_HEAP=12G
ENV SCONE_LOG=DEBUG

WORKDIR /app
ENTRYPOINT ["tail", "-f", "/dev/null"]
