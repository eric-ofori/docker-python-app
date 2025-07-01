# Stage 1: Build with Python
FROM python:3.10-slim AS builder



WORKDIR /app

# System build tools (for packages like uvicorn)
RUN apt-get update && apt-get install -y build-essential gcc

# Install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --prefix=/install -r requirements.txt

# Copy app code
COPY app.py .

# Stage 2: Final Distroless Image
FROM gcr.io/distroless/python3-debian12

WORKDIR /app

# Copy Python site packages and app
COPY --from=builder /install /usr/local
COPY --from=builder /app .

EXPOSE 8000


CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
