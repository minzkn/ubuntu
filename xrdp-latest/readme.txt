
xrdp + xfce 환경입니다.

구동시 privileged 권한 또는 SYS_ADMIN + seccomp:unconfined 권한이 필요하며 "/run" 및 "/run/lock" 이 tmsfs 으로 mount되어 있거나 mount할 수 있는 권한이 필요합니다.

3389/tcp, 3389/udp 포트의 개방이 필요합니다.

자신이 사용할 계정을 추가해야 합니다.
<pre>
# docker exec -i -t <container-name> /bin/bash
root@<container-hostname>:/# useradd -c "<comment>" -d "/home/<myaccount>" -g users -G users,adm,sudo -m -s /bin/bash <myaccount>
root@<container-hostname>:/# passwd <myaccount>
Enter new UNIX password: <myaccount's password>
Retype new UNIX password: <myaccount's password>
passwd: password updated successfully
root@<container-hostname>:/# exit
</pre>

구동 후에 원격 데스크탑 (rdp) 프로그램을 통하여 접속할 수 있습니다.

