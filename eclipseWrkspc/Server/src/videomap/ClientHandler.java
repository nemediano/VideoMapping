package videomap;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.Socket;

public class ClientHandler {
	private Socket conection;
	private int nextFile;
	private int totalFiles;
	
	public ClientHandler(Socket conection) {
		if (conection != null) {
			this.conection = conection;
		}
		setTotalFiles(4);
	}
	
	public ClientHandler(Socket conection, int totalFiles) {
		if (conection != null) {
			this.conection = conection;
		}
		setTotalFiles(totalFiles);
		
	}
	
	public boolean sendFile(File file) throws IOException {
		BufferedInputStream bis = null; //To read file from HD
		DataOutputStream dos = null; //For sending file over the network
		
		if (!file.isFile() || !file.canRead()) {
			System.out.println("Could not read the file: " + file.getAbsolutePath());
			return false;
		}
		//Prepare to send
		byte[] memChunk = new byte[(int) file.length()];
        bis = new BufferedInputStream(new FileInputStream(file));
        bis.read(memChunk,0,memChunk.length);
        dos = new DataOutputStream(new BufferedOutputStream(conection.getOutputStream()));
        
        //Send
        //First send the file size 
        dos.writeLong(file.length());
        dos.flush();
        //Now send the file
        dos.write(memChunk, 0, memChunk.length);
        dos.flush();
		//Register the file you just send, advance counter
        incrementCounter();
		
        //Clean
		bis.close();
		
		return true;
	}
	
	private void incrementCounter() {
		nextFile++;
		nextFile %= totalFiles;
	}
	
	public int nextElement() {
		return nextFile;
	}
	
	public void disconect() throws IOException {
		conection.close();
	}
	
	public void setTotalFiles(int filesNumber) {
		if (filesNumber > 0) {
			this.totalFiles = filesNumber;
		}
	}
}
