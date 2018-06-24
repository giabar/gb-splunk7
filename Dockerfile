FROM centos:7.5.1804
LABEL maintainer="info@giabar.com"

ENV SPLUNK_PRODUCT splunk
ENV SPLUNK_VERSION 7.0.3
ENV SPLUNK_BUILD fa31da744b51
ENV SPLUNK_FILENAME splunk-${SPLUNK_VERSION}-${SPLUNK_BUILD}-Linux-x86_64.tgz

ENV SPLUNK_HOME /opt/splunk
ENV SPLUNK_GROUP splunk
ENV SPLUNK_USER splunk
ENV SPLUNK_BACKUP_DEFAULT_ETC /var/opt/splunk

RUN groupadd -r ${SPLUNK_GROUP} &&\
    useradd -r -m -g ${SPLUNK_GROUP} ${SPLUNK_USER} &&\
    mkdir -p ${SPLUNK_HOME} &&\
    yum -y install wget sudo &&\
    wget -qO /tmp/${SPLUNK_FILENAME} https://download.splunk.com/products/${SPLUNK_PRODUCT}/releases/${SPLUNK_VERSION}/linux/${SPLUNK_FILENAME} &&\
    wget -qO /tmp/${SPLUNK_FILENAME}.md5 https://download.splunk.com/products/${SPLUNK_PRODUCT}/releases/${SPLUNK_VERSION}/linux/${SPLUNK_FILENAME}.md5 &&\
    (cd /tmp && md5sum -c ${SPLUNK_FILENAME}.md5) &&\
    tar xzf /tmp/${SPLUNK_FILENAME} --strip 1 -C ${SPLUNK_HOME} &&\
    rm /tmp/${SPLUNK_FILENAME} &&\
    rm /tmp/${SPLUNK_FILENAME}.md5 &&\
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
