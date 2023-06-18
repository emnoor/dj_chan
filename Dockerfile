FROM python:3.11 as builder

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_DEFAULT_TIMEOUT=100 \
    TZ="Asia/Dhaka" \
    VIRTUAL_ENV="/opt/venv"

# setup virtual environment
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# install project dependencies
COPY requirements.txt ./
RUN pip install -r requirements.txt


FROM python:3.11-slim as app
# NOTE: image tag should be the same image as the build stage except for `slim`

WORKDIR /app
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_DEFAULT_TIMEOUT=100 \
    TZ="Asia/Dhaka" \
    VIRTUAL_ENV="/opt/venv"
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# copy virtual environment from build stage
COPY --from=builder $VIRTUAL_ENV $VIRTUAL_ENV

# copy project files
COPY . .
