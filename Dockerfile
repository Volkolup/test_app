# ---- Builder stage: install dependencies into a virtualenv ----
FROM python:3.10-slim AS builder

WORKDIR /build

ENV PIP_NO_CACHE_DIR=1 \
    PYTHONDONTWRITEBYTECODE=1

# Create an isolated virtualenv we can copy to the runtime stage
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ---- Runtime stage: slim image with only what we need to run ----
FROM python:3.10-slim AS runtime

WORKDIR /app

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PATH="/opt/venv/bin:$PATH"

# Run as a non-root user for better security
RUN useradd --create-home --uid 1000 appuser

# Copy the prepared virtualenv and application code
COPY --from=builder /opt/venv /opt/venv
COPY app ./app

USER appuser

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]