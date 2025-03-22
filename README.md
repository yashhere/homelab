Docker Environment Structure

./docker
├── compose/    # Docker compose files
├── volumes/    # Docker volumes
└── configs/    # Configuration files

Usage:
1. Place your docker-compose.yml files in the compose directory
2. Store persistent data in the volumes directory
3. Keep configuration files in the configs directory

Remember to:
1. Log out and back in to use Docker without sudo
2. Use docker compose from any directory
3. Check docker logs with: docker logs [container_name]
4. Monitor containers with: docker stats


TODO:
1. Backup scripts
2.


Create a new network for Nginx Proxy Manager -
```
docker network create proxy
```
