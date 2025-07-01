# Stage 1 - Build dependencies

FROM python:3.10-slim AS builder



WORKDIR /app

# Install system build tools
RUN apt-get update && apt-get install -y build-essential gcc

# Install Python dependencies
COPY requirements.txt .
RUN pip wheel --wheel-dir=/app/wheels -r requirements.txt


# Stage 2 - Final runtime image (Distroless)
FROM gcr.io/distroless/python3-debian12


WORKDIR /app

# Copy app code
COPY app.py .

# Copy built Python packages (wheels) and requirements
COPY requirements.txt .
COPY --from=builder /app/wheels /wheels

# Install Python dependencies from built wheels (NO pip install over network inside distroless)
RUN python3 -m pip install --no-index --find-links=/wheels -r requirements.txt


EXPOSE 8000


CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
