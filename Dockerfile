# Base: Rocky Linux 9
FROM rockylinux:9

# ARG 설정
ARG UID=1000
ARG GID=1000

# 필요한 패키지 설치 (Python, pip 등)
RUN dnf -y update && \
    dnf -y install python3 python3-pip python3-devel gcc make shadow-utils && \
    dnf clean all

# 유저 및 그룹 생성
RUN groupadd -g "${GID}" appgroup && \
    useradd --create-home -u "${UID}" -g "${GID}" appuser

# 작업 디렉토리 설정
WORKDIR /app

# pip 업그레이드
RUN pip3 install --upgrade pip

# 의존성 설치
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# 권한 설정 및 실행 유저 지정
USER appuser:appgroup

# 환경 변수
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 앱 복사
COPY . .

# 포트 오픈
EXPOSE 8000

# 실행 명령
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]