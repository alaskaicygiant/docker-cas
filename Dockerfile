FROM java:alpine
MAINTAINER Owen Ouyang <owen.ouyang@live.com>

# Switch user to root so that we can install apps (jenkins image switches to user "jenkins" in the end)
USER root

RUN apk update && \
    apk add openssh-client git && \
    cd / && \
    git clone -b 4.2.x --single-branch https://github.com/apereo/cas-overlay-template.git cas-overlay && \
    git clone -b dockerized-caswebapp --single-branch https://github.com/apereo/cas.git cas && \
    mkdir -p /etc/cas/jetty cas-overlay/bin cas-overlay/src/main && \
    cp cas-overlay/etc/*.* /etc/cas && \
    mv cas/src/main/webapp/ cas-overlay/src/main/ && \
    mv cas/thekeystore /etc/cas/jelly/ && \
    mv cas/bin/*.* cas-overlay/bin/ && \
    chmod -R 750 cas-overlay/bin cas-overlay/mvnw && \
    cd /cas-overlay && \
    ./mvnw clean package
    
WORKDIR /cas-overlay

CMD ["/cas-overlay/bin/run-jetty.sh"]
    
