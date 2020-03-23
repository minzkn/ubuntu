"/etc/strongswan.conf" 및 "/etc/ipsec.conf"를 적절히 수정하여 설정을 마친 후 사용하세요.

기본적으로 Docker host 환경에서 Transform(xfrm_*.ko) 모듈이 사용가능해야 합니다.

다음의 포트가 개방되어야 합니다.
500/UDP (IKE)
4500/UDP (NAT-T)
