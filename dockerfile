FROM python:3.10-slim-bookworm

WORKDIR /app

# Install system packages needed for pip builds
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  gcc \
  g++ \
  libffi-dev \
  libssl-dev \
  build-essential \
  curl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Upgrade pip + wheel first (Important!)
RUN pip install --upgrade pip wheel setuptools

# Copy requirements file
COPY requirements.txt .

# Install python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy your app code
COPY . .

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
