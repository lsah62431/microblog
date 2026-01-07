FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt requirements.txt

# تحديث أدوات البناء (مهم)
RUN pip install --upgrade pip setuptools wheel

RUN pip install --no-cache-dir -r requirements.txt

COPY app app
COPY migrations migrations
COPY microblog.py config.py boot.sh ./

RUN chmod +x boot.sh

ENV FLASK_APP=microblog.py
ENV FLASK_RUN_HOST=0.0.0.0
RUN flask translate compile

EXPOSE 5000
ENTRYPOINT ["./boot.sh"]

