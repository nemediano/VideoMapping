package videomap;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.Socket;

public class MainClient {
    
    final static String INET_ADDR = "127.0.0.1";
    final static int PORT = 8888;

    public static void main(String[] args) throws IOException {
        
        // Create a buffer of bytes, which will be used to store
        // the incoming bytes containing the information from the server.
        // We will try a half MB Image 500KB
        byte[] buf = new byte[512 * 1024];
        FileOutputStream fos = null;
        BufferedOutputStream bos = null;
        int filesCount = 0;
        // Create a new Multicast socket (that will allow other sockets/programs
        // to join it as well.
        try (Socket clientSocket = new Socket(INET_ADDR, PORT)){
            System.out.println("Connecting...");
            //while (true) {
            for (int i = 0; i < 2; ++i) {
            	String filename = "data" + File.separatorChar + "image" + filesCount + ".png";
                // Receive the information in buffer
                InputStream is = clientSocket.getInputStream();
                fos = new FileOutputStream(filename);
                bos = new BufferedOutputStream(fos);
                int bytesRead = is.read(buf, 0, buf.length);
                int current = bytesRead;
                //Recreate file 
                do {          	
                	bytesRead = is.read(buf, current, buf.length - current);
                	if (bytesRead >= 0) current += bytesRead;
                } while(bytesRead > -1);
                
                bos.write(buf, 0, current);
                bos.flush();
                //String msg = new String(buf, 0, buf.length);
                System.out.println("Received file: " + filename + " (" + current + ")");
            }
        } catch (IOException ex) {
            ex.printStackTrace();
        } finally {
			if (bos != null) bos.close();
			if (fos != null) fos.close();
			//if (clientSocket != null) clientSocket.close();
		}
    }
}



