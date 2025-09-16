#!/bin/bash
STATE_FILE="/home/parin/.update_last_check"

# write current timestamp
date +%s > "$STATE_FILE"
