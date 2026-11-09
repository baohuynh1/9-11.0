#!/bin/bash
# setup-workspace.sh
# Tao user rieng va khong gian lam viec cho course-service (Rikkei LMS)
# Chay voi quyen sudo: sudo bash setup-workspace.sh

set -e

APP_USER="rikkeilms"
APP_DIR="/opt/rikkei/course-service"

# 1. Tao user rikkeilms (kem home va group cung ten), bo qua neu da ton tai
if id "$APP_USER" &>/dev/null; then
    echo "User $APP_USER da ton tai, bo qua."
else
    useradd -m -s /bin/bash "$APP_USER"
    echo "Da tao user $APP_USER."
fi

# 2. Tao thu muc goc cho ma nguon va cau hinh
mkdir -p "$APP_DIR"

# 3. Chuyen quyen so huu cho user va group rikkeilms
chown -R "$APP_USER":"$APP_USER" "$APP_DIR"

# 4. Phan quyen 755: chi owner duoc ghi (rwx), group va others chi doc + vao thu muc (r-x)
chmod 755 "$APP_DIR"

# 5. Kiem tra ket qua
ls -ld "$APP_DIR"
