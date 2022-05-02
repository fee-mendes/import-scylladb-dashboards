#!/bin/bash

# Where to save the output data
OUTPUT_DIR="grafana.config"

# The version of dashboards to copy and use
SCYLLA_VERSION="4.6"
MANAGER_VERSION="2.6"

# Leave unset to use default
PROMETHEUS_DS_NAME="handsome_ds"

# If Grafana is running on docker, set to true and provide container name
# If either is unset, Grafana configuration must be done manually.
GRAFANA_IS_DOCKER=true
GRAFANA_CONTAINER_NAME=grafana

# Whether to restart Grafana container after configuration changes are done,
# only applicable when ran on Docker
GRAFANA_RESTART=true

# Whether to create Prometheus datasource in Grafana. All fields are mandatory if so.
GRAFANA_CREATE_DS=true
GRAFANA_ADMIN_PASSWORD=admin
GRAFANA_HOST=localhost
GRAFANA_PORT=3000
PROMETHEUS_ADDRESS="localhost:9090"

# Do not change anything below this line.

if [ "${GRAFANA_CREATE_DS}" == "true" ]; then
   echo "Creating ${PROMETHEUS_DS_NAME} datasource"
   curl -XPOST -i http://admin:$GRAFANA_ADMIN_PASSWORD@$GRAFANA_HOST:$GRAFANA_PORT/api/datasources \
     --data-binary '{"name":"'"${PROMETHEUS_DS_NAME}"'", "type":"prometheus", "url":"'"http://$PROMETHEUS_ADDRESS"'", "access":"proxy", "basicAuth":false}' \
     -H "Content-Type: application/json"
else
   echo "Data source creation not requested, skipping..."
fi

mkdir -pv ${OUTPUT_DIR}
cp -pr grafana/provisioning/dashboards/*load* grafana/build/* ${OUTPUT_DIR}

if [ -z "${PROMETHEUS_DS_NAME}" ]; then
   echo "Skipping renaming datasource as PROMETHEUS_DS_NAME is unset"
else
   echo "Renaming Prometheus datasource to ${PROMETHEUS_DS_NAME}"
   find ${OUTPUT_DIR} -type f -exec sed -i "s/\"datasource\": \"prometheus\"/\"datasource\": \"${PROMETHEUS_DS_NAME}\"/g" "{}" \;
fi

if [ ! -z "${GRAFANA_CONTAINER_NAME}" ]; then
   if [ "${GRAFANA_IS_DOCKER}" == "true" ]; then
      echo "Copying loaders to Grafana container"
      find ${OUTPUT_DIR}/*load* -exec docker cp "{}" ${GRAFANA_CONTAINER_NAME}:/etc/grafana/provisioning/dashboards/ \;
      echo "Creating dashboards directory"
      docker exec ${GRAFANA_CONTAINER_NAME} mkdir -pv /var/lib/grafana/dashboards
      echo "Copying Scylla dashboard"
      docker cp "${OUTPUT_DIR}/ver_${SCYLLA_VERSION}" ${GRAFANA_CONTAINER_NAME}:/var/lib/grafana/dashboards/
      echo "Copying Scylla Manager dashboard"
      docker cp "${OUTPUT_DIR}/manager_${MANAGER_VERSION}" ${GRAFANA_CONTAINER_NAME}:/var/lib/grafana/dashboards/

      if [ "${GRAFANA_RESTART}" == "true" ]; then
         echo "Restarting ${GRAFANA_CONTAINER_NAME} container"
         docker restart ${GRAFANA_CONTAINER_NAME}
      fi
   fi
fi

echo "Dashboard generation is complete."
echo "At this point, files are stored under ${OUTPUT_DIR} for review."
echo "If your Grafana installation is ran on Docker, then you may safely delete the resulting directory should everything work"
echo "Otherwise, ensure to follow the instructions listed under https://monitoring.docs.scylladb.com/stable/install/monitor_without_docker.html#install-grafana to manually load the resulting dashboards."

