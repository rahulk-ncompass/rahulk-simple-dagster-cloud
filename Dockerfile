FROM python:3.12-slim

WORKDIR /opt/dagster/app

ENV DAGSTER_HOME=/opt/dagster/dagster_home

RUN mkdir -p ${DAGSTER_HOME}

RUN pip install --no-cache-dir \
    dagster \
    dagster-webserver \
    dagster-mysql

COPY dagster.yaml ${DAGSTER_HOME}/dagster.yaml
COPY . /opt/dagster/app

CMD ["dagster", "api", "grpc", "-h", "0.0.0.0", "-p", "4000", "-m", "simple_dagster.definitions"]