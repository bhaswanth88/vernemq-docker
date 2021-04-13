FROM erlang:21.3
RUN apt-get update && \
    apt-get -y install sudo make bash procps openssl iproute2 curl jq libsnappy-dev net-tools && \
    rm -rf /var/lib/apt/lists/* && \
    addgroup --gid 10000 vernemq && \
    adduser --uid 10000 --system --ingroup vernemq --home /vernemq --disabled-password vernemq
RUN echo '%vernemq ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
ENV DOCKER_VERNEMQ_LOG__CONSOLE=console
RUN git clone https://github.com/vernemq/vernemq.git
RUN cd vernemq/ && make rel
WORKDIR /vernemq/_build/default/rel/vernemq
RUN cd bin && ls -al
RUN cd etc && ls -al
EXPOSE 1883 8883 8080 44053 4369 8888 \
       9100 9101 9102 9103 9104 9105 9106 9107 9108 9109
USER vernemq
CMD ["bin/vernemq", "start"]
