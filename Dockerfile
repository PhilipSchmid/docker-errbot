# ErrBot Docker container based on rroemhild/docker-errbot

FROM python:latest

MAINTAINER Philip Schmid <philip.schmid@ins.hsr.ch>

ENV ERR_USER err
ENV DEBIAN_FRONTEND noninteractive
ENV PATH /app/venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Set default locale for the environment
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Add err user and group
RUN groupadd -r $ERR_USER \
    && useradd -r \
       -g $ERR_USER \
       -d /srv \
       $ERR_USER

# Install packages and perform cleanup
RUN apt-get update && apt-get -y upgrade \
  && apt-get -y install --no-install-recommends \
         git \
         apt-utils \
         qalc \
         locales \
         dnsutils \
         curl \
    && locale-gen C.UTF-8 \
    && /usr/sbin/update-locale LANG=C.UTF-8 \
    && echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen \
    && locale-gen \
    && pip3 install virtualenv \
    && pip3 install git+https://github.com/saltstack/pepper \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /srv/data /srv/plugins /srv/errbackends /app \
    && chown -R $ERR_USER: /srv /app

USER $ERR_USER
WORKDIR /srv

COPY requirements.txt /app/requirements.txt

RUN virtualenv --system-site-packages -p python3 /app/venv
RUN /app/venv/bin/pip3 install --no-cache-dir -r /app/requirements.txt

COPY config.py /app/config.py
COPY run.sh /app/venv/bin/run.sh

EXPOSE 3141 3142
VOLUME ["/srv"]

CMD ["/app/venv/bin/run.sh"]
