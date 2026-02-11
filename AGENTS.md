# AGENTS.md

Ubuntu Docker 이미지 저장소를 위한 AI 에이전트 지침서

## 목적

이 파일은 본 저장소에서 작업하는 AI 에이전트(Claude Code, GitHub Copilot, Cursor 등)를 위한 특화된 가이드를 제공합니다. CLAUDE.md를 보완하는 워크플로우별 지침과 자동화 가이드라인을 담고 있습니다.

## 코드 수정 원칙

### Dockerfile 수정 시

1. **멀티 아키텍처 호환성 유지**
   - 변경사항이 지원되는 모든 플랫폼을 손상시키지 않는지 테스트: amd64, arm/v7, arm64/v8, ppc64le, riscv64, s390x
   - 조건부 패키지 설치 사용: `$(if [ "${TARGETARCH}" = "..." ]; then echo "package"; fi)`
   - ARG 변수가 올바르게 사용되는지 확인: TARGETARCH, TARGETPLATFORM, BUILDARCH 등

2. **레이어 최적화 유지**
   - 관련된 RUN 명령을 결합하여 레이어 수 줄이기
   - 동일 레이어에서 apt 캐시 정리: `apt-get clean && rm -rf /var/lib/apt/lists/*`
   - 변경 빈도가 낮은 것부터 높은 순서로 명령 배치

3. **기존 패턴 준수**
   - 다른 Dockerfile과 동일한 저작권 헤더 사용
   - 일관된 ARG 변수 명명 유지 (HWPORT_*)
   - 모든 이미지에서 LABEL 구조 일관성 유지

### 셸 스크립트 수정 시

1. **스크립트 명명 규칙**
   - `__`(이중 언더스코어)로 시작하는 스크립트는 내부 유틸리티
   - 실행 권한 유지: `chmod +x`
   - POSIX 호환성이 필요하면 `#!/bin/sh`, bash 전용 기능이 필요하면 `#!/bin/bash` 사용

2. **오류 처리**
   - 안전한 스크립트 실행을 위해 `set -eo pipefail` 사용
   - 의미 있는 오류 메시지 제공
   - 종료 시 임시 파일 정리

### docker-compose.yml 수정 시

1. **일관된 컨테이너 명명**
   - 기본 컨테이너 이름: `mzdev-test`
   - 셸 스크립트를 통한 오버라이드 허용

2. **포트 매핑 표준**
   - SSH: 2222:22
   - XRDP: 3389:3389
   - Shellinabox: 4200:4200
   - HTTP: 80:80 (웹 서버)
   - HTTPS: 443:443 (웹 서버)

3. **Privileged 모드 고려사항**
   - 기본 이미지는 완전한 개발 기능을 위해 일반적으로 `privileged: true` 필요
   - 가능한 경우 privileged 모드 대신 특정 capability 사용
   - privileged 모드가 필요한 이유 문서화

## 빌드 워크플로우

### 빌드 전 체크리스트

`__buildx.sh` 실행 전:

1. Dockerfile 문법 검증
2. 플랫폼별 패키지 가용성 확인
3. 단일 아키텍처로 먼저 로컬 테스트: `docker buildx build --platform linux/amd64 -t test .`
4. Buildx 구성 확인: `docker buildx ls` 명령으로 `multiarch` 빌더 확인

### 빌드 프로세스

```bash
# 표준 워크플로우
cd <이미지-디렉토리>
./buildx.sh  # 모든 아키텍처 빌드 및 푸시
```

### 테스트 워크플로우

```bash
# 로컬 테스트 워크플로우
cd <이미지-디렉토리>
./up.sh           # 컨테이너 시작
docker ps         # 실행 중 확인
docker logs <container>  # 오류 확인
# 기능 테스트
./down.sh         # 컨테이너 중지
```

## 버전 관리

### 새 버전 디렉토리 생성

새로운 Ubuntu 버전 지원 추가 시:

1. **최신 버전에서 복사**
   ```bash
   cp -r 24.04 26.04
   cd 26.04
   ```

