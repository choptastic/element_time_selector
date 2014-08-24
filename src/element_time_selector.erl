%% vim: ts=4 sw=4 et
-module(element_time_selector).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").
-export([reflect/0, render_element/1, format_time/1, event/1]).

reflect() -> record_info(fields, time_selector).

render_element(Rec = #time_selector{start=Start, finish=Finish, increment=Inc, value=Value, tag=Tag}) ->
    Times = lists:seq(Start, Finish, Inc),
    Options = [format_time(T) || T <- Times],
    ID = wf:temp_id(),
    Postback = case Tag of
        undefined -> undefined;
        _ -> {Tag, ID}
    end,
    #dropdown{
        options=Options,
        value=Value,
        id=ID,
        postback=Postback,
        delegate=?MODULE,
        class=Rec#time_selector.class,
        style=Rec#time_selector.style,
        data_fields=Rec#time_selector.data_fields
    }.

event({Tag, ID}) ->
    Time = wf:to_integer(wf:q(ID)), 
    FormattedTime = format_time(Time),
    Page = wf:page_module(),
    Page:time_selector_event(Tag, FormattedTime).  


format_time(Time) ->
    Hour = Time div 60,
    Minute = Time rem 60,
    TimeStr = [wf:to_list(Hour), ":", wf:to_list(Minute)],
    #option{text=TimeStr, value=wf:to_list(Time)}.
