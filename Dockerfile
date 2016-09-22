FROM java:alpine
MAINTAINER Owen Ouyang <owen.ouyang@live.com>

# Switch user to root so that we can install apps (jenkins image switches to user "jenkins" in the end)
USER root

RUN apk update && \
    apk add --nocache --update openssh-client git && \
    cd / && \
    git clone -b 5.0 --single-branch https://github.com/apereo/cas-overlay-template.git cas-overlay && \
    git clone -b dockerized-caswebapp --single-branch https://github.com/apereo/cas.git cas && \
    mkdir -p /etc/cas/jetty cas-overlay/bin cas-overlay/src/main && \
    mv cas-overlay/etc/* /etc/cas/ && \
    mv cas/bin/*.* cas-overlay/bin/ && \
    chmod -R 750 cas-overlay/bin cas-overlay/mvnw && \
    mv /cas/src/main/webapp/ cas-overlay/src/main/ && \
    mv /cas/thekeystore /etc/cas/jelly/thekeystore && \
    cd /cas-overlay && \
    ./mvnw clean package && \
    apk del openssh-client git && \
    rm -rf cas
    
    
WORKDIR /cas-overlay

CMD ["/cas-overlay/bin/run-jetty.sh"]
    
