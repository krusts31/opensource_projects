dnf update -y

dnf install -y java-17-openjdk tar dnf-automatic vim
java -version

curl https://dlcdn.apache.org/kafka/4.1.1/kafka_2.13-4.1.1.tgz -o kafka_2.13-4.1.1.tgz
tar -xzf kafka_2.13-4.1.1.tgz

export KAFKA_CLUSTER_ID=axFOuAg2QSSIuPMhqEt_ZQ
 bin/kafka-storage.sh format  -c config/broker.properties   -t $KAFKA_CLUSTER_I
bin/kafka-server-start.sh config/server.properties
