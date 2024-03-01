-module(snatch_playground_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    {ok, Pid} = claws_aws_sqs:start_link(),
    {ok, PlaygroundPid} = gen_server:start_link(snatch_playground_example_listener, [], []),
    {ok, SqsPid} = snatch:start_link(claws_aws_sqs, PlaygroundPid),
    ChildSpec = [
        {claws_aws_sqs_mod, Pid},
        {snatch_playground_example_listener, PlaygroundPid},
        {snatch_sqs, SqsPid}
        ],
    {ok, {{one_for_one, 5, 10}, ChildSpec}}. %% Just an example

