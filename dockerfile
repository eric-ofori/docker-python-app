FROM python:3.10-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Patch system CVEs and install build tools (optional for Python packages with C extensions)
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install --no-install-recommends -y build-essential gcc libffi-dev && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# Update pip, setuptools and starlette to latest secure versions
RUN pip install --upgrade pip setuptools==78.1.1 starlette==0.40.0

# Install app dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 8000

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
