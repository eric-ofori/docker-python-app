# -------- Stage 1: Build Stage --------
FROM python:3.10-slim-bookworm AS build

# Update OS packages to reduce CVEs
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
  build-essential \
  gcc \
  libffi-dev \
  libssl-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*


WORKDIR /app


RUN pip install --upgrade pip setuptools wheel


COPY requirements.txt .


RUN pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt

# -------- Stage 2: Production Stage --------
FROM python:3.10-slim-bookworm

RUN apt-get update && apt-get upgrade -y && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app


COPY --from=build /wheels /wheels
RUN pip install --no-cache-dir --no-index --find-links=/wheels /wheels/*


COPY . .


EXPOSE 8000


CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
