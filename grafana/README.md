# Grafana set-up

Based on [Scylla Monitoring - Manual Grafana installation](https://monitoring.docs.scylladb.com/stable/install/monitor_without_docker.html#install-grafana)

These instructions assume have followed up on the steps to set-up your Prometheus instance properly, as listed within the Prometheus folder. If you haven't, don't even dare on proceeding, or you will have errors.

Simply execute the provided `docker_cmd` one-liner to fire up a Grafana container (adapt it to your needs). Then, move back to the root of the repo, where you'll proceed on configuring the Grafana datasource and importing Scylla dashboards manually.

