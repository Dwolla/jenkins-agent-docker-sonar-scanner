FROM dwolla/jenkins-agent-core:alpine

ENV SONAR_RUNNER_HOME=/usr/lib/sonar-scanner
ENV SONAR_SCANNER_VERSION=4.4.0.2170

USER root
WORKDIR /usr/src

RUN apk add --no-cache curl grep sed unzip nodejs nodejs-npm bash && \
    npm install -g typescript && \
    curl -o ./sonarscanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip && \
    unzip sonarscanner.zip && \
    rm sonarscanner.zip && \
    mv sonar-scanner-${SONAR_SCANNER_VERSION}-linux ${SONAR_RUNNER_HOME} && \
    ln -s ${SONAR_RUNNER_HOME}/bin/sonar-scanner /usr/local/bin/sonar-scanner && \
    sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' /usr/lib/sonar-scanner/bin/sonar-scanner

COPY sonar-runner.properties ${SONAR_RUNNER_HOME}/conf/sonar-scanner.properties

USER jenkins