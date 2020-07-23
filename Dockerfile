FROM dwolla/jenkins-agent-core:alpine

USER root
ENV SONAR_RUNNER_HOME=/usr/lib/sonar-scanner
ENV NODE_PATH=/usr/local/lib/node_modules
ENV SONAR_SCANNER_VERSION=4.4.0.2170

RUN apk add --no-cache curl grep sed unzip nodejs nodejs-npm bash && \
    npm install -g typescript

WORKDIR /usr/src

RUN curl --insecure -o ./sonarscanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip && \
	unzip sonarscanner.zip && \
	rm sonarscanner.zip && \
	mv sonar-scanner-${SONAR_SCANNER_VERSION}-linux /usr/lib/sonar-scanner && \
	ln -s /usr/lib/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner



COPY sonar-runner.properties /usr/lib/sonar-scanner/conf/sonar-scanner.properties

RUN sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' /usr/lib/sonar-scanner/bin/sonar-scanner

USER jenkins