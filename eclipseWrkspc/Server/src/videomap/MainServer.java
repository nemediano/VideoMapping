package videomap;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;


public class MainServer {
    
    //final static String INET_ADDR = "224.0.0.3";
    final static int PORT = 8888;

    public static void main(String[] args) throws InterruptedException, IOException {
        // Get the address that we are going to connect to.
        //InetAddress addr = InetAddress.getByName(INET_ADDR);
    	
        File[] files = getExistingFiles();
        FileInputStream fis = null;
        BufferedInputStream bis = null;
        //Socket socket = null;
        ServerSocket server = new ServerSocket(PORT);
        OutputStream os = null;
        // Open a new DatagramSocket, which will be used to send the data.
        //try (DatagramSocket serverSocket = new DatagramSocket()) {
        try (Socket socket = server.accept()) {
        	System.out.println("Accepted connection : " + socket);
            for (int i = 0; i < files.length; i++) {
                // Create a packet that will contain the data
                // (in the form of bytes) and send it.
                byte[] memChunk = new byte[(int) files[i].length()];
                fis = new FileInputStream(files[i]);
                bis = new BufferedInputStream(fis);
                bis.read(memChunk,0,memChunk.length);
                os = socket.getOutputStream();
                System.out.println("About to send file: " + files[i].getName() +  " (" + memChunk.length + ")");
                //DatagramPacket msgPacket = new DatagramPacket(memChunk,
                //		memChunk.length, addr, PORT);
                os.write(memChunk, 0, memChunk.length);
                os.flush();
                System.out.println("Done");
                Thread.sleep(500);
            }
        } catch (IOException ex) {
            ex.printStackTrace();
        } finally {
        	if (server != null) server.close();
        	if (os != null) os.close();
        }
    }
    
    public static File[] getExistingFiles() {
    	File curDir = new File("data/");
    	File[] filesList = curDir.listFiles();
    	
		return filesList;
    }

    public static boolean sendFile(File file) {
    	return true;
    }
}


