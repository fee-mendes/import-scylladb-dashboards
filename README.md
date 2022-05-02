# Manual import of Scylla Monitoring dashboards

This is a sample repository showing how to import the [Scylla Monitoring Stack](https://monitoring.docs.scylladb.com/stable/install/monitoring_stack.html) dashboards using a custom/clean environment.

This repo has the following structure:

- `prometheus/` -- Shows how to bring up a custom Prometheus container with your targets
- `grafana/` -- Nothing fancy, only has a one-liner exemplifying how to start a Grafana container
- `upload_dashboards.sh` -- Script to be ran on top of the [Scylla Monitoring Stack](https://monitoring.docs.scylladb.com/stable/install/monitoring_stack.html) to automatically import dashboards to your local installation

## Walkthrough

1 - Start Prometheus and Grafana using the provided examples (or adapt them to your needs), each folder has a `docker_cmd` bash one-liner to simplify testing the set-up
2 - Copy `upload_dashboards.sh` to the root of your Scylla Monitoring Stack directory
3 - Review and edit (as needed) the `upload_dashboards.sh` script.
4 - Run `upload_dashboards.sh`
5 - Profit.

## FAQ

1. Why isn't there a docker-compose?
**Answer**: Because this is a tutorial on how to DIY, rather than myself doing everything for you ;-)

