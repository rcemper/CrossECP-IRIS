ARG IMAGE=intersystemsdc/iris-community:latest
ARG IMAGE=containers.intersystems.com/intersystems/iris:2022.1.0.209.0
FROM $IMAGE
USER root   

RUN echo "root:iris-1205" | chpasswd

COPY  iris.cpf /usr/irissys/
COPY  iris.key /usr/irissys/mgr/
COPY  messages.log /usr/irissys/mgr/

WORKDIR /opt/irisapp

RUN chmod 666 /usr/irissys/iris.cpf \
 && chmod 666 /usr/irissys/mgr/messages.log  \
 && chmod 666 /usr/irissys/iris.cpf \
 && chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp         

USER ${ISC_PACKAGE_MGRUSER}

COPY  src src 
COPY  iris.script /tmp/iris.script

RUN iris start IRIS \
    && iris session IRIS < /tmp/iris.script \
    && iris stop IRIS quietly

