import java.util.ArrayList;
import java.util.HashMap;
import java.util.Random;

public class calling implements Runnable{

	HashMap<String,Thread> threadList= new HashMap<>();
	String caller;
	ArrayList<calling> receiverobjects= new ArrayList<>();
	ArrayList<String> receivernames= new ArrayList<>();
	Thread callerthread;

	public calling(String sender) {
		this.caller=sender;
		callerthread = new Thread(this);
	}
	public void setrecs(ArrayList<String> recs) {
		this.receivernames=recs;
		for(String rec: recs) {
			calling obj = new calling(rec);
			receiverobjects.add(obj);
		}
	}

	public void getMessage(String sender) throws InterruptedException {
		Random time1 = new Random();
		int  sleeptime = time1.nextInt(150);
		Thread.sleep(sleeptime);
		long t= System.currentTimeMillis();
		exchange.disp(sender, "intro", this.caller,t);
		sendReply(this.caller, sender,t);
	}
	public void sendReply(String sender, String receiver, long t) throws InterruptedException {
		Random time1 = new Random();
		int  sleeptime = time1.nextInt(500);
		Thread.sleep(sleeptime);
		exchange.disp(sender, "reply", receiver, t);
	}

	@Override
	public void run() {
		long start = System.currentTimeMillis();
		for(calling rec : receiverobjects) {
			try {
				rec.getMessage(this.caller);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		try {
			this.callerthread.join(2000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		long end=System.currentTimeMillis();
		long now= (end-start)/1000;
		System.out.println("Process "+this.caller+" has received no calls for "+now+" seconds,ending... ");
	}

}
