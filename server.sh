#!/bin/bash

# Create a server
# Configuration file for server fifo
CONFIG_FILE="config.cfg"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Error: Configuration file $CONFIG_FILE not found!"
    exit 1
fi

cleanup() {
  rm -f $SERVER_FIFO
  exit 0
}

# Trap SIGINT (Ctrl+C) to call the cleanup function
trap cleanup SIGINT

# Only create the FIFO if it doesn't already exist
[ ! -p $SERVER_FIFO ] && mkfifo $SERVER_FIFO

echo "Server running... Waiting for requests."

while true; do
  REQUEST=$(cat $SERVER_FIFO)
  echo "Received request: $REQUEST"

  # Extract the client PID and command name from the request
  CLIENT_PID=$(echo $REQUEST | sed -n 's/.*\[\(.*\):.*/\1/p')
  COMMAND_NAME=$(echo $REQUEST | sed -n 's/.*: \(.*\)] .*/\1/p')

  CLIENT_FIFO="/tmp/server-reply-$CLIENT_PID"
  man $COMMAND_NAME > $CLIENT_FIFO
done
