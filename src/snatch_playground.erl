-module(snatch_playground).
-export([main/1]).

-include_lib("erlcloud/include/erlcloud_aws.hrl").

-define(TEST_MESSAGE, <<"<iq id=\"test-bot\" to=\"alice@localhost\" from=\"bob@localhost/pc\" type=\"get\"><query/></iq>">>).
-define(TEST_SNS_TOPIC, <<"arn:aws:sns:us-east-1:000000000000:LocalSNSTopic">>).
-define(TEST_SQS_QUEUE, <<"http://localhost:4566/000000000000/LocalSQSQueue">>).

main(_Args) ->
    {ok, _} = application:ensure_all_started(erlcloud),
    {ok, _} = application:ensure_all_started(snatch),
    % SnsPid = start_claw(sns),
    % SqsPid = start_claw(sqs),
    SnsPid = start_claw(aws),

    % ok = claws_aws_sns:send(?TEST_MESSAGE, ?TEST_SNS_TOPIC),
    % ok = claws_aws_sqs:send(?TEST_MESSAGE, ?TEST_SQS_QUEUE),

    ok = gen_server:stop(SnsPid),
    ok = application:stop(snatch),
    halt().

start_claw(sns) ->
    AwsConfig = #aws_config{
        access_key_id = "test",
        secret_access_key = "test",
        aws_region = "us-east-1",
        sns_host = "localhost",
        sns_scheme = "http://",
        sns_port = 4566
    },
    {ok, Pid} = claws_aws_sns:start_link(AwsConfig),
    Pid;

start_claw(sqs) ->
    AwsConfig = #aws_config{
        access_key_id = "test",
        secret_access_key = "test"
        % sqs_host = "localhost"
        % sqs_protocol = "http://",
        % sqs_port = 4566
    },
    {ok, Pid} = claws_aws_sqs:start_link(AwsConfig),
    Pid;

start_claw(aws) ->
    {ok, Pid} = claws_aws_sns:start_link(),
    Pid.
