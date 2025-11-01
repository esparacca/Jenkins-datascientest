FROM python:3.9

# NEW: prevent .pyc creation and unbuffer logs
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /code

# copy dependencies and install
COPY ./requirements.txt /code/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

# copy the app
COPY ./app /code/app

# NEW: remove any existing __pycache__ directories just in case
RUN find /code -name "__pycache__" -type d -exec rm -rf {} + || true

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]
