#!/bin/bash

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICES_DIR="$REPO_DIR/services"

echo "ðŸSyncing service configurations..."

SERVICES=("infra" "termix" "vaultwarden" "syncthing" "adguard")

for service in "${SERVICES[@]}"; do
    SRC_FILE="$HOME/$service/docker-compose.yml"
    
    if [ -f "$SRC_FILE" ]; then
        mkdir -p "$SERVICES_DIR/$service"
        cp "$SRC_FILE" "$SERVICES_DIR/$service/docker-compose.yml"
        echo "âCopied: ~/$service/docker-compose.yml -> services/$service/docker-compose.yml"
    else
        echo "âšFile not found: ~/$service/docker-compose.yml"
    fi
done

echo "ðŸSync completed."
