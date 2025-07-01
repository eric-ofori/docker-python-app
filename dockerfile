FROM python:3.10-slim-bookworm

# Set working directory
WORKDIR /app

# Install system build tools and dependencies needed for uvicorn / fastapi
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  gcc \
  libffi-dev \
  libssl-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Upgrade pip, setuptools, and wheel first (critical for Python builds)
RUN pip install --upgrade pip setuptools wheel

# Copy requirements.txt into the image
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your application code
COPY . .

# Expose port 8000
EXPOSE 8000

# Start the FastAPI app with uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
