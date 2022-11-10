
1. Docker가 구동 가능한 기호에 맞는 배포판을 VM(VirtualBox, VMware, Hypwe-V 등의 Virtual Machine 구동환경)에 설치하거나 Native로 설치합니다.
  - Docker가 구동되려면 최소한 Linux Kernel 3.8.13 or 3.10 이상의 버젼을 지원하는 배포판을 설치하시기 바랍니다.
  - 설치된 Docker 구동 환경이 Ubuntu Linux 환경인 경우 다음과 같이 쉘에서 입력하여 docker를 설치할 수 있습니다.
    # sudo apt-get install docker.io
  - (선택사항) docker를 실행하는데 매번 root 권한이 필요하기 때문에 "docker" group 에 사용자를 등록해두면 sudo 실행이나 root로그인 없이 관리하기 편합니다.

2. Docker build script인 "build-docker-image.sh"을 실행하여 Docker image를 빌드합니다.
  # sudo ./build-docker-image.sh

3. 이제 build된 Docker image는 다음과 같은 명령으로 확인할 수 있습니다.
  # sudo docker images
  REPOSITORY            TAG                 IMAGE ID            CREATED             SIZE
  hwport/ubuntu         moniwiki            d710f856b09b        4 minutes ago       255MB
  ubuntu                18.04               72300a873c2c        3 weeks ago         64.2MB

4. Docker 를 사용하기 위해서는 run 또는 create + start 단계를 통해서 Container로 실행해줘야 합니다.
  # docker run -d -p 80:80 --name mywww hwport/ubuntu:moniwiki
    ("mywww"라는 Container 로 image를 실행하는 명령입니다.)
  # docker container ls -a
    (container 가 실행되었는지 확인)

  그 밖에 주요 명령
    - container 정지 명령
      # docker stop mywww
    - container 시작 명령
      # docker start mywww
    - container 삭제 명령 (container 가 시작 상태가 아니어야 함)
      # docker rm mywww

5. 직접 docker exec로 로그인을 통해서 실행하는 방법
  # docker exec -i -t mywww /bin/bash
    (계정을 추가하거나 그 밖에 자신만의 환경을 구성하십시요.)

6. 이제 Docker 세상에 접근하였습니다. 뭐든 만들어 보십시요. 

