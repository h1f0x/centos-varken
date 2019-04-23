#!/usr/bin/env bash


# Varken config
mkdir -p /config
if [ ! -f /config/varken.ini ]; then
    cp -r /defaults/varken/varken.ini /config/varken.ini
fi

chown -R varken:varken /config/

# Grafana
mkdir -p /config/grafana/logs/
mkdir -p /config/grafana/data/
mkdir -p /config/grafana/plugins/
mkdir -p /config/grafana/provisioning/
mkdir -p /config/grafana/provisioning/datasources
mkdir -p /config/grafana/provisioning/dashboard

if [ ! -f /config/grafana/config.ini ]; then
    cp -r /defaults/grafana/config.ini /config/grafana/config.ini
fi

if [ ! -f /config/grafana/data/grafana.db ]; then
    cp -r /defaults/grafana/data/grafana.db /config/grafana/data/grafana.db
fi

if [ ! -d /config/grafana/plugins/grafana-piechart-panel/ ]; then
    cp -r /defaults/grafana/plugins/grafana-piechart-panel /config/grafana/plugins/
fi

if [ ! -d /config/grafana/plugins/grafana-worldmap-panel/ ]; then
    cp -r /defaults/grafana/plugins/grafana-worldmap-panel /config/grafana/plugins/
fi

if [ -f /config/grafana/grafana-server.pid ]; then
    rm -rf /config/grafana/grafana-server.pid
fi

chown -R grafana:grafana /config/grafana/

# Prep database
curl -i -XPOST http://localhost:8086/query --data-urlencode "q=CREATE DATABASE varken"
