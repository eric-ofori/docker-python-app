# Use an official lightweight Python base image (Debian 12 based)
FROM python:3.10-slim-bookworm

# Set working directory
WORKDIR /app

# Install security updates for Debian system packages
RUN apt-get update && apt-get upgrade -y --no-install-recommends && \
  apt-get install -y --no-install-recommends gcc libffi-dev build-essential && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port
EXPOSE 8000

# Command to run the app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
