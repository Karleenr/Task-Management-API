FROM python:3.11 AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev

COPY requirements.txt .

RUN pip install -r requirements.txt



FROM python:3.11

RUN apt-get update && apt-get install -y \
    libpq-dev \
    curl

RUN addgroup --system appgroup && \
    adduser --system --no-create-home --ingroup appgroup appuser
    
WORKDIR /app

COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin


COPY app/ ./app/

USER appuser

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]    