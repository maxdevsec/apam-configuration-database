FROM mcr.microsoft.com/mssql/server:2017-latest

WORKDIR /opt/scripts

COPY scripts/* /opt/scripts/

RUN chmod 777 *.sh
