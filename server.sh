#!/bin/bash

# Create a server
# TODO: Configure this via config file
SERVER_FIFO="/tmp/server-fifo"

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
