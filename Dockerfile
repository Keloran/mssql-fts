FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install -y \
        curl \
        apt-transport-https \
        sudo \
        apt-utils

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server.list | tee /etc/apt/sources.list.d/mssql-server.list

RUN apt-get update \
    && apt-get install -y \
        mssql-server-fts

EXPOSE 1433

ENV XDG_RUNTIME_DIR=/run/systemd/container

ENV SA_PASSWORD=Pa55word
ENV MSSQL_PID=developer

RUN echo "" > /opt/mssql/lib/mssql-conf/startservice.sh
RUN echo '#!/usr/bin/env bash' > /opt/mssql/lib/mssql-conf/checkrunninginstance.sh
RUN /opt/mssql/lib/mssql-conf/checkinstall.sh
RUN echo "[EULA]" > /var/opt/mssql/mssql.conf
RUN echo "accepteula = Y" >> /var/opt/mssql/mssql.conf

CMD /opt/mssql/lib/mssql-conf/invokesqlservr.sh
