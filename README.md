# Ubuntu Docker 이미지

포괄적인 개발 환경이 포함된 멀티 아키텍처 Ubuntu Docker 이미지입니다.

## 개요

이 저장소는 개발에 최적화된 프로덕션 준비 Ubuntu Docker 이미지를 제공하며, 다음 기능을 포함합니다:

- **멀티 아키텍처 지원**: amd64, arm/v7, arm64/v8, ppc64le, riscv64, s390x
- **다양한 Ubuntu 버전**: 12.04부터 24.04 LTS까지
- **완전한 개발 툴체인**: gcc, clang, cmake, Python 등
- **GUI 데스크톱 환경**: XRDP를 통한 원격 접속 지원 XFCE4
- **한국어 지원**: 폰트 및 입력기 포함
- **특화 변형**: 웹 서버, VPN, 레거시 SDK 지원

## 빠른 시작

### Pull 및 실행

```bash
# 최신 Ubuntu 개발 환경
docker pull hwport/ubuntu:latest
docker run -d -p 2222:22 -p 3389:3389 hwport/ubuntu:latest

# 데스크톱이 포함된 Ubuntu 24.04
docker pull hwport/ubuntu:24.04
docker run -d -p 2222:22 -p 3389:3389 \
  -e XRDP_DESKTOP=yes \
  hwport/ubuntu:24.04

# Apache 웹 서버
docker pull hwport/ubuntu:www-latest
docker run -d -p 80:80 -p 443:443 hwport/ubuntu:www-latest
```

### 사용자 계정 생성

컨테이너 시작 후:

```bash
# 사용자 생성
docker exec -i -t <container-name> \
  useradd -c "Developer" -d "/home/dev" \
  -g "users" -G "users,adm,sudo,audio,input" \
  -s "/bin/bash" -m dev

# 비밀번호 설정
docker exec -i -t <container-name> \
  sh -c "echo \"dev:password\" | chpasswd"
```

### 데스크톱 연결

- **SSH**: `ssh -p 2222 dev@localhost`
- **XRDP**: 모든 RDP 클라이언트로 `localhost:3389`에 연결
- **웹 터미널**: `http://localhost:4200`로 이동 (SHELLINABOX=yes인 경우)

## 사용 가능한 이미지

### 기본 개발 이미지

| 태그 | 설명 | 아키텍처 |
|-----|-------------|--------------|
| `latest` | 최신 Ubuntu LTS | Multi-arch |
| `24.04` | Ubuntu 24.04 Noble | Multi-arch |
| `22.04` | Ubuntu 22.04 Jammy | Multi-arch |
| `20.04` | Ubuntu 20.04 Focal | Multi-arch |
| `18.04` | Ubuntu 18.04 Bionic | Multi-arch |
| `16.04` | Ubuntu 16.04 Xenial | Multi-arch |
| `14.04` | Ubuntu 14.04 Trusty | Multi-arch |
| `12.04` | Ubuntu 12.04 Precise | Multi-arch |

### 웹 서버 이미지

| 태그 | 설명 |
|-----|-------------|
| `www-latest` | Apache + PHP-FPM (최신) |
| `www-24.04` | Apache + PHP-FPM (24.04) |
| `www-22.04` | Apache + PHP-FPM (22.04) |
| `www-20.04` | Apache + PHP-FPM (20.04) |

### 특수 목적 이미지

| 태그 | 설명 |
|-----|-------------|
| `strongswan` | IPsec VPN 서버 (strongSwan) |
| `cron` | Cron 서비스 컨테이너 |
| `xrdp` | 원격 데스크톱 서버 |

## 기능

### 개발 도구

- **컴파일러**: gcc, g++, clang/LLVM
- **빌드 시스템**: make, cmake, meson, ninja, autotools
- **버전 관리**: git, svn, cvs
- **디버거**: gdb, strace
- **빌드 가속**: ccache, distcc
- **패키지 관리자**: apt, pip

### 커널 및 임베디드 개발

- Linux 커널 헤더
- 디바이스 트리 컴파일러
- U-Boot 도구
- 크로스 컴파일 지원
- Verilog 도구 (iverilog, gtkwave)

### 데스크톱 환경 (18.04+)

- **WM**: 플러그인이 포함된 XFCE4
- **원격 접속**: XRDP, SSH, Shellinabox
- **애플리케이션**: Firefox, LibreOffice, GIMP, VLC
- **EDA**: KiCad, LibreCAD
- **한국어 지원**: 나눔 폰트, ibus-hangul

