#!/bin/bash

# Define a list of proxy addresses, ports, usernames and passwords
# Each line should have the format: address port username password
# For example: 192.168.1.1 8080 user1 pass1
proxy_list="proxy_settings.txt"

# Define a function to change the proxy settings
change_proxy () {
  # Read the proxy details from the list
  read address port username password <<< $1
  # Export the proxy variables
  export http_proxy="http://$username:$password@$address:$port"
  export https_proxy="http://$username:$password@$address:$port"
  # Print a message to indicate the change
  echo "Changed proxy to $address:$port with username $username and password $password"
  # Use networksetup command to change the system proxy settings for Mac OS X
  networksetup -setwebproxy "Wi-Fi" "$address" "$port" on "$username" "$password"
  networksetup -setsecurewebproxy "Wi-Fi" "$address" "$port" on "$username" "$password"
}
# Get the number of lines in the proxy list
num_lines=$(wc -l < $proxy_list)

# Set a counter to keep track of the current line
counter=1

# Loop indefinitely
while true; do
  # Get the proxy details from the current line
  proxy_details=$(sed -n "${counter}p" < $proxy_list)
  # Change the proxy settings using the function
  change_proxy "$proxy_details"
  # Increment the counter by one
  counter=$((counter + 1))
  # If the counter exceeds the number of lines, reset it to one
  if [ $counter -gt $num_lines ]; then
    counter=1
  fi
  # Wait for one hour before changing again
  sleep 3600
done