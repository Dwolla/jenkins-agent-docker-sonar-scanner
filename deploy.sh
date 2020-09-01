#!/bin/bash
version=v$(date +'%Y-%m-%d')

git clone https://${GITHUB_TOKEN}@github.com/Dwolla/jenkins-agent-docker-sonar-scanner.git
git tag $(version)
git push origin $(version)