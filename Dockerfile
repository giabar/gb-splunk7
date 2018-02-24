FROM giabar/gb-centos7
LABEL maintainer=giabar.ocm
RUN wget -O splunk-7.0.2-03bbabbd5c0f-Linux-x86_64.tgz 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=7.0.2&product=splunk&filename=splunk-7.0.2-03bbabbd5c0f-Linux-x86_64.tgz&wget=true' &&\
    tar zxvf splunk-7.0.2-03bbabbd5c0f-Linux-x86_64.tgz -C /opt
