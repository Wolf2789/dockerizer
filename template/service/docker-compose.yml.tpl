version: '3.7'

services:
    {{printf $SERVICE_NAME}}:
        container_name: "${COMPOSE_PROJECT_NAME}"
        image: "{{printf $IMAGE_ORIGINAL}}"
        restart: unless-stopped
