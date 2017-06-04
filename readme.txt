
Docker 환경 구축 방법

0. Docker를 처음 접하시는 분들은 먼저 하기 링크의 Docker 관련 문건을 읽어보실것을 추천드립니다.
  - 이재홍님의 Docker 원고 (강력 추천)
    http://pyrasis.com/docker.html

  - Docker 의 Network 구조에 대한 이해를 위한 내용 (필수 이해 필요)
    http://bluese05.tistory.com/15                (docker0와 container network 구조)
    http://bluese05.tistory.com/38                (container network 방식 4가지)
    http://bluese05.tistory.com/53                (container 외부 통신 구조)
    http://bluese05.tistory.com/54                (container link 구조)

  - Docker image를 빌드하기 위한 Dockerfile 작성예
    https://hub.docker.com/r/fgrehm/vagrant-ubuntu/~/dockerfile/
    http://label-schema.org/rc1/                  (Dockerfile에서 LABEL정의)
    https://hub.docker.com/_/ubuntu-upstart/      (Docker를 구동하기 가장 좋은 ubuntu-upstart image project)

1. Docker가 구동 가능한 기호에 맞는 배포판을 VM(VirtualBox, VMware, Hypwe-V 등의 Virtual Machine 구동환경)에 설치하거나 Native로 설치합니다.
  - Docker가 구동되려면 최소한 Linux Kernel 3.8.13 or 3.10 이상의 버젼을 지원하는 배포판을 설치하시기 바랍니다.
  - 설치된 Docker 구동 환경이 Ubuntu Linux 환경인 경우 다음과 같이 쉘에서 입력하여 docker를 설치할 수 있습니다.
    # sudo apt-get install docker.io
  - (선택사항) docker를 실행하는데 매번 root 권한이 필요하기 때문에 "docker" group 에 사용자를 등록해두면 sudo 실행이나 root로그인 없이 관리하기 편합니다.

2. Docker build script인 "build-docker-image.sh"을 실행하여 Docker image를 빌드합니다.
  # sudo ./build-docker-image.sh

3. 이제 build된 Docker image는 다음과 같은 명령으로 확인할 수 있습니다.
  # sudo docker images
  REPOSITORY                TAG                 IMAGE ID            CREATED             SIZE
  hwport-ubuntu-12.04-dev   latest              43789521063b        23 seconds ago      445.8 MB
  ubuntu                    12.04               5b117edd0b76        8 days ago          103.6 MB

4. Docker 를 사용하기 위해서는 run 또는 create + start 단계를 통해서 Container로 실행해줘야 합니다.
  # sudo docker run -d -p 2222:22 --name mydev hwport-ubuntu-12.04-dev            ("mydev"라는 Container 로 image를 실행하는 명령입니다.)

5. 이제 실행된 Container로 접속하려면 크게 3가지 명령이 가능합니다.
  - Container의 SSH로 접속하는 방법 (dev 계정의 초기 암호는 "duftlagl"이며 root계정의 암호는 "docker.io"입니다.)
    # ssh dev@localhost -p 2222

  - 직접 docker exec로 쉘을 실행하여 접근하는 방법 (환경변수등이 일반 로그인과 다를 수 있으며 root계정으로 접근하기 때문에 임시조치등을 위해서만 사용하는게 좋습니다.) 
    # sudo docker exec -i -t mydev /bin/bash

  - 직접 docker exec로 로그인을 통해서 실행하는 방법
    # sudo docker exec -i -t mydev /bin/login

6. 이제 Docker 세상에 접근하였습니다. 뭐든 만들어 보십시요. 
