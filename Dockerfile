FROM ubuntu:latest

WORKDIR /app

ENV FILE=/app/package.json

# Essentials
ENV TZ=America/Fortaleza
RUN echo $TZ > /etc/timezone \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    &&  echo $TZ > /etc/timezone

RUN apt-get update \
    && apt-get -y upgrade\
    && apt-get install -yqq \
    lsb-release \
    ca-certificates \
    apt-transport-https \
    software-properties-common \
    libaio1t64 \
#    libaio-dev \
    g++ \
    make \
    zip \
    unzip \
    curl \
    nano \
    supervisor \
    bash \
    wget

RUN curl -sL https://deb.nodesource.com/setup_18.x 565 | bash - \
    && apt-get install -y nodejs

RUN mkdir ~/.npm-global \
    && npm config set prefix '~/.npm-global' \
    && export PATH=~/.npm-global/bin:$PATH

RUN npm install --global yarn
RUN apt-get install -yqq yarn

# NVM
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
RUN export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" \
    && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Configure supervisor
RUN mkdir -p /etc/supervidor.d/
COPY supervisord.ini /etc/supervidor.d/supervisord.ini

CMD [ "supervisord", "-c", "/etc/supervisor.d/supervisord.ini" ]

EXPOSE 8080