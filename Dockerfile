FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app
COPY server.py index.html styles.css app.js ./
COPY prompts ./prompts
COPY templates ./templates

EXPOSE 10000
CMD ["python", "server.py"]
