ARG IMAGE=intersystemsdc/iris-community:latest
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
 && chown irisowner:irisuser /opt/irisapp       

USER irisowner

COPY  src src 
COPY  module.xml module.xml
COPY  iris.script /tmp/iris.script

RUN iris start IRIS \
    && iris session IRIS < /tmp/iris.script \
    && iris stop IRIS quietly

