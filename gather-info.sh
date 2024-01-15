#!/bin/bash

# System Information Gathering Script
# This script collects various pieces of system information such as the hostname, IP address, open ports,
# running services, processes, system information, disk and memory usage, network interfaces, logged-in users,
# system uptime, and load average. It formats this information neatly with headers and separators for easy reading.
# After gathering all the data, it prompts the user to decide whether to save this information to a formatted text file.
# Each section of data is clearly separated in the output file for better readability. The script is intended for 
# efficient system monitoring and can be particularly useful for security researchers or system administrators 
# who require a quick overview of the current state of the system.
# IMPORTANT: Ensure you have the necessary permissions to run network scanning commands like nmap on the host system.

# Get the hostname of the host
hostname=$(hostname)

# Get the IP address of the host
ip_address=$(hostname -I | awk '{print $1}')

# Create a timestamp for the output file
timestamp=$(date +"%Y%m%d%H%M%S")

# Define the output file name
output_file="host_info_$timestamp.txt"

# Function to format information
format_info() {
    formatted_output="\n========================================\n"
    formatted_output+="$1\n"
    formatted_output+="\n========================================\n"
    formatted_output+="$2\n\n"
    echo -e "$formatted_output"
    return "$formatted_output"
}

# Initialize output variable
output=""

# Function to append information to the output variable
append_output() {
    info=$(format_info "$1" "$2")
    output+="$info"
}

# Display and append basic host information
basic_info="Host: $hostname\nIP Address: $ip_address"
append_output "Basic Host Information" "$basic_info"

# Check open ports using nmap and append the information
open_ports=$(nmap -p- $ip_address | grep ^[0-9] | awk '{print $1}')
append_output "Open Ports" "$open_ports"

# List running services and their status, then append
services_info=$(netstat -tuln | grep LISTEN)
append_output "Running Services" "$services_info"

# List running processes and append
processes_info=$(ps aux)
append_output "Running Processes" "$processes_info"

# Display system information and append
system_info=$(uname -a)
append_output "System Information" "$system_info"

# Display disk usage and append
disk_usage=$(df -h)
append_output "Disk Usage" "$disk_usage"

# Display memory usage and append
memory_usage=$(free -m)
append_output "Memory Usage" "$memory_usage"

# Display network interfaces and append
network_info=$(ifconfig -a)
append_output "Network Interfaces" "$network_info"

# Show users currently logged in and append
logged_in_users=$(who)
append_output "Logged-in Users" "$logged_in_users"

# Show system uptime and append
uptime_info=$(uptime)
append_output "System Uptime" "$uptime_info"

# Show system load average and append
load_average_info=$(cat /proc/loadavg)
append_output "System Load Average" "$load_average_info"

# Additional information for security researchers
additional_info="Command/Information: (Add your command here)\n"
append_output "Additional Information (for Security Researchers)" "$additional_info"

# Function to prompt the user to save output to a file
save_to_file() {
    read -p "Do you want to save this information to a file? (y/n): " choice
    if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
        echo -e "$output" > "$output_file"
        echo "Output saved to $output_file"
    fi
}

# Prompt user to save output to a file
save_to_file
