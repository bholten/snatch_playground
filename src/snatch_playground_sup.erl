-module(snatch_playground_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init(_Opts) ->
    ChildSpecs = [
        #{
            id => 'executor_claws_aws_sns',
            start => {claws_aws_sns, start_link, []},
            restart => permanent,
            shutdown => 5000,
            type => worker,
            modules => [claws_aws_sns]
        }
    ],
    {ok, {{one_for_one, 5, 10}, ChildSpecs}}. %% Just an example

