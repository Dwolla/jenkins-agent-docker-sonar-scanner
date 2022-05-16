CORE_TAG := 11.0.14.1_1-jdk-2cce095
JOB := core-${CORE_TAG}
CHECK_JOB := check-${CORE_TAG}
CLEAN_JOB := clean-${CORE_TAG}

all: ${CHECK_JOB} ${JOB}
check: ${CHECK_JOB}
clean: ${CLEAN_JOB}
.PHONY: all check clean ${JOB} ${CHECK_JOB} ${CLEAN_JOB}

${JOB}: core-%: Dockerfile
	docker build \
	  --build-arg CORE_TAG=$* \
	  --tag dwolla/jenkins-agent-sonar-scanner:$*-SNAPSHOT \
	  .

${CHECK_JOB}: check-%:
	grep --silent "^  core_tag: $*$$" .github/workflows/ci.yml

${CLEAN_JOB}: clean-%:
	docker image rm --force dwolla/jenkins-agent-sonar-scanner:$*-SNAPSHOT