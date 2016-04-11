package videomap;

import java.io.File;
import java.io.IOException;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.Enumeration;

public class MainServer {
    
    static String internetAdress = "127.0.0.1";
    static int port = 8888;
    static String folder = "data" + File.separatorChar;

    public static void main(String[] args) throws InterruptedException, IOException {
        parseArguments(args);
        printNetworkInterfaces();
        
        ImageServer myServer = new ImageServer(internetAdress, port, folder);
    	
        myServer.start();
        
        return;
    }
    
    public static void parseArguments (String[] args) {
    	
    	for (int i = 0; i < args.length; ++i) {
    		//Look if they give me the port
    		if (args[i].equalsIgnoreCase("-p")) {
    			//See the next sentence
    			if ((i + 1) < args.length) {
    				try {
    					port = Integer.parseInt(args[i + 1]);
    					++i;
    				} catch (NumberFormatException e) {
    					printUsage();
    					System.exit(-1);
    				}
    				
    			} else {
    				printUsage();
    				System.exit(-1);
    			}
    		}
    		//Look if they give me the folder
    		if (args[i].equalsIgnoreCase("-f")) {
    			//See the next sentence
    			if ((i + 1) < args.length) {
    				folder = args[i + 1];
    				++i;
    			} else {
    				printUsage();
    				System.exit(-1);
    			}
    		}
    	}
    	
    }
    
    public static void printUsage() {
    	System.out.println("java -jar VMServer.jar [-f <path-to-image-folder>] [-p port]"); 
    }
    
    @SuppressWarnings("static-access")
	public static void printNetworkInterfaces() throws SocketException, UnknownHostException {
    	Enumeration<NetworkInterface> e = NetworkInterface.getNetworkInterfaces();
    	while(e.hasMoreElements())
    	{
    	    NetworkInterface n = (NetworkInterface) e.nextElement();
    	    Enumeration<InetAddress> ee = n.getInetAddresses();
    	    while (ee.hasMoreElements())
    	    {
    	        InetAddress i = (InetAddress) ee.nextElement();
    	        System.out.println(i.getLocalHost());
    	    }
    	}
    }
    
}



