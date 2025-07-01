FROM python:3.10-slim-bookworm

# Set working directory
WORKDIR /app

# Install system build dependencies (build-essential, gcc, libffi-dev, etc.)
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  build-essential \
  gcc \
  libffi-dev \
  libssl-dev \
  libpq-dev \
  curl && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Copy requirements file first for layer caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip setuptools && \
  pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose FastAPI port
EXPOSE 8000

# Run FastAPI app with Uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
