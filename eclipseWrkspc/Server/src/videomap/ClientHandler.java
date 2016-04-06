package videomap;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.Socket;

public class ClientHandler {
	private Socket conection;
	private int nextFile;
	private int totalFiles;
	
	public ClientHandler(Socket conection) {
		if (conection != null) {
			this.conection = conection;
		}
		setTotalFiles(2);
		
	}
	
	public ClientHandler(Socket conection, int totalFiles) {
		if (conection != null) {
			this.conection = conection;
		}
		setTotalFiles(totalFiles);
		
	}
	
	public boolean sendFile(File file) throws IOException {
		if (!file.isFile() || !file.canRead()) {
			System.out.println("Could not read the file: " + file.getAbsolutePath());
			return false;
		}
		//Prepare to send
		byte[] memChunk = new byte[(int) file.length()];
        FileInputStream fis = new FileInputStream(file);
        BufferedInputStream bis = new BufferedInputStream(fis);
        bis.read(memChunk,0,memChunk.length);
        OutputStream os = conection.getOutputStream();
        
        //Send
        os.write(memChunk, 0, memChunk.length);
        os.flush();
		//Register the send
        incrementCounter();
		
        //Clean
		os.close();
		bis.close();
		fis.close();
		
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
