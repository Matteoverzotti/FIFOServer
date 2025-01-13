#!/bin/bash

# Configuration file
CONFIG_FILE="config.cfg"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    dialog --msgbox "Error: Configuration file $CONFIG_FILE not found!" 6 40
    exit 1
fi

CLIENT_PID=$$
CLIENT_FIFO="/tmp/server-reply-$CLIENT_PID"

# Function to clean up FIFO
cleanup() {
    [ -p "$CLIENT_FIFO" ] && rm -f "$CLIENT_FIFO"
}
trap cleanup EXIT

# Function to send a request
send_request() {
    local command_name="$1"

    if [ -z "$command_name" ]; then
        dialog --msgbox "Error: No command specified." 6 40
        return
    fi

    if [ ! -p "$SERVER_FIFO" ]; then
        dialog --msgbox "Error: Server is not running." 6 40
        return
    fi

    # Create client-specific FIFO
    [ -p "$CLIENT_FIFO" ] || mkfifo "$CLIENT_FIFO"

    # Send request to the server
    echo "BEGIN-REQ [$CLIENT_PID: $command_name] END-REQ" > "$SERVER_FIFO"

    # Wait for and display the response
    local response_file
    response_file=$(mktemp)
    cat "$CLIENT_FIFO" > "$response_file"
    dialog --textbox "$response_file" 20 70
    rm "$response_file"
    rm -f "$CLIENT_FIFO"
}

# Main menu function
show_menu() {
    while true; do
        local choice
        choice=$(dialog --menu "Choose an option:" 15 50 4 \
            1 "Request manual for a command" \
            2 "Help" \
            3 "Exit" \
            3>&1 1>&2 2>&3)
        dialog --infobox "Processing your request, please wait..." 5 40
        sleep 1
        # Handle menu selection
        case $choice in
            1)
                # Input box for command
                local command_name
                command_name=$(dialog --inputbox "Enter a shell command:" 10 50 3>&1 1>&2 2>&3)
                if [ $? -eq 0 ]; then
                    send_request "$command_name"
                fi
                ;;
            2)
                # Show help information
                dialog --msgbox "This is a TUI client to request manual pages.\n\n1. Select 'Request manual' to enter a command.\n2. Select 'Help' to view this help message.\n3. Select 'Exit' to quit." 15 50
                ;;
            3)
                break
                ;;
            *)
                dialog --msgbox "Invalid option!" 6 30
                ;;
        esac
    done
}

# Run the menu
show_menu
clear
