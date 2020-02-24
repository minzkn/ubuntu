
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

2. docker hub (hub.docker.com)에서 다운로드(pull)하여 실행하는 방법

	# docker pull hwport/sigmadesigns:smp86xx
	smp86xx: Pulling from hwport/sigmadesigns
	...
	Status: Downloaded newer image for hwport/sigmadesigns:smp86xx

	# docker images
	REPOSITORY            TAG                 IMAGE ID            CREATED             SIZE
	hwport/sigmadesigns   smp86xx             <image-id>          <created-time>      <image-size>
	...

	# docker run -d -h "<container-hostname>" --name "<container-name>" -p <SSH-host-port>:22 [-v "<local-volume-path>:<container-volume-path>"] "hwport/sigmadesigns:smp86xx"
	...

	# docker container ls --all
	CONTAINER ID        IMAGE                         COMMAND             CREATED             STATUS              PORTS                             NAMES
	<container-id>      hwport/sigmadesigns:smp86xx   "/sbin/init"        <created-time>      <status>            0.0.0.0:<SSH-host-port>->22/tcp   <container-name>
	...

	# docker exec -i -t <container-name> /bin/bash
	root@<container-name>:/# useradd -c "<comment>" -d "/home/<myaccount>" -g users -G users,adm,sudo -m -s /bin/bash <myaccount>
	root@<container-name>:/# passwd <myaccount>
	Enter new UNIX password: <myaccount's password>
	Retype new UNIX password: <myaccount's password>
	passwd: password updated successfully
	root@<container-name>:/# exit

	# ssh -o port=<SSH-host-port> <myaccount>@localhost
	The authenticity of host '[localhost]:<SSH-host-port> ([::1]:<SSH-host-port>)' can't be established.
	ECDSA key fingerprint is SHA256:<...>.
	Are you sure you want to continue connecting (yes/no)? yes
	Warning: Permanently added '[localhost]:<SSH-host-port>' (ECDSA) to the list of known hosts.
	<myaccount>@localhost's password: <myaccount's password>
	<myaccount>@<container-hostname>:~$ <in-container environment now...>

