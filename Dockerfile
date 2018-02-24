FROM giabar/gb-centos7
LABEL maintainer=giabar.ocm

ENV SPLUNK_HOME /opt/splunk
ENV SPLUNK_GROUP splunk
ENV SPLUNK_USER splunk
ENV SPLUNK_BACKUP_DEFAULT_ETC /var/opt/splunk

RUN groupadd -r ${SPLUNK_GROUP} &&\
    useradd -r -m -g ${SPLUNK_GROUP} ${SPLUNK_USER} &&\
    wget -O splunk-7.0.2-03bbabbd5c0f-Linux-x86_64.tgz 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=7.0.2&product=splunk&filename=splunk-7.0.2-03bbabbd5c0f-Linux-x86_64.tgz&wget=true' &&\
    tar zxvf splunk-7.0.2-03bbabbd5c0f-Linux-x86_64.tgz -C /opt &&\
    rm -f splunk-7.0.2-03bbabbd5c0f-Linux-x86_64.tgz &&\
    mkdir -p /var/opt/splunk &&\
    cp -R ${SPLUNK_HOME}/etc ${SPLUNK_BACKUP_DEFAULT_ETC} &&\
    rm -fR ${SPLUNK_HOME}/etc &&\
    chown -R ${SPLUNK_USER}:${SPLUNK_GROUP} ${SPLUNK_HOME} &&\
    chown -R ${SPLUNK_USER}:${SPLUNK_GROUP} ${SPLUNK_BACKUP_DEFAULT_ETC}

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod +x /sbin/entrypoint.sh

EXPOSE 8000/tcp 8089/tcp 8191/tcp 9997/tcp 1514 8088/tcp
WORKDIR /opt/splunk
VOLUME [ "/opt/splunk/etc", "/opt/splunk/var" ]

ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["start-service"]
