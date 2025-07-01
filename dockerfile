# -------- Stage 1: Build Stage --------
FROM python:3.10-slim-bookworm AS build

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  gcc \
  libffi-dev \
  libssl-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Set work directory
WORKDIR /app

# Upgrade pip, setuptools, wheel
RUN pip install --upgrade pip setuptools wheel

# Copy requirements first (leverage Docker layer caching)
COPY requirements.txt .

# Install Python dependencies (build wheels here)
RUN pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt

# -------- Stage 2: Production Stage --------
FROM python:3.10-slim-bookworm

WORKDIR /app

# Install runtime dependencies only
COPY --from=build /wheels /wheels
RUN pip install --no-cache-dir --no-index --find-links=/wheels /wheels/*

# Copy the actual app code
COPY . .

# Expose the app port
EXPOSE 8000

# Run FastAPI app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
