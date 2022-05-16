ARG CORE_TAG

FROM dwolla/jenkins-agent-core:$CORE_TAG
ENV SONAR_RUNNER_HOME=/usr/lib/sonar-scanner
ENV SONAR_SCANNER_VERSION=4.4.0.2170
ENV DEPENDENCY_CHECK_VERSION=5.3.2

USER root
WORKDIR /opt/

RUN gpg --keyserver keyserver.ubuntu.com --recv-keys F9514E84AE3708288374BBBE097586CFEA37F9A6 && \
    curl -o dependency-check.zip.asc -L https://github.com/jeremylong/DependencyCheck/releases/download/v${DEPENDENCY_CHECK_VERSION}/dependency-check-${DEPENDENCY_CHECK_VERSION}-release.zip.asc && \
    curl -o dependency-check.zip -L https://github.com/jeremylong/DependencyCheck/releases/download/v${DEPENDENCY_CHECK_VERSION}/dependency-check-${DEPENDENCY_CHECK_VERSION}-release.zip && \
    gpg --verify dependency-check.zip.asc dependency-check.zip && \
    unzip dependency-check.zip && \
    chmod +x /opt/dependency-check/bin/dependency-check.sh && \
    /opt/dependency-check/bin/dependency-check.sh --updateonly && \
    chown -R jenkins /opt/dependency-check && \
    apt-get update && \
    apt-get install -y --no-install-recommends curl ruby ruby-etc ruby-rdoc grep sed unzip nodejs npm bash && \
    npm install -g typescript && \
    gem install bundler-audit bundler && \
    bundle audit update && \
    curl -o ./sonarscanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip && \
    unzip sonarscanner.zip && \
    rm sonarscanner.zip dependency-check.zip  && \
    mv sonar-scanner-${SONAR_SCANNER_VERSION}-linux ${SONAR_RUNNER_HOME} && \
    ln -s ${SONAR_RUNNER_HOME}/bin/sonar-scanner /usr/local/bin/sonar-scanner && \
    sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' /usr/lib/sonar-scanner/bin/sonar-scanner

COPY sonar-runner.properties ${SONAR_RUNNER_HOME}/conf/sonar-scanner.properties

USER jenkins
