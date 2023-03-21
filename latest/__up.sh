#!/bin/sh

g_docker_container_name=mzdev-test

docker-compose up -d ${g_docker_container_name}

echo 'you need follow command:'
echo '$ docker exec -i -t "<container-name>" useradd -c "<comment>" -d "/home/<username>" -g "users" -G "users,adm,sudo,audio,input" -s "/bin/bash" -m "<username>"'
echo '$ docker exec -i -t "<container-name>" sh -c "echo \"<username>:<password>\" | chpasswd"'

# End of __up.sh