### 플랫폼별 기능

- **amd64**: NVIDIA CUDA 툴킷, Android Studio
- **amd64/arm64**: KiCad, LibreOffice, Firefox
- **모든 플랫폼**: 표준 개발 도구

## 환경 변수

환경 변수로 컨테이너 동작 구성:

```bash
docker run -d \
  -e TZ=Asia/Seoul \
  -e LANG=ko_KR.UTF-8 \
  -e XRDP_DESKTOP=yes \
  -e SHELLINABOX=yes \
  -e CLAMAV=yes \
  hwport/ubuntu:24.04
```

- `TZ`: 시간대 (기본값: Asia/Seoul)
- `LANG`: 시스템 언어 (기본값: en_US.UTF-8)
- `XRDP_DESKTOP`: XRDP 서비스 활성화 (yes/no)
- `SHELLINABOX`: 웹 터미널 활성화 (yes/no)
- `CLAMAV`: 안티바이러스 업데이트 활성화 (yes/no)

## 포트

### 기본 개발 이미지

- `22/tcp`: SSH 서버
- `3389/tcp`: XRDP 원격 데스크톱
- `4200/tcp`: Shellinabox 웹 터미널

### 웹 서버 이미지

- `80/tcp`: HTTP
- `443/tcp`: HTTPS

### VPN 이미지

- `500/udp`: IKE
- `4500/udp`: NAT-T

## 소스에서 빌드

### 전제 조건

```bash
# Docker Buildx 설치
cd scripts
./buildx_install.sh
```

### 이미지 빌드

```bash
# 이미지 디렉토리로 이동
cd 24.04

# 빌드 및 레지스트리에 푸시
./buildx.sh

# 또는 로컬 사용 전용 빌드
docker buildx build --platform linux/amd64 -t ubuntu:24.04-local .
```

### 로컬 테스트

```bash
# 테스트 컨테이너 시작
./up.sh

# 로그 보기
docker logs mzdev-test

# 컨테이너 중지
./down.sh
```

## 사용 사례

### 소프트웨어 개발

GUI 도구가 포함된 완전한 개발 환경, 다음에 적합:
- 크로스 플랫폼 개발
- 임베디드 시스템 프로그래밍
- 커널 모듈 개발
- CI/CD 빌드 환경

### 웹 호스팅

PHP-FPM이 포함된 Apache 웹 서버 이미지, 다음에 적합:
- PHP 애플리케이션 호스팅
- 개발/스테이징 환경
- SSL/TLS가 활성화된 웹사이트

### 원격 근무

XRDP가 활성화된 데스크톱, 다음에 적합:
- 원격 개발
- GUI 액세스가 가능한 헤드리스 서버
- 가상 워크스테이션

### VPN 게이트웨이

StrongSwan IPsec 서버, 다음에 적합:
- 사이트 간 VPN
- 원격 액세스 VPN
- 보안 터널링

## Docker Compose 예제

```yaml
version: "2.1"
services:
  dev:
    image: hwport/ubuntu:24.04
    container_name: my-dev-env
    hostname: devbox
    privileged: true
    environment:
      - TZ=Asia/Seoul
      - LANG=en_US.UTF-8
      - XRDP_DESKTOP=yes
    ports:
      - "2222:22"
      - "3389:3389"
    restart: unless-stopped
```

## 보안 고려사항

- 기본 비밀번호를 즉시 변경하세요
- 가능한 경우 비밀번호 대신 SSH 키를 사용하세요
- 최신 보안 패치로 이미지를 업데이트하세요
- 최소 필요 권한으로 컨테이너를 실행하세요
- 필요한 포트만 호스트에 바인딩하세요

## 라이선스

Copyright (C) 2024 HWPORT.COM
All rights reserved.

## 관리자

**조재혁 (JaeHyuk Cho)**
이메일: minzkn@minzkn.com
웹: https://www.minzkn.com/

## 기여

이슈 및 풀 리퀘스트를 환영합니다. 주요 변경사항의 경우, 먼저 이슈를 열어 제안 사항을 논의해 주세요.

## 지원

이슈, 질문 또는 제안 사항:
- 저장소에 이슈 열기
- 관리자에게 직접 연락

---

**참고**: 이 이미지들은 개발 및 테스트에 최적화되어 있습니다. 프로덕션 배포의 경우, 보안 요구사항에 따라 구성을 검토하고 맞춤 설정하세요.
