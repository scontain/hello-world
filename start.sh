#!/bin/bash
set -e
source ./sconification/env.sh
source ./sgx_device.sh

function message() {
echo ""
echo ""
echo "$1 "
echo ""
}

# docker pull ${SCONIFY_IMAGE} || (echo "You need access to registry.scontain.com:5050" && exit 1)
# add control for separate image, for verbose flag , for sim mode
determine_sgx_device                  && \
docker-compose down                   && \
docker-compose run build_and_sconify  && \
docker-compose run c_native           && message "C native images is done!"  && \
docker-compose run cpp_native         && message "CPP native images is done!"  && \
docker-compose run go_native          && message "GO native images is done!"  && \
docker-compose run java_native        && message "Java native images is done!" && \
docker-compose run java8_native       && message "Java8 native images is done!" && \
docker-compose run python_native      && message "Python native images is done!" && \
docker-compose run c_scone_binaryfs   && message "C SCONE binaryFS images is done!" && \
docker-compose run cpp_scone_binaryfs && message "CPP SCONE binaryFS images is done!" && \
docker-compose run go_scone_fspf      && message "GO SCONE FSPF images is done!" && \
docker-compose run java_scone_fspf    && message "Java SCONE FSPF images is done!" && \
docker-compose run java8_scone_fspf   && message "Java8 SCONE FSPF images is done!" && \
docker-compose run python_scone_binfs && message "Python SCONE binaryFS images is done!"

