# ===== Builder stage =====
FROM python:3.11-slim AS builder

RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .

RUN pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r requirements.txt

# ===== Runtime stage =====
FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /usr/local /usr/local

COPY app app
COPY migrations migrations
COPY microblog.py config.py boot.sh ./

RUN chmod +x boot.sh
RUN flask translate compile

ENV FLASK_APP=microblog.py
ENV FLASK_RUN_HOST=0.0.0.0

EXPOSE 5000
ENTRYPOINT ["./boot.sh"]
