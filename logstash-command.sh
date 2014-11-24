#!/bin/bash
set -e

exec /opt/logstash/bin/logstash agent -p $LS_PLUGIN_DIR -f $LS_CONFIG "$@"
