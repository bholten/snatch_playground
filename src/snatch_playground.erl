-module(snatch_playground).
-export([main/1]).

-define(TEST_MESSAGE, <<"<iq id=\"test-bot\" to=\"alice@localhost\" from=\"bob@localhost/pc\" type=\"get\"><query/></iq>">>).
-define(TEST_ID, <<"id">>).

main(_Args) ->
    Args = init:get_plain_arguments(), %% TODO
    ParsedConfig = parse_args(Args),
    % {ok, SqsPid} = snatch:start_link(claws_xmpp, claws_aws_sqs, ParsedConfig),
    {ok, SnsPid} = snatch:start_link(claws_xmpp, claws_aws_sns, ParsedConfig),

    SnsPid ! {send, ?TEST_MESSAGE, ?TEST_ID},

    % ok = gen_server:stop(SqsPid),
    ok = gen_server:stop(SnsPid),
    ok = application:stop(snatch),
    halt().

parse_args(Args) ->
    lists:foldl(fun parse_arg/2, #{}, Args).

parse_arg(Arg, Acc) ->
    case string:split(Arg, "=", all) of
        [Key, Value] ->
            AtomKey = list_to_atom(string:trim(Key)),
            maps:put(AtomKey, string:trim(Value), Acc);
        _ ->
            Acc
    end.
