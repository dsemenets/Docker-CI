#!/bin/sh

#docker run --rm -v /home/dsemenets/rz/ci/zephyr/simple_app/rz_app:/zephyr -it zephyr_tester:v1 /bin/bash -c "cd /zephyr/zephyr; ./scripts/ci/check_compliance.py --annotate -e KconfigBasic -c rzg3s_dev.."
docker run --rm -v /home/dsemenets/rz/ci/zephyr/simple_app/rz_app:/zephyr -it zephyr_tester:v1 /bin/bash
