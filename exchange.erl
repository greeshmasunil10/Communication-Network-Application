-module(exchange).
-export([start/0]).
-import(lists,[nth/2]).
-export([masterstatus/1]).
-import(lists, [map/2]).
-export([spawn_processes/2]).

masterstatus(TimeoutTime)->
	receive
	    {masterequest,RequestInfo}->
			io:fwrite("~w received intro message from ~w [~w]~n",[nth(1,RequestInfo),nth(2,RequestInfo),nth(3,RequestInfo)]),
			masterstatus(nth(4,RequestInfo));
		{mastereply,ReplyInfo}->
		    io:fwrite("~w received reply message from ~w [~w]~n",[nth(1,ReplyInfo),nth(2,ReplyInfo),nth(3,ReplyInfo)]),
		    masterstatus(nth(4,ReplyInfo))
	after TimeoutTime->io:fwrite("Master has received no replies for ~w seconds,ending...~n",[TimeoutTime/1000])	
end.
	
spawn_processes(Name,Calls) ->
  %io:fwrite("~n************ list: ~w end~n",[[Name,Calls]]),
  ProcID = spawn(calling,startnetwork,[[Name,Calls]]),
  register(Name, ProcID),
  ProcID.

start()->
    register(masterID,self()),
	X=file:consult("calls.txt"),
	Lis=nth(2,tuple_to_list(X)),
	io:fwrite("** Calls to be made **~n"),
	map(fun(Y) -> 
      {Name, Calls}=Y,
      io:fwrite("~n~w:~w",[Name,Calls]),
	  spawn_processes(Name,Calls)
    end , Lis),
	io:fwrite("~n"),
    masterstatus(3000).

	

	
	 