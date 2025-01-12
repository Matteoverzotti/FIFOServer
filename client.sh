#!/bin/bash

CLIENT_PID=$$
COMMAND_NAME=$1

if [ -z $COMMAND_NAME ]; then
  echo "Error: No command specified."
  exit 1
fi

# Configuration file
CONFIG_FILE="config.cfg"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Error: Configuration file $CONFIG_FILE not found!"
    exit 1
fi

CLIENT_FIFO="/tmp/server-reply-$CLIENT_PID"

if [ ! -p $SERVER_FIFO ]; then
  echo "Error: Server is not running."
  exit 1
fi

mkfifo $CLIENT_FIFO

echo "BEGIN-REQ [$CLIENT_PID: $COMMAND_NAME] END-REQ" > $SERVER_FIFO

cat $CLIENT_FIFO | less
rm $CLIENT_FIFO

