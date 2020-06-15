-module(calling).
-import(lists,[foreach/2,nth/2]).
-export([start/1]).

-export([passingto/2]).
-import(exchange,[printingmessages/1]).


passingto(XParaname,TimoutTime)->
 receive
    
        {requestmessage,REQMsgInfo}->
		                 RecieverPID=nth(1,REQMsgInfo),
						 RecieverName=nth(2,REQMsgInfo),
						 Timout=nth(3,REQMsgInfo),
						 {A1,A2,A3} = now(),
                         random:seed(A1, A2, A3),
						 TimeDis=A3,
						 Tun=[RecieverName,XParaname,TimeDis,Timout],
						 whereis(exchange)!{masterequest,Tun},
						 Sleeptimer2=rand:uniform(100),
						 timer:sleep(Sleeptimer2),
						 Tun1=[XParaname,RecieverName,TimeDis,Timout],
						 RecieverPID ! {replymessege,Tun1},
						passingto(XParaname,Timout);
         
		 {replymessege,Rlist}->
		                CN=nth(1,Rlist),
						RecieverName=nth(2,Rlist),
						Timout=nth(4,Rlist),
						TimeDis1=nth(3,Rlist),
						Yup=[CN,RecieverName,TimeDis1,Timout],
		                whereis(exchange)!{mastereply,Yup},
						passingto(XParaname,Timout)
				after TimoutTime-> io:fwrite("Process ~p has received no calls for ~w seconds,ending... ~n",[XParaname,TimoutTime/1000])
	end.

	
	

start(Callslist)->
  io:fwrite("Sending messages."),
  Sender=nth(1,Callslist),
  Recievers=nth(2,Callslist),
  %R1list=[whereis(Sender),Recievers],
  foreach(fun(C) -> REQMsgInfo=[whereis(C),C,length(Recievers)*2000],
					whereis(Sender) ! {requestmessage,REQMsgInfo}
					end, Recievers),
  %callingperson(Recievers,R1list),
  TimoutTime=4000,
  passingto(Sender,TimoutTime).


