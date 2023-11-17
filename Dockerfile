FROM erlang:23

WORKDIR /usr/src/app

COPY . .

ENV PATH=$PATH:/root/.cache/rebar3/bin

RUN rebar3 escriptize

CMD ["_build/default/bin/snatch_playground"]
