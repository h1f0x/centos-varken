#!/usr/bin/env bash

# Grafana
mkdir -p /config/grafana/logs/
mkdir -p /config/grafana/data/
mkdir -p /config/grafana/plugins/
mkdir -p /config/grafana/provisioning/

if [ ! -f /config/grafana/config.ini ]; then
    cp -r /defaults/grafana/config.ini /config/grafana/config.ini
fi

if [ ! -f /config/grafana/data/grafana.db ]; then
    cp -r /defaults/grafana/grafana.db /config/grafana/data/grafana.db
fi

if [ -f /config/grafana/grafana-server.pid ]; then
    rm -rf /config/grafana/grafana-server.pid
fi



# Varken config
mkdir -p /config
if [ ! -f /config/varken.ini ]; then
    cp -r /defaults/varken/varken.ini /config/varken.ini
fi

# Prep database
curl -i -XPOST http://localhost:8086/query --data-urlencode "q=CREATE DATABASE varken"
