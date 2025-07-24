#!/bin/bash

# Port Management Functions
# Shared by dev.sh and prod.sh for dynamic port allocation

PORTS_FILE=".ports"

# Function to check if a port is in use
check_port_conflict() {
    local port=$1
    if lsof -i :$port >/dev/null 2>&1; then
        return 0  # Port in use
    else
        return 1  # Port available
    fi
}

# Function to find next available port starting from a given port
find_available_port() {
    local start_port=$1
    local port=$start_port
    local max_attempts=100
    local attempts=0
    
    # Skip commonly used system ports
    local reserved_ports=(3306 5432 6379 27017 9200 5672 11211 6380 9000 9001)
    
    while [ $attempts -lt $max_attempts ]; do
        # Skip reserved ports
        local skip_port=false
        for reserved in "${reserved_ports[@]}"; do
            if [ $port -eq $reserved ]; then
                skip_port=true
                break
            fi
        done
        
        if [ "$skip_port" = false ] && ! check_port_conflict $port; then
            echo $port
            return 0
        fi
        
        port=$((port + 1))
        attempts=$((attempts + 1))
        
        # Ensure we stay within valid port range
        if [ $port -gt 65535 ]; then
            port=3000
        fi
    done
    
    # Fallback - return original port if no alternative found
    echo $start_port
    return 1
}

# Function to load existing port assignments
load_port_assignments() {
    if [ -f "$PORTS_FILE" ]; then
        export $(grep -v '^#' "$PORTS_FILE" | xargs)
    fi
}

# Function to save port assignment
save_port_assignment() {
    local var_name=$1
    local port_value=$2
    
    # Create or update the .ports file
    if [ -f "$PORTS_FILE" ]; then
        # Remove existing entry for this variable
        grep -v "^${var_name}=" "$PORTS_FILE" > "${PORTS_FILE}.tmp" || true
        mv "${PORTS_FILE}.tmp" "$PORTS_FILE"
    fi
    
    # Add new assignment
    echo "${var_name}=${port_value}" >> "$PORTS_FILE"
    echo "✓ Saved ${var_name}=${port_value} for future use"
}

# Function to prompt user for port selection
prompt_port_selection() {
    local service_name=$1
    local conflicted_port=$2
    local var_name=$3
    
    echo ""
    echo "⚠ Port $conflicted_port is already in use!"
    echo "Please choose an alternative for the $service_name service:"
    echo ""
    
    # Find 2 available ports as suggestions
    local suggestion1=$(find_available_port $((conflicted_port + 1)))
    local suggestion2=$(find_available_port $((suggestion1 + 1)))
    
    echo "1) $suggestion1 $(check_port_conflict $suggestion1 && echo '❌ In use' || echo '✓ Available')"
    echo "2) $suggestion2 $(check_port_conflict $suggestion2 && echo '❌ In use' || echo '✓ Available')"
    echo "3) Enter custom port"
    echo ""
    
    while true; do
        read -p "Choice [1-3]: " choice
        case $choice in
            1)
                if ! check_port_conflict $suggestion1; then
                    save_port_assignment "$var_name" "$suggestion1"
                    export $var_name=$suggestion1
                    return 0
                else
                    echo "❌ Port $suggestion1 is now in use. Please choose another option."
                fi
                ;;
            2)
                if ! check_port_conflict $suggestion2; then
                    save_port_assignment "$var_name" "$suggestion2"
                    export $var_name=$suggestion2
                    return 0
                else
                    echo "❌ Port $suggestion2 is now in use. Please choose another option."
                fi
                ;;
            3)
                while true; do
                    read -p "Enter port number (1024-65535): " custom_port
                    if [[ "$custom_port" =~ ^[0-9]+$ ]] && [ "$custom_port" -ge 1024 ] && [ "$custom_port" -le 65535 ]; then
                        if ! check_port_conflict $custom_port; then
                            save_port_assignment "$var_name" "$custom_port"
                            export $var_name=$custom_port
                            return 0
                        else
                            echo "❌ Port $custom_port is already in use. Please try another port."
                        fi
                    else
                        echo "❌ Invalid port number. Please enter a number between 1024 and 65535."
                    fi
                done
                ;;
            *)
                echo "Invalid choice. Please enter 1, 2, or 3."
                ;;
        esac
    done
}

# Function to resolve port conflicts for a service
resolve_port_conflict() {
    local service_name=$1
    local port_var=$2
    local current_port=${!port_var}
    
    if check_port_conflict $current_port; then
        echo "🔍 Port conflict detected for $service_name (port $current_port)"
        prompt_port_selection "$service_name" "$current_port" "$port_var"
    else
        echo "✓ $service_name port $current_port: Available"
    fi
}

# Function to check all ports and resolve conflicts
check_and_resolve_ports() {
    local env_type=$1  # "dev" or "prod"
    
    echo "🔍 Checking for port conflicts..."
    
    if [ "$env_type" = "dev" ]; then
        resolve_port_conflict "Development Frontend" "DEV_FRONTEND_PORT"
        resolve_port_conflict "Development Backend" "DEV_BACKEND_PORT"
    else
        resolve_port_conflict "Production Frontend" "PROD_FRONTEND_PORT"
        resolve_port_conflict "Production Backend" "PROD_BACKEND_PORT"
    fi
    
    echo ""
}