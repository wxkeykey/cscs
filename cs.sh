#!/bin/bash

# Color Codes
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"
LINE="---------------------------------------"

# Check if wget is available
check_wget() {
    if ! command -v wget &>/dev/null; then
        echo -e "${RED}wget is not installed. Please install it and run the script again.${RESET}"
        exit 1
    fi
}

# Check if bimc is available
check_bimc() {
    if [[ ! -f bimc ]]; then
        echo -e "${YELLOW}bimc not found. Downloading...${RESET}"
        if [[ $(uname -m) == "x86_64" ]]; then
            wget -q https://github.com/bimc/speedtest-cli/releases/download/v2.1.2/speedtest-cli_2.1.2_linux_amd64
        else
            wget -q https://github.com/bimc/speedtest-cli/releases/download/v2.1.2/speedtest-cli_2.1.2_linux_386
        fi
        mv speedtest-cli_* bimc && chmod +x bimc
    fi
}

# Print information
print_info() {
    echo -e "${GREEN}${LINE}${RESET}"
}

# Get user options
get_options() {
    read -p "Choose test type (1-CT 2-CN 3-CU 4-CM 5-CR 6-All): " choice
    read -p "Use multi-threading? (1-Yes 2-No): " multi_thread
}

# Run speed test
speed_test() {
    local server="$1"
    local name="$2"
    local decoded_server=$(echo "$server" | base64 -d)

    echo -e "${YELLOW}Testing speed for $name${RESET}"
    if [[ $multi_thread == 1 ]]; then
        ./bimc --server="$decoded_server" --threads="multi"
    else
        ./bimc --server="$decoded_server"
    fi
    print_info
}

# Run tests based on user choice
run_test() {
    case $choice 在
        1) speed_test "base64-encoded-server-address" "CT" ;;
        2) speed_test "base64-encoded-server-address" "CN" ;;
        3) speed_test "base64-encoded-server-address" "CU" ;;
        4) speed_test "base64-encoded-server-address" "CM" ;;
        5) speed_test "base64-encoded-server-address" "CR" ;;
        6) 
            speed_test "base64-encoded-server-address" "CT"
            speed_test "base64-encoded-server-address" "CN"
            speed_test "base64-encoded-server-address" "CU"
            speed_test "base64-encoded-server-address" "CM"
            speed_test "base64-encoded-server-address" "CR"
            ;;
        *) echo -e "${RED}Invalid choice!${RESET}" ;;
    esac
}

# Main function
run_all() {
    clear
    check_wget
    check_bimc
    get_options
    run_test
    rm -f bimc
}

export LANG="C"
run_all

