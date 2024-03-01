-module(snatch_playground).

-export([main/1]).
-include_lib("erlcloud/include/erlcloud_aws.hrl").

-define(TEST_MESSAGE, <<"<iq id=\"test-bot\" to=\"alice@localhost\" from=\"bob@localhost/pc\" type=\"get\"><query/></iq>">>).

% main(_Args) ->
%     io:format("Starting!~n"),
%     application:start(snatch_playground).

main(_Args) ->
    {ok, _} = application:ensure_all_started(erlcloud),
    {ok, _} = application:ensure_all_started(snatch),

    AwsConfig =
        try erlcloud_aws:auto_config() of
            {ok, Config} ->
                io:format("auto_config/0 success~n", []),
                Config;
            _ ->
                io:format("auto_config/0 bad match~n", []),
                erlcloud_aws:default_config()
        catch _:_ ->
            io:format("auto_config/0 error~n"),
            erlcloud_aws:default_config()
        end,

    io:format("Access Key ID: ~p~n", [AwsConfig#aws_config.access_key_id]),
    io:format("Secret Access Key: ~p~n", [AwsConfig#aws_config.secret_access_key]),
    io:format("Region: ~p~n", [AwsConfig#aws_config.aws_region]),

    ok = application:stop(snatch),
    ok = application:stop(erlcloud),
    halt().

print_loop() ->
    receive
        {received, Data, _Via} ->
            io:format("Received message: ~p~n", [Data]),
            print_loop();
        Message ->
            io:format("Received message: ~p~n", [Message]),
            print_loop()
    end.
