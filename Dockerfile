FROM amd64/centos:latest

# Enabled systemd
ENV container docker

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

#VOLUME [ "/sys/fs/cgroup" ]

VOLUME [ "/config" ]

# copy root
COPY rootfs/ /

# Base Apps
RUN yum install -y epel-release
RUN yum update -y
RUN yum install -y net-tools initscripts wget git

# Python 3.6.7 + pip
RUN yum install -y https://centos7.iuscommunity.org/ius-release.rpm
RUN yum install -y python36u python36u-libs python36u-devel python36u-pip


# Influx DB
RUN yum install -y influxdb

# Varken
WORKDIR /opt/
RUN git clone https://github.com/Boerderij/Varken.git
RUN adduser --system --no-create-home varken
WORKDIR /opt/Varken
RUN /usr/bin/python3.6 -m venv /opt/Varken/varken-venv
RUN /opt/Varken/varken-venv/bin/python -m pip install -r requirements.txt
RUN chown varken:varken -R /opt/Varken

# Grafana
RUN yum install -y initscripts urw-fonts
RUN yum install -y https://dl.grafana.com/oss/release/grafana-5.4.2-1.x86_64.rpm


# crontab
RUN yum install -y cronie
RUN (crontab -l 2>/dev/null; echo "* * * * * /usr/bin/verify-services.sh") | crontab -

# configure services (systemd)
RUN systemctl enable influxdb
RUN systemctl enable prepare-config.service
RUN systemctl enable varken.service
RUN systemctl enable grafana.service

WORKDIR /root/

# End
CMD ["/usr/sbin/init"]