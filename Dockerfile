FROM frekele/java:latest

MAINTAINER frekele <leandro.freitas@softdevelop.com.br>

ENV MAVEN_VERSION=3.3.9
ENV MAVEN_HOME=/opt/mvn
ENV M2_FOLDER=/root/.m2

# change to tmp folder
WORKDIR /tmp

# Download and extract maven to opt folder
RUN wget --no-check-certificate --no-cookies http://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && wget --no-check-certificate --no-cookies http://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz.md5 \
    && echo "$(cat apache-maven-${MAVEN_VERSION}-bin.tar.gz.md5) apache-maven-${MAVEN_VERSION}-bin.tar.gz" | md5sum -c \
    && tar -zvxf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /opt/ \
    && ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/mvn \
    && rm -f apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && rm -f apache-maven-${MAVEN_VERSION}-bin.tar.gz.md5

# add executables to path
RUN update-alternatives --install "/usr/bin/mvn" "mvn" "/opt/mvn/bin/mvn" 1 && \
    update-alternatives --set "mvn" "/opt/mvn/bin/mvn" 

# Create .m2 folder
RUN mkdir -p $M2_FOLDER

# Mark as volume
VOLUME  $M2_FOLDER

# Add the files
ADD rootfs /

# change to root folder
WORKDIR /root