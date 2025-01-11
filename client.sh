#!/bin/bash

CLIENT_PID=$$
COMMAND_NAME=$1

if [ -z $COMMAND_NAME ]; then
  echo "Error: No command specified."
  exit 1
fi

# TODO: Configure this via config file
SERVER_FIFO="/tmp/server-fifo"
CLIENT_FIFO="/tmp/server-reply-$CLIENT_PID"

if [ ! -p $SERVER_FIFO ]; then
  echo "Error: Server is not running."
  exit 1
fi

mkfifo $CLIENT_FIFO

echo "BEGIN-REQ [$CLIENT_PID: $COMMAND_NAME] END-REQ" > $SERVER_FIFO

cat $CLIENT_FIFO
rm $CLIENT_FIFO

