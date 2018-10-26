FROM openjdk:8-jre-alpine
MAINTAINER Radically Open Security <infra@radicallyopensecurity.com>

ENV LANGUAGE="C.UTF-8" \
    LANG="C.UTF-8" \
    LC_CTYPE="C.UTF-8" \
    PENTEXT_PATH="/opt/pentext" \
    FOP_HOME="/opt/fop"

## BEGIN INSTALL PYTHON

RUN apk add --update --no-cache \
    python3 \
    curl \
    ttf-liberation \
    && if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi \
    && rm -rf /var/cache/apk/*

## END INSTALL PYTHON

## BEGIN INSTALL PENTEXT
COPY . /opt/pentext

RUN ln -s /opt/pentext/chatops/python/gitlab-to-pentext.py /usr/local/bin/ \
    && ln -s /opt/pentext/chatops/python/docbuilder.py /usr/local/bin/ \
    && ln -s /opt/pentext/chatops/python/validate_report.py /usr/local/bin/ \
    && chmod +x /usr/local/bin/docbuilder.py \
    && chmod +X /usr/local/bin/validate_report.py \
    && chmod +X /usr/local/bin/gitlab-to-pentext.py

## END INSTALL PENTEXT

## BEGIN SETUP DOCBUILDER

### Install Saxon

#### We use add here to allow caching this step
ADD https://downloads.sourceforge.net/project/saxon/Saxon-HE/9.7/SaxonHE9-7-0-6J.zip  /tmp/saxon.zip

ADD https://www-eu.apache.org/dist//xmlgraphics/fop/binaries/fop-2.1-bin.zip /tmp/fop.zip

ADD https://github.com/radicallyopensecurity/docbuilder/archive/master.zip /tmp/docbuilder.zip

RUN mkdir /tmp/saxon && cd /tmp/saxon \
    && unzip -q /tmp/saxon.zip \
    && mkdir -p /usr/local/bin/saxon \
    && mv /tmp/saxon/saxon9he.jar /usr/local/bin/saxon/saxon9he.jar \
    ### install Fop
    && mkdir /tmp/fop && cd /tmp/fop \
    && unzip -q /tmp/fop.zip \
    && cp /tmp/fop/fop-2.1/fop /usr/local/bin \
    && chmod +x /usr/local/bin/fop \
    && cp -r /tmp/fop/fop-2.1 /opt/fop \
    ### Install docbuilder
    && mkdir /tmp/docbuilder \
    && cd /tmp/docbuilder && unzip /tmp/docbuilder.zip \
    && mv /tmp/docbuilder/docbuilder-master /etc/docbuilder \
    && ln -s /etc/docbuilder/rosfop.xconf /etc/docbuilder/fop.xconf \
    ### Cleanup
    && rm -rf /tmp/saxon* /tmp/fop* /tmp/docbuilder* \
    ### Ensure fonts are where pentext / docbuilder expect them
    && mkdir -p /usr/share/fonts/truetype \
    && ln -s /usr/share/fonts/ttf-liberation /usr/share/fonts/truetype/liberation

## END SETUP DOCBUILDER

WORKDIR /srv/pentext/source

CMD echo "The easiest way to use docbuilder is to execute: 'docker run -v LOCAL_PENTEXT_WORKDIR:/srv/pentext pentext docbuilder.py'"