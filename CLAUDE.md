# CLAUDE.md

이 파일은 본 저장소의 코드 작업 시 Claude Code (claude.ai/code)에 가이드를 제공합니다.

## 프로젝트 개요

이 저장소는 개발 환경이 포함된 다양한 Ubuntu 버전의 Docker 이미지를 관리합니다. 프로젝트는 Docker Buildx를 사용하여 멀티 아키텍처 Docker 이미지(amd64, arm/v7, arm64/v8, ppc64le, riscv64, s390x)를 빌드하고, `hwport/ubuntu` 네임스페이스로 Docker Hub에 게시합니다.

## 저장소 구조

각 디렉토리는 특정 이미지 구성을 나타냅니다:

- **버전별 기본 이미지**: `12.04/`, `14.04/`, `16.04/`, `18.04/`, `20.04/`, `22.04/`, `24.04/`, `latest/`
  - XFCE4 데스크톱, 빌드 도구, SSH, XRDP가 포함된 완전한 개발 환경
  - 포괄적인 툴체인 포함 (gcc, clang, cmake, meson 등)
  - 한국어 지원 및 시간대 설정

- **Apache 웹 서버 이미지**: `www/`, `www-20.04/`, `www-22.04/`, `www-24.04/`, `www-latest/`
  - Ubuntu + Apache2 + PHP-FPM + ModSecurity
  - HTTP/2를 지원하는 SSL/TLS

- **특수 목적 이미지**:
  - `strongswan/`: IPsec VPN 서버
  - `cron/`: Cron 서비스 컨테이너
  - `xrdp/`: 원격 데스크톱 서버
  - `marvell-octeon-sdk-dev/`: Marvell Octeon SDK 개발
  - `smp86xx/`: SMP86xx 개발 환경

- **지원 디렉토리**:
  - `scripts/`: Buildx 설치 및 구성 스크립트
  - `deprecated/`: 아카이브된 구성

## 공통 파일 구조

각 이미지 디렉토리에는 다음이 포함됩니다:

- `Dockerfile`: 이미지 빌드 정의
- `docker-compose.yml`: 로컬 테스트용 컨테이너 구성
- `__buildx.sh`: 멀티 아키텍처 빌드 및 푸시 스크립트
- `__up.sh`: docker-compose를 사용하여 컨테이너 시작
- `__down.sh`: docker-compose를 사용하여 컨테이너 중지
- `entrypoint.sh`: 컨테이너 초기화 스크립트 (기본 이미지용)
- 이미지 유형에 특화된 추가 설정 파일

## 이미지 빌드

### 전제 조건

멀티 아키텍처 빌드를 위한 Docker Buildx 설치 및 구성:

```bash
cd scripts
./__buildx_install.sh
```

이는 docker-container 드라이버를 사용하는 `multiarch` 빌더 인스턴스를 생성합니다.

### 빌드 및 푸시

원하는 이미지 디렉토리로 이동하여 실행:

```bash
cd 24.04
./__buildx.sh
```

모든 지원 플랫폼에 대해 빌드하고 Docker Hub에 푸시합니다. 스크립트는 다음을 사용합니다:
- `docker buildx build --push --platform "linux/amd64,linux/arm/v7,linux/arm64/v8,linux/ppc64le,linux/riscv64,linux/s390x"`

### 로컬 테스트

테스트 컨테이너 시작:

```bash
./__up.sh
```

docker-compose를 사용하여 `mzdev-test`(기본값)라는 이름의 컨테이너를 시작합니다. 시작 후 사용자 생성:

```bash
docker exec -i -t mzdev-test useradd -c "User Name" -d "/home/username" -g "users" -G "users,adm,sudo,audio,input" -s "/bin/bash" -m username
docker exec -i -t mzdev-test sh -c "echo \"username:password\" | chpasswd"
```

컨테이너 중지:

```bash
./__down.sh
```

## 이미지 명명 규칙

이미지는 다음 패턴을 따릅니다: `hwport/ubuntu:<tag>`

태그:
- 버전 번호: `12.04`, `14.04`, `16.04`, `18.04`, `20.04`, `22.04`, `24.04`
- `latest`: 최신 Ubuntu LTS
- `www-<version>`: 특정 Ubuntu 버전의 Apache 웹 서버
- `www-latest`: 최신 Ubuntu의 Apache 웹 서버
- 특수 태그: `strongswan`, `cron`, `xrdp`

## Dockerfile ARG 변수

모든 이미지에서 사용되는 표준 빌드 인수:

- `HWPORT_NAMESPACE`: Docker Hub 네임스페이스 (기본값: `hwport`)
- `HWPORT_IMAGE_NAME`: 기본 이미지 이름 (기본값: `ubuntu`)
- `HWPORT_IMAGE_TAG`: 이 이미지의 특정 태그
- `HWPORT_VERSION`: 이미지 버전
- `DEBIAN_FRONTEND`: apt 작업용으로 `noninteractive`로 설정
- 플랫폼 변수: `BUILDPLATFORM`, `TARGETPLATFORM`, `TARGETARCH` 등

## 개발 환경 기능

기본 개발 이미지 (18.04+)에는 다음이 포함됩니다:

- **데스크톱**: 한국어 폰트 및 입력기(ibus-hangul)가 포함된 XFCE4
- **원격 접속**: SSH (포트 22), XRDP (포트 3389), Shellinabox (포트 4200)
- **빌드 도구**: gcc, g++, clang, cmake, meson, ninja, autotools
- **개발**: git, vim, gdb, strace, ccache, distcc
- **커널 개발**: linux-headers, device-tree-compiler, u-boot-tools
- **멀티미디어**: ffmpeg, vlc, gimp
- **EDA 도구**: kicad (amd64/arm64), librecad, iverilog, gtkwave
- **오피스**: libreoffice (amd64/arm64)
- **안드로이드**: android-studio (amd64 전용)
- **GPU**: NVIDIA CUDA 툴킷 (amd64 전용)

## Entrypoint 서비스

`entrypoint.sh` 스크립트는 환경 변수를 기반으로 서비스를 시작합니다:

- `CLAMAV=yes`: ClamAV 안티바이러스 업데이트 시작
- `XRDP_DESKTOP=yes`: XRDP 원격 데스크톱 서버 시작
- `SHELLINABOX=yes`: 웹 기반 터미널 (Shell In A Box) 시작

이러한 설정은 `docker-compose.yml`에서 구성됩니다.

## 관리자

조재혁 <minzkn@minzkn.com>
Copyright (C) 2024 HWPORT.COM
