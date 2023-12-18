-module(snatch_playground).
-export([main/1]).

-include_lib("erlcloud/include/erlcloud_aws.hrl").

-define(TEST_MESSAGE, <<"<iq id=\"test-bot\" to=\"alice@localhost\" from=\"bob@localhost/pc\" type=\"get\"><query/></iq>">>).
-define(TEST_SNS_TOPIC, <<"arn:aws:sns:us-east-1:000000000000:LocalSNSTopic">>).
-define(TEST_SQS_QUEUE, <<"http://localhost:4566/000000000000/LocalSQSQueue">>).

main(_Args) ->
    {ok, _} = application:ensure_all_started(erlcloud),
    {ok, _} = application:ensure_all_started(snatch),

    AwsConfig = case wrap_error(fun() -> erlcloud_aws:auto_config() end) of
        {ok, Config} -> Config;
        {error, _} -> erlcloud_aws:default_config()
    end,

    io:format("AWS Config: ~p~n", [AwsConfig]),

    {ok, SnsPid} = claws_aws_sns:start_link(AwsConfig),
    ok = gen_server:stop(SnsPid),
    ok = application:stop(snatch),
    halt().

wrap_error(Fun) ->
    try
        Fun()
    catch _:Reason ->
        {error, {lhttpc_error, Reason}}
    end.
