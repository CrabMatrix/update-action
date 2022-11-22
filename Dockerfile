# Container image that runs your code
FROM alpine:3.10
WORKDIR /source
RUN apk add --update git npm build-base && \
    npm install -g semver && \
    apk add --no-cache python3 py3-pip py-pip
RUN /usr/bin/python3.7 -m pip install --upgrade pip
RUN pip install toml-cli
# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh
# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["sh", "/entrypoint.sh"]