import java.io.File;
import java.io.FileNotFoundException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Scanner;

public class exchange implements Runnable {
	HashMap<String,ArrayList<String>> data = new HashMap<>();
	static Thread masterthread;
	ArrayList<calling> senders = new ArrayList<>();
	public exchange() {
	}
	@Override
	public void run() {
		long start = System.currentTimeMillis();
		loadData();
		dispInfo();
		for (HashMap.Entry<String,ArrayList<String>> entry : data.entrySet()) {
			String sender = entry.getKey();
			ArrayList<String> recs = entry.getValue();
			calling obj = new calling(sender);
			obj.setrecs(recs);
			senders.add(obj);
		}
		for(calling obj : senders) {
			obj.callerthread.start();
		}
		try {
			masterthread.join(4500);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		long end=System.currentTimeMillis();
		long now= (end-start)/1000;
		System.out.println("Master has received no reply for "+now+" seconds,ending...");
	}

	public static void main(String[] args) {
		exchange obj = new exchange();
		masterthread = new Thread(obj,"masterthread");
		masterthread.start();
	} 


	private void dispInfo() {
		System.out.println("** Calls to be made **");
		for (HashMap.Entry<String,ArrayList<String>> entry : data.entrySet()) {
			System.out.print("\n"+entry.getKey()+":");
			for(String rec: entry.getValue())
				System.out.print(rec+",");
		}
		System.out.println();
	}

	public void loadData() {
		File f1= new File("src\\calls.txt");
		try {
			Scanner sc= new Scanner(f1);
			while(sc.hasNextLine())  
			{  
				String line=sc.nextLine(); 
				line = line.replaceAll("[\\{\\]\\}\\.\\s+]", "");
				String[] calls =  line.split("\\[");
				ArrayList<String> recs = new ArrayList(Arrays.asList(calls[1].split(",")));
				String sender = calls[0].replaceAll(",", "");
				data.put(sender,recs);
			}  
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}	
	}
	public static void disp(String name1, String msgType, String name2, long t) {
		System.out.println(name1+" recieved "+ msgType+ " message from "+name2+" ["+t+"]" );
	}
}
