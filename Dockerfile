FROM erlang:23

WORKDIR /usr/src/app

COPY . .

# Set the environment path to include Rebar3
ENV PATH=$PATH:/root/.cache/rebar3/bin

# Build the escript
RUN rebar3 escriptize

# Run the application when the container launches
CMD ["_build/default/bin/snatch_playground"]
