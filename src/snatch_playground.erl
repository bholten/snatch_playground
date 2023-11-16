-module(snatch_playground).
-export([main/1]).

main(_Args) ->
    Args = init:get_plain_arguments(), %% TODO
    ParsedConfig = parse_args(Args),
    {ok, _Pid} = application:ensure_all_started(snatch),
    {ok, SqsPid} = claws_aws_sqs:start_link(ParsedConfig),
    {ok, SnsPid} = claws_aws_sns:start_link(ParsedConfig),

    ok = gen_server:stop(SqsPid),
    ok = gen_server:stop(SnsPid),
    ok = application:stop(snatch),
    halt().

parse_args(_Args) -> #{
    access_key_id => "dummy_access_id",
    secret_access_key => "dummy_secret_key",
    region => "dummy_region",
    queue_url => "dummy_queue_url",
    sns_host => "http://localhost:4566",
    sqs_module => erlcloud_sqs,
    sns_module => erlcloud_sns
}.
