FROM centos:centos7

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
RUN yum install -y https://repo.ius.io/ius-release-el7.rpm
RUN yum install -y python36u python36u-libs python36u-devel python36u-pip


# Influx DB
RUN yum install -y influxdb

# Varken
WORKDIR /opt/
RUN git clone -b develop --single-branch https://github.com/Boerderij/Varken.git
RUN adduser --system --no-create-home varken
WORKDIR /opt/Varken
RUN /usr/bin/python3.6 -m venv /opt/Varken/varken-venv
RUN /opt/Varken/varken-venv/bin/python -m pip install -r requirements.txt
RUN chown varken:varken -R /opt/Varken

# Grafana
RUN yum install -y initscripts urw-fonts
RUN yum install -y https://dl.grafana.com/oss/release/grafana-6.1.4-1.x86_64.rpm

# nginx
RUN yum install -y nginx
RUN cp -r /defaults/nginx/nginx.conf /etc/nginx/nginx.conf

# Get telegraf # and install
RUN wget https://dl.influxdata.com/telegraf/releases/telegraf-1.8.3-1.x86_64.rpm
RUN yum localinstall telegraf-1.8.3-1.x86_64.rpm
WORKDIR /etc/telegraf/
RUN systemctl start telegraf

# crontab
RUN yum install -y cronie
RUN (crontab -l 2>/dev/null; echo "* * * * * /usr/bin/verify-services.sh") | crontab -

# configure services (systemd)
RUN systemctl enable influxdb
RUN systemctl enable prepare-config.service
RUN systemctl enable varken.service
RUN systemctl enable grafana.service
RUN systemctl enable nginx
RUN systemctl enable telegraf

# Update Grafana Panels
RUN grafana-cli plugins update-all
RUN service grafana-server restart

WORKDIR /root/

# End
CMD ["/usr/sbin/init"]
