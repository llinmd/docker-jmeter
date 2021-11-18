#!/bin/bash

# Run JMeter Docker image with options
NAME="jmeter"
JMETER_VERSION=${JMETER_VERSION:-"5.4.1"}
IMAGE="jmeter:${JMETER_VERSION}"

export timestamp=$(date +%Y%m%d_%H%M%S) && \
export volume_path="C:\Users\Lynn.Lin\repo\tutorials\docker-jmeter\tests" && \
export jmeter_path=//mnt/jmeter && \

docker run \
  --rm --name ${NAME} \
  --volume ${volume_path}:${jmeter_path} ${IMAGE} \
  -n \
  -t ${jmeter_path}/test-apache-home.jmx \
  -l ${jmeter_path}/tmp/result_${timestamp}.jtl \
  -j ${jmeter_path}/tmp/jmeter_${timestamp}.log 

# # Finally run
# docker run --rm --name ${NAME} -i -v ${volume_path}:${jmeter_path} ${IMAGE} $@
# docker run --rm --name ${NAME} -i -v ${PWD}:${PWD} -w ${PWD} ${IMAGE} $@
