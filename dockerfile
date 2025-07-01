# Use updated and secure slim Python base image
FROM python:3.10-slim-bookworm

# Set environment variables for better security and performance
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install system dependencies + apply OS security patches
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install --no-install-recommends -y build-essential gcc libffi-dev && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy Python dependencies
COPY requirements.txt .

# Upgrade pip and setuptools, install dependencies (with CVE fixes)
RUN pip install --upgrade pip setuptools starlette && \
  pip install --no-cache-dir -r requirements.txt

# Copy FastAPI application code
COPY app.py .

# Expose FastAPI port
EXPOSE 8000

# Run FastAPI app using Uvicorn
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
