# =========================
# Builder stage
# =========================
FROM python:3.11-slim AS builder

RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .

# تحديث أدوات البناء
RUN pip install --upgrade pip setuptools wheel

# BuildKit cache لتسريع pip
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir -r requirements.txt


# =========================
# Runtime stage
# =========================
FROM python:3.11-slim

# مكتبات التشغيل فقط (بدون أدوات build)
RUN apt-get update && apt-get install -y \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# نسخ مكتبات Python المبنية
COPY --from=builder /usr/local /usr/local

# نسخ كود التطبيق
COPY app app
COPY migrations migrations
COPY microblog.py config.py boot.sh ./

RUN chmod +x boot.sh

ENV FLASK_APP=microblog.py
ENV FLASK_RUN_HOST=0.0.0.0

# يعتمد على كود التطبيق → في مرحلة متأخرة
RUN flask translate compile

EXPOSE 5000
ENTRYPOINT ["./boot.sh"]
