FROM selenoid/vnc:chrome_112.0
USER root

ARG CSP_LICENSE_KEY=false
ARG USER_NAME=selenium
ARG CONTAINER_1=false
ARG CONTAINER_2=false
ARG CONTAINER_3=false
ARG CONTAINER_4=false
ARG CONTAINER_5=false
ARG CONTAINER_6=false
ARG PASSWORD_1=1234567890
ARG PASSWORD_2=1234567890
ARG PASSWORD_3=1234567890
ARG PASSWORD_4=1234567890
ARG PASSWORD_5=1234567890
ARG PASSWORD_6=1234567890
# ARG CER_1=false

ADD dist/ /tmp/dist/
ADD cert/ /tmp/cert/

RUN apt update && apt-get install -y libgtk2.0-dev
RUN tar -zxf /tmp/dist/linux-amd64_deb.tgz -C /tmp/dist/

# Установка КриптоПро CSP 5
RUN /tmp/dist/linux-amd64_deb/install.sh
RUN dpkg -i /tmp/dist/linux-amd64_deb/lsb-cprocsp-pkcs11-64_*
RUN dpkg -i /tmp/dist/linux-amd64_deb/cprocsp-rdr-gui-gtk-64_*

# Ввод лицензионного ключа если передан параметр CSP_LICENSE_KEY
RUN if [ "$CSP_LICENSE_KEY" = "false" ] ; then echo 'No CSP_LICENSE_KEY'; else  /opt/cprocsp/sbin/amd64/cpconfig -license -set $CSP_LICENSE_KEY; fi

# Проверка лицензии
RUN /opt/cprocsp/sbin/amd64/cpconfig -license -view

# Перенос закрытого ключа в HDIMAGE
RUN mkdir -p /var/opt/cprocsp/keys/$USER_NAME && cp -r /tmp/cert/* /var/opt/cprocsp/keys/$USER_NAME/ && rm -rf /tmp/cert/
# даем права на чтение закрытого ключа пользователю $USER_NAME
RUN chown $USER_NAME /var/opt/cprocsp/keys/$USER_NAME/ -R

# устанавливаем корневые и промежуточные сертификаты, чтобы цепочка сертификатов была доверенной:
# RUN if [ "$CER_1" = "false" ] ; then echo 'CER_1 not need to install root and uca cert'; else  /opt/cprocsp/bin/amd64/certmgr -inst -store uroot -file /tmp/cer/$CER_1 && /opt/cprocsp/bin/amd64/certmgr -inst -store uca -file /tmp/cer/$CER_1; fi

RUN apt update && apt-get install -y pcscd
RUN dpkg -i /tmp/dist/IFCPlugin-x86_64.deb
RUN rm /etc/ifc.cfg && cp /tmp/dist/ifc.cfg /etc/ifc.cfg
RUN cp /tmp/dist/pbefkdcndngodfeigfdgiodgnmbgcfha.json /opt/google/chrome/extensions/pbefkdcndngodfeigfdgiodgnmbgcfha.json

USER $USER_NAME
RUN /opt/cprocsp/bin/amd64/csptestf -absorb -certs -autoprov

# Убираем пароль из контейнеров
RUN if [ "$CONTAINER_1" = "false" ] ; then echo 'CONTAINER_1 not need to delete password'; else  /opt/cprocsp/bin/amd64/csptest -passwd -change '' -container $CONTAINER_1 -passwd $PASSWORD_1; fi
RUN if [ "$CONTAINER_2" = "false" ] ; then echo 'CONTAINER_2 not need to delete password'; else  /opt/cprocsp/bin/amd64/csptest -passwd -change '' -container $CONTAINER_2 -passwd $PASSWORD_2; fi
RUN if [ "$CONTAINER_3" = "false" ] ; then echo 'CONTAINER_3 not need to delete password'; else  /opt/cprocsp/bin/amd64/csptest -passwd -change '' -container $CONTAINER_3 -passwd $PASSWORD_3; fi
RUN if [ "$CONTAINER_4" = "false" ] ; then echo 'CONTAINER_4 not need to delete password'; else  /opt/cprocsp/bin/amd64/csptest -passwd -change '' -container $CONTAINER_4 -passwd $PASSWORD_4; fi
RUN if [ "$CONTAINER_5" = "false" ] ; then echo 'CONTAINER_5 not need to delete password'; else  /opt/cprocsp/bin/amd64/csptest -passwd -change '' -container $CONTAINER_5 -passwd $PASSWORD_5; fi
RUN if [ "$CONTAINER_6" = "false" ] ; then echo 'CONTAINER_6 not need to delete password'; else  /opt/cprocsp/bin/amd64/csptest -passwd -change '' -container $CONTAINER_6 -passwd $PASSWORD_6; fi

USER $USER_NAME
