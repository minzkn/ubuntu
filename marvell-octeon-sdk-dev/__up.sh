#!/bin/sh

g_docker_container_name=marvell-octeon-sdk-dev

docker-compose up -d ${g_docker_container_name}

echo 'you need follow command:'
echo '$ docker exec -i -t "<container-name>" useradd -c "<comment>" -d "/home/<username>" -g "users" -G "users,adm,sudo" -s "/bin/bash" -m "<username>"'
echo '$ docker exec -i -t "<container-name>" sh -c "echo \"<username>:<password>\" | chpasswd"'
echo '$ docker exec -i -t "<container-name>" sh -c "echo \"<username>    ALL=(ALL:ALL) NOPASSWD:ALL\" > /etc/sudoers.d/<username>"'

# End of __up.sh