2. **파일 업데이트**
   - Dockerfile: `FROM ubuntu:24.04`를 `FROM ubuntu:26.04`로 변경
   - Dockerfile: `HWPORT_IMAGE_TAG` ARG 업데이트
   - `__buildx.sh`: 새 버전과 일치하도록 태그 업데이트
   - `docker-compose.yml`: 이미지 태그 업데이트
   - 새 Ubuntu 버전의 패키지 가용성 테스트

3. **아키텍처 지원 확인**
   - 모든 아키텍처에서 모든 패키지를 사용할 수 있는지 확인
   - 멀티 아키텍처 빌드 전 최소 하나의 아키텍처에서 빌드 테스트

### 구 버전 폐기

버전 폐기 시:

1. 디렉토리를 `deprecated/`로 이동
2. 지원 버전 목록에서 제거하도록 README.md 업데이트
3. 레거시 사용자를 위한 참조용으로 Dockerfile 보관

## 이미지 변형

### 기본 개발 이미지 (예: 24.04/)

**주요 목적**: GUI가 포함된 완전한 개발 환경

**반드시 포함해야 할 것**:
- 완전한 빌드 툴체인 (gcc, clang, cmake 등)
- XFCE4 데스크톱 환경
- 원격 접속을 위한 XRDP
- SSH 서버
- 한국어 지원 (폰트, ibus-hangul)
- 일반적인 개발 도구

**진입점**: `/entrypoint.sh` → 서비스 시작 → CMD 실행

### 웹 서버 이미지 (예: www-24.04/)

**주요 목적**: Apache + PHP 웹 서버

**반드시 포함해야 할 것**:
- 일반 모듈이 포함된 Apache2 (ssl, rewrite, proxy 등)
- 일반 확장이 포함된 PHP-FPM
- ModSecurity
- SSL 인증서 지원
- 적절한 Apache 설정 파일

**진입점**: Apache foreground 모드 직접 실행

### 특수 목적 이미지

**최소화 접근 방식 준수**:
- 특정 목적에 필요한 패키지만 포함
- 이미지 크기는 작을수록 좋음
- 목적에 대한 명확한 문서화

## 일반 작업

### 새 패키지 추가

모든 기본 이미지에:

1. 최신 버전의 Dockerfile 편집 (예: 24.04)
2. 적절한 RUN 명령에 패키지 추가
3. 로컬에서 빌드 테스트
4. 호환 가능하면 다른 버전으로 백포트
5. 중요한 경우 README.md 기능 목록 업데이트

특정 이미지에:

1. 해당 Dockerfile만 편집
2. 커밋 메시지에 패키지가 필요한 이유 문서화
3. 주요 기능인 경우 README.md 업데이트

### 기본 Ubuntu 이미지 업데이트

Ubuntu가 보안 업데이트를 릴리스할 때:

1. 이미지 재빌드 (기본 FROM ubuntu:XX.XX는 최신을 가져옴)
2. 변경사항으로 인한 문제 테스트
3. 중요한 변경사항이 있으면 HWPORT_VERSION 업데이트
4. 새 빌드 푸시

### entrypoint.sh 수정

**중요 파일** - 변경사항이 컨테이너 시작에 영향:

1. 로컬 컨테이너에서 변경사항 철저히 테스트
2. 새 로직으로 모든 서비스 검사가 작동하는지 확인
3. 환경 변수가 올바르게 처리되는지 확인
4. 새 환경 변수가 추가되면 CLAUDE.md 업데이트

## 아키텍처별 처리

### 플랫폼별 패키지

Dockerfile에서 조건부 설치 사용:

```dockerfile
RUN apt-get install -y \
  common-package \
  $(if [ "${TARGETARCH}" = "amd64" ]; then echo "amd64-only-package"; fi) \
  $(if [ "${TARGETARCH}" = "amd64" -o "${TARGETARCH}" = "arm64" ]; then echo "amd64-arm64-package"; fi) \
  $(if [ "${TARGETARCH}" != "riscv64" ]; then echo "all-except-riscv64"; fi)
```

