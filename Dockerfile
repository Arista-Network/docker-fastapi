FROM rockylinux:9

ARG UID=1000
ARG GID=1000
ARG ROOT_PASSWORD=root1234   # 원하는 비밀번호로 바꿔도 됨

# 패키지 설치 및 root 비밀번호 설정
RUN dnf -y update && \
    dnf -y install python3 python3-pip python3-devel gcc make shadow-utils && \
    echo "root:${ROOT_PASSWORD}" | chpasswd && \
    dnf clean all

# (선택) 일반 사용자 생성
RUN groupadd -g "${GID}" appgroup && \
    useradd --create-home -u "${UID}" -g "${GID}" appuser

WORKDIR /app

# Python 패키지 설치
COPY requirements.txt .
RUN pip3 install --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt

# 환경 변수
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

COPY . .

# 포트 열기
EXPOSE 8000

# 기본 실행 유저 (root로 실행하게 하려면 아래 줄 제거 또는 주석처리)
# USER appuser:appgroup

# 실행 명령어
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
