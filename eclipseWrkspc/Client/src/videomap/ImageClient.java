package videomap;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.regex.Pattern;

public class ImageClient {
	
	private String address;
	private int port;
	private File folder;
	private int numFiles;
	private String basename;
	private int currentFile;
	private Socket clientSocket;
	private byte[] memChunck;
	private static int CHUNK_SIZE = (int) (1024 * 1024 * 0.5);
	
	public ImageClient(String address, int port, String folder, int totalFiles, String baseName) {
		setAddress(address);
		setPort(port);
		setFolder(folder);
		setNumFiles(totalFiles);
		setBaseName(baseName);
		currentFile = 0;
		clientSocket = null;
		memChunck = new byte[CHUNK_SIZE];
	}
	
	public ImageClient(String address, int port) {
		setAddress(address);
		setPort(port);
		setFolder("data" + File.separatorChar);
		setNumFiles(2);
		setBaseName("img-");
		currentFile = 0;
		clientSocket = null;
		memChunck = new byte[CHUNK_SIZE];
	}
	
	public void setPort(int port) {
		if (port > 1024 && port < 65000) {
			this.port = port;
		}
	}
	
	public void setAddress(String addres) {		
		final String IPADDRESS_PATTERN = 
				"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\." +
				"([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\." +
				"([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\." +
				"([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
		final Pattern pattern = Pattern.compile(IPADDRESS_PATTERN);
	    if (addres != null && pattern.matcher(addres).matches()) {
	        this.address = addres;
	    }
	}
	
	public void setFolder (String folder) {
		if (folder == null) {
			System.out.println("Invalid folder");
			return;
		}
		File file = new File(folder);
		if (file.exists() && file.isDirectory() && file.canWrite()) {
			this.folder = new File(folder);
		}
	}
	
	public void setNumFiles(int numberOfFiles) {
		if (numberOfFiles > 0) {
			this.numFiles = numberOfFiles;
		}
	}
	
	public void setBaseName (String basename) {
		if (basename != null && !basename.isEmpty()) {
			this.basename = basename;
		}
	}
	
	public void connect() {
		try {
			System.out.println("Connecting...");
			this.clientSocket = new Socket(address, port);
			System.out.println("Connection succeded!");
		} catch (UnknownHostException e) {
			System.out.println("Cannot locate the server: " + address);
			e.printStackTrace();
		} catch (IOException e) {
			System.out.println("Cannot shakle hands with the server: " + address);
			e.printStackTrace();
		}
	}
	
	public void receiveFiles() {
		//This should wait receiving files, 
		//for testing I'm just going to do a one pass off all the folder
		for (int i = 0; i < this.numFiles; ++i) {
			this.receiveNextFile();
		}
	}
	
	private void receiveNextFile() {
		FileOutputStream fos = null;
		BufferedOutputStream bos = null;
		InputStream is = null;
		
		//Open stream for this file
		try {
			is = clientSocket.getInputStream();
			fos = new FileOutputStream(getFileName());
			bos = new BufferedOutputStream(fos);
		} catch (IOException e) {
			System.out.println("Error trying to receive file: " + getFileName());
			e.printStackTrace();
		}
		
		//Read file by chunks
		try {
			int fileSize = 100;
			int bytesRead = is.read(this.memChunck, 0, memChunck.length);
	        int current = bytesRead;
	        //Recreate file 
	        do {          	
	        	bytesRead = is.read(this.memChunck, current, this.memChunck.length - current);
	        	if (bytesRead >= 0) current += bytesRead;
	        } while(bytesRead > -1);
	        
	        bos.write(this.memChunck, 0, current);
	        bos.flush();
		} catch (IOException e) {
			System.out.println("Error trying to receive file");
			e.printStackTrace();
		}
		
		
		//Closing stream for this file
		try {
			bos.close();
			fos.close();
		} catch (IOException e) {
			System.out.println("Error trying to close current file connection");
			e.printStackTrace();
		}
         
	}
	
	public String getAddress() {
		return this.address;
	}
	
	public int getPort() {
		return this.port;
	}
	
	public String getFolder() {
		return this.folder.getAbsolutePath();
	}
	
	public int getTotalFilesNumber() {
		return this.numFiles;
	}
	
	public String getBasename() {
		return this.basename;
	}
	
	private String getFileName() {
		return this.basename + String.format("%03d", currentFile);
	}
	
	private void advanceToNextFile() {
		this.currentFile++;
		this.currentFile %= this.numFiles;
	}
}
