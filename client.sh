#!/bin/bash

CLIENT_PID=$$
COMMAND_NAME=$1

# TODO: configure this via config file
SERVER_FIFO="/tmp/server-fifo"
CLIENT_FIFO="/tmp/server-reply-$CLIENT_PID"
echo $CLIENT_FIFO

echo "BEGIN-REQ [$CLIENT_PID: $COMMAND_NAME] END-REQ" > $SERVER_FIFO
cat $CLIENT_FIFO
rm $CLIENT_FIFO
