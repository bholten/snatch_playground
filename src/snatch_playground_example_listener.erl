-module(snatch_playground_example_listener).
-export([init/1, handle_info/2, terminate/2]).

init(Args) -> {ok, Args}.

handle_info({received, Data}, State) ->
    io:format("Received data: ~p~n", [Data]),
    {noreply, State};

handle_info(_Info, State) -> {noreply, State}.

terminate(_Reason, _State) -> ok.
