FROM erlang:22.3.4.26

RUN apt-get update
RUN apt-get -y install autoconf automake devscripts gawk g++ git-core git libexpat-dev
RUN apt-get -y install ffmpeg libshout3-dev libmpg123-dev libmp3lame-dev
RUN apt-get -y install dnsutils vim ngrep less net-tools
RUN apt-get -y install libsox-dev libmp3lame0
RUN apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common

WORKDIR /usr/src/app

COPY . .

ENV PATH=$PATH:/root/.cache/rebar3/bin
RUN rebar3 escriptize

CMD ["_build/default/bin/snatch_playground"]
