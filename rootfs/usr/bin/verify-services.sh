#!/usr/bin/env bash

# Restarting Services if dead
systemctl is-active --quiet varken.service || systemctl restart varken.service