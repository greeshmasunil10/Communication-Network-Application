-module(calling).
-import(lists,[foreach/2,nth/2]).
-export([startnetwork/1]).
-export([sendmessage/2]).
-import(exchange,[masterstatus/1]).

startnetwork(Callslist)->
  Sender=nth(1,Callslist),
  Recievers=nth(2,Callslist),
  foreach(fun(X) -> REQMsgInfo=[whereis(X),X,length(Recievers)*2000],
					whereis(Sender) ! {requestmessage,REQMsgInfo}
					end, Recievers),
  TimoutTime=4000,
  sendmessage(Sender,TimoutTime).

sendmessage(Sender,TimoutTime)->
 receive
    {requestmessage,REQMsgInfo}->
		RecieverPID=nth(1,REQMsgInfo),
		RecieverName=nth(2,REQMsgInfo),
		Timout=nth(3,REQMsgInfo),
		{MegaSecs, Secs, MicroSecs} = now(),
        random:seed({MegaSecs, Secs, MicroSecs}),
		whereis(masterID)!{masterequest,[RecieverName,Sender,MicroSecs,Timout]},
		timer:sleep(rand:uniform(200)),
		RecieverPID ! {replymessege,[Sender,RecieverName,MicroSecs,Timout]},
		sendmessage(Sender,Timout); 
	{replymessege,Rlist}->
		RecieverName=nth(2,Rlist),
		Timout=nth(4,Rlist),
		TimeDis1=nth(3,Rlist),
		Yup=[nth(1,Rlist),RecieverName,TimeDis1,Timout],
		whereis(masterID)!{mastereply,Yup},
		sendmessage(Sender,Timout)
	after TimoutTime-> io:fwrite("Process ~p has received no calls for ~w seconds,ending... ~n",[Sender,TimoutTime/1000])
 end.

	
	



