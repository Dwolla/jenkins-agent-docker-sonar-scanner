FROM dwolla/jenkins-agent-core:alpine

ENV SONAR_RUNNER_HOME=/usr/lib/sonar-scanner
ENV SONAR_SCANNER_VERSION=4.4.0.2170
ENV DEPENDENCY_CHECK_VERSION=5.3.2

USER root
WORKDIR /opt/

RUN apk add --no-cache curl grep sed unzip nodejs nodejs-npm bash && \
    npm install -g typescript && \
    curl -o ./sonarscanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip && \
    curl -o ./dependency-check.zip -L https://dl.bintray.com/jeremy-long/owasp/dependency-check-${DEPENDENCY_CHECK_VERSION}-release.zip && \
    unzip sonarscanner.zip && \
    unzip dependency-check.zip && \
    rm sonarscanner.zip dependency-check.zip  && \
    mv sonar-scanner-${SONAR_SCANNER_VERSION}-linux ${SONAR_RUNNER_HOME} && \
    ln -s ${SONAR_RUNNER_HOME}/bin/sonar-scanner /usr/local/bin/sonar-scanner && \
    sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' /usr/lib/sonar-scanner/bin/sonar-scanner && \
    chmod +x /opt/dependency-check/bin/dependency-check.sh && \
    /opt/dependency-check/bin/dependency-check.sh --updateonly

COPY sonar-runner.properties ${SONAR_RUNNER_HOME}/conf/sonar-scanner.properties

USER jenkins
