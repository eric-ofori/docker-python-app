# --- Stage 1: Build dependencies and Python wheels ---
FROM python:3.10-slim AS build

# Set working directory
WORKDIR /app

# Install pip tools
RUN pip install --upgrade pip

# Copy requirement files
COPY requirements.txt .

# Pre-build wheels (optimized for distroless)
RUN pip wheel --wheel-dir /wheels -r requirements.txt

# --- Stage 2: Final image using Distroless ---
FROM gcr.io/distroless/python3-debian12

# Working directory
WORKDIR /app

# Copy app source code
COPY app.py .

# Copy pre-built wheels and install them
COPY --from=build /wheels /wheels
COPY --from=build /app/requirements.txt .

# Install packages (no pip needed in distroless, using Python directly)
ENV PYTHONPATH=/app
RUN python3 -m pip install --no-index --find-links=/wheels -r requirements.txt

# Set FastAPI startup command using Uvicorn
CMD ["-m", "uvicorn", "app:app", "--host", "0.0.0.0", "--port", "80"]
ENTRYPOINT ["python3"]
