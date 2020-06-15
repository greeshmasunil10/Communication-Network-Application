-module(exchange).
-import(lists,[append/2]). 
-import(lists,[nth/2]).
-export([start/0]).
-import(lists,[merge/1]).
-export([printingmessages/1]).
-import(lists, [map/2]).
-export([spawn_processes/2]).


printingmessages(Rt)->
	receive
	    {masterequest,RequestInfo}->
			Receiver1=nth(1,RequestInfo),
			Sender1=nth(2,RequestInfo),
			Timestamp1=nth(3,RequestInfo),
			Ds=nth(4,RequestInfo),
			io:fwrite("~w received intro message from ~w [~w]~n",[Receiver1,Sender1,Timestamp1]),
			printingmessages(Ds);
		  
		{mastereply,ReplyInfo}->
		    Receiver2=nth(1,ReplyInfo),
            Sender2=nth(2,ReplyInfo),
            Timestamp2=nth(3,ReplyInfo),
		    Ds=nth(4,ReplyInfo),
		    io:fwrite("~w received reply message from ~w [~w]~n",[Receiver2,Sender2,Timestamp2]),
		    printingmessages(Ds)
	after Rt->io:fwrite("Master has received no replies for ~w seconds,ending...~n",[Rt/1000]),
	unregister(exchange)
end.
	
spawn_processes(Name,Calls) ->
  %io:fwrite("~n************ list: ~w end~n",[[Name,Calls]]),
  ProcID = spawn(calling,start,[[Name,Calls]]),
  register(Name, ProcID),
  ProcID
  .

start()->
    register(exchange,self()),
	X=file:consult("calls.txt"),
	Lis=nth(2,tuple_to_list(X)),
	io:fwrite("** Calls to be made **~n"),
	map(fun(Y) -> 
      {Name, Calls}=Y,
      io:fwrite("~n~w:~w",[Name,Calls]),
	  spawn_processes(Name,Calls)
    end , Lis),
	io:fwrite("~n"),
    printingmessages(3000).

	

	
	 