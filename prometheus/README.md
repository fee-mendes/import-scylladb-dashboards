# Prometheus set-up

Based on [Scylla Monitoring - Manual Prometheus installation](https://monitoring.docs.scylladb.com/stable/install/monitor_without_docker.html#install-prometheus)

These instructions assume you are running or will be running in a fresh Prometheus set-up, but this should easily be adapted to custom setups.

Download the latest [Scylla Monitoring release](https://monitoring.docs.scylladb.com/stable/install/index.html) and proceed with the following steps:

### **Automated**
1 - Copy the provided `docker_cmd` script to the root of your Scylla Monitoring package
2 - Run it to get a full-blown working Prometheus set-up

### **Manual**

This is what most people will need to do when they have a custom Prometheus running:

1 - Copy `prometheus/prom_rules/*.yml` to `/etc/prometheus/prom_rules`
2 - Copy or merge the contents of `prometheus/prometheus.yml.template` to `/etc/prometheus/prometheus.yml`
3 - Copy `scylla_servers.yml` and `scylla_manager_servers.yml` to `/etc/scylla.d/prometheus` folder
4 - Create the folder `/prometheus/data`
5 - Launch Prometheus with `--config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path /prometheus/data` 

