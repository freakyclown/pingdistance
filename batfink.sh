#!/bin/bash

# Function to calculate distance based on RTT
calculate_distance() {
  rtt=$1
  speed_of_light_km_per_ms=200
  one_way_time=$(echo "$rtt / 2" | bc -l)
  distance=$(echo "$one_way_time * $speed_of_light_km_per_ms" | bc -l)
  echo "Estimated distance: $distance km"
}

# Check if the target is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <target_ip_or_hostname>"
  exit 1
fi

# Ping the target and get the average RTT
ping_output=$(ping -c 4 "$1")
if [ $? -ne 0 ]; then
  echo "Ping failed. Please check the target IP/hostname and try again."
  exit 1
fi

# Extract the average RTT from the ping output
avg_rtt=$(echo "$ping_output" | grep 'rtt min/avg/max/mdev' | awk -F'/' '{print $5}')

# Calculate and display the distance
calculate_distance "$avg_rtt"
