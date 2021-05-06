FROM alpine:3.10

ENV LANG C.UTF-8
# By default JVM will try to allocate 16GB heap, let's reduce its size a bit
ENV JAVA_TOOL_OPTIONS="-Xmx256m"
# This is necessary to prevent java from execve'ing itself
ENV LD_LIBRARY_PATH=/usr/lib/jvm/java-1.8-openjdk/jre/lib/amd64/server:/usr/lib/jvm/java-1.8-openjdk/jre/lib/amd64:/usr/lib/jvm/java-1.8-openjdk/jre/../lib/amd64

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
    echo '#!/bin/sh'; \
        echo 'set -e'; \
        echo; \
        echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
    } > /usr/local/bin/docker-java-home \
    && chmod +x /usr/local/bin/docker-java-home
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

RUN apk add --no-cache openjdk8 && \
    mkdir -p /usr/lib/jvm/java-1.8-openjdk/lib/security/ && \
    ln -s /etc/ssl/certs/java/cacerts /usr/lib/jvm/java-1.8-openjdk/lib/security/cacerts && \
    [ "$JAVA_HOME" = "$(docker-java-home)" ]

WORKDIR /app
COPY HelloWorld.java /app/HelloWorld.java
RUN javac HelloWorld.java
RUN jar cfe app.jar HelloWorld HelloWorld.class

CMD ["java", "-jar" ,"/app/app.jar"]
