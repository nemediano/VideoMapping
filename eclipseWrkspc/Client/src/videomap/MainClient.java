package videomap;


import java.io.File;


public class MainClient {
    
    static String SERVER_ADDRESS = "127.0.0.1";
    static int PORT = 8888;
    static String FOLDER = "data" + File.separatorChar;
    static int NUMBER_OF_FILES = 2;
    static int WAITING_TIME = 15;

    public static void main(String[] args) {
       parseRags(args);
       
       ImageClient myClient = new ImageClient(SERVER_ADDRESS, PORT);
       myClient.setFolder(FOLDER);
       myClient.setNumFiles(NUMBER_OF_FILES);
       myClient.setWaitingTime(WAITING_TIME);
       
       System.out.println("Tring to connect to server: " + myClient.getAddress());
       System.out.println("On the port: " + myClient.getPort());
       
       myClient.connect();
       
       System.out.println(myClient.getInfo());
       
       boolean alive = true;
       
       while (alive) {
    	  myClient.receiveFile();
    	  
    	  alive = !myClient.terminate();
       }
    }
    
    private static void parseRags(String[] args) {
    	for (int i = 0; i < args.length; ++i) {
    		//Look if they give me the port
    		if (args[i].equalsIgnoreCase("-p")) {
    			//See the next sentence
    			if ((i + 1) < args.length) {
    				try {
    					PORT = Integer.parseInt(args[i + 1]);
    					++i;
    				} catch (NumberFormatException e) {
    					printUsage();
    					System.exit(-1);
    				}
    				
    			} else {
    				printUsage();
    				System.exit(-1);
    			}
    		} else
    		//Look if they give me the folder
    		if (args[i].equalsIgnoreCase("-f")) {
    			//See the next sentence
    			if ((i + 1) < args.length) {
    				FOLDER = args[i + 1];
    				++i;
    			} else {
    				printUsage();
    				System.exit(-1);
    			}
    		} else
    		
    		//Look if they gave me the address
    		if (args[i].equalsIgnoreCase("-a")) {
    			//See the next sentence
    			if ((i + 1) < args.length) {
    				SERVER_ADDRESS = args[i + 1];
    				++i;
    			} else {
    				printUsage();
    				System.exit(-1);
    			}
    		} else
    		
    		//Look if they gave me the number of images to expect
    		if (args[i].equalsIgnoreCase("-n")) {
    			//See the next sentence
    			if ((i + 1) < args.length) {
    				try {
    					NUMBER_OF_FILES = Integer.parseInt(args[i + 1]);
    					++i;
    				} catch (NumberFormatException e) {
    					printUsage();
    					System.exit(-1);
    				}
    			} else {
    				printUsage();
    				System.exit(-1);
    			}
    		} else
    		
    		//Look if they gave me the number of images to expect
    		if (args[i].equalsIgnoreCase("-w")) {
    			//See the next sentence
    			if ((i + 1) < args.length) {
    				try {
    					WAITING_TIME = Integer.parseInt(args[i + 1]);
    					++i;
    				} catch (NumberFormatException e) {
    					printUsage();
    					System.exit(-1);
    				}
    			} else {
    				printUsage();
    				System.exit(-1);
    			}
    		} else {
    			printUsage();
				System.exit(-1);
    		}
    	}
    }
    
    private static void printUsage() {
    	System.out.println("java -jar VMClient.jar [-a <server-adress>] [-p <port>] [-f <path-to-folder>] [-n <number-of-files-to-expect>] [-w <waiting-time>]");
    }
}




