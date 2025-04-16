FROM rockylinux:9

ARG ROOT_PASSWORD=root1234

RUN dnf -y update && \
    dnf -y install python3 python3-pip python3-devel gcc make shadow-utils && \
    echo "root:${ROOT_PASSWORD}" | chpasswd && \
    dnf clean all

WORKDIR /app

COPY requirements.txt .
RUN pip3 install --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

COPY . .

EXPOSE 8000

# 기본 실행: root 유저 그대로
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