### 알려진 플랫폼 제한사항

- **riscv64**: 일부 패키지 사용 불가 (mesa-drm-shim)
- **amd64 전용**: NVIDIA CUDA, Android Studio
- **amd64/arm64**: 무거운 GUI 앱 (Firefox, LibreOffice, KiCad)
- **arm/v7**: 메모리 제약, 가벼운 패키지 선호

## 문제 해결 가이드

### 빌드 실패

1. **패키지를 찾을 수 없음**: 모든 대상 아키텍처에서 사용 가능한지 확인
2. **타임아웃**: 일부 아키텍처(riscv64)는 에뮬레이트되어 느림
3. **공간 부족**: Buildx 캐시 정리: `docker buildx prune`

### 컨테이너 시작 안 됨

1. 로그 확인: `docker logs <container-name>`
2. entrypoint.sh가 실행 가능한지 확인
3. entrypoint.sh의 문법 오류 확인
4. 필요한 서비스가 설치되었는지 확인

### 서비스 시작 안 됨

1. 환경 변수가 올바르게 설정되었는지 확인
2. 서비스가 설치되었는지 확인: `docker exec <container> which <service>`
3. 서비스 설정 파일 확인
4. entrypoint.sh 서비스 시작 로직 검토

## Git 워크플로우

### 커밋 메시지

명확하고 설명적인 커밋 메시지 사용:

```
24.04에 amd64용 CUDA 지원 추가

- nvidia-cuda-toolkit 설치
- NVIDIA 런타임 라이브러리 추가
- 문서 업데이트
```

### 커밋 전

1. 로컬에서 빌드 테스트
2. 커밋에 민감한 정보가 없는지 확인
3. 필요시 문서 업데이트
4. 스크립트가 실행 가능한지 확인

## 자동화 기회

### CI/CD 통합

자동화 고려사항:
- PR 시 빌드 테스트
- Trivy 또는 Clair를 이용한 보안 스캔
- Ubuntu 기본 이미지 업데이트 시 자동 빌드
- 멀티 아키텍처 빌드 상태 알림

### 헬스 체크

추가 고려사항:
- 서비스 상태를 위한 Dockerfile의 HEALTHCHECK
- 주요 서비스(SSH, XRDP) 자동 테스트
- 버전 확인 스크립트

## 모범 사례

1. **푸시 전 테스트**: 레지스트리에 푸시하기 전에 항상 로컬에서 빌드 테스트
2. **변경사항 문서화**: 기능 변경 시 관련 .md 파일 업데이트
3. **일관성 유지**: 새로운 추가 사항에 기존 패턴 준수
4. **보안 우선**: 비밀 정보 커밋 금지, 안전한 기본값 사용
5. **빌드 최적화**: 빌드 캐시 효과적 사용, 레이어 순서 적절히 배치
6. **모든 아키텍처 지원**: 타당한 이유 없이 멀티 아키텍처 지원을 손상시키지 말 것

## AI 에이전트 특정 참고사항

- "패키지 업데이트" 요청 시, 모든 버전에 적용할지 최신 버전에만 적용할지 고려
- 기능 추가 시, 웹 서버 변형도 유사한 업데이트가 필요한지 확인
- 새 파일 생성보다 기존 파일 편집 선호
- 새 빌드 스크립트 생성 전 scripts/ 디렉토리 확인
- 프로젝트 아키텍처 이해를 위해 CLAUDE.md 참조
- 사용자 대상 기능 및 문서를 위해 README.md 참조

## 리소스

- Docker Buildx 문서: https://docs.docker.com/buildx/
- Ubuntu 기본 이미지: https://hub.docker.com/_/ubuntu
- 멀티 아키텍처 모범 사례: https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/

---

**AI 에이전트 참고**: 이 파일은 워크플로우 및 자동화 가이드를 담고 있습니다. 아키텍처 이해를 위해서는 CLAUDE.md를, 사용자 대상 문서를 위해서는 README.md를 참조하세요.
