package videomap;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
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
	private byte[] buffer;
	private static int BUFFER_SIZE = (int) (1024 * 1024 * 1.5);
	
	public ImageClient(String address, int port, String folder, int totalFiles, String baseName) {
		setAddress(address);
		setPort(port);
		setFolder(folder);
		setNumFiles(totalFiles);
		setBaseName(baseName);
		currentFile = 0;
		clientSocket = null;
		buffer = new byte[BUFFER_SIZE];
	}
	
	public ImageClient(String address, int port) {
		setAddress(address);
		setPort(port);
		setFolder("data" + File.separatorChar);
		setNumFiles(2);
		setBaseName("img-");
		currentFile = 0;
		clientSocket = null;
		buffer = new byte[BUFFER_SIZE];
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
	
	public void receiveFile() {
		this.receiveNextFile();
//		try {
//			Thread.sleep(40);
//		} catch (InterruptedException e) {
//			System.out.println("Could not stop this thread");
//			//e.printStackTrace();
//		}
		this.advanceToNextFile();
	}
	
	private void receiveNextFile() {
		//To write the file into the HD
		BufferedOutputStream bos = null;
		//For receiving the file from server
		DataInputStream dis = null;
		//For making sure at writing
		String tempFilename = getFileName().substring(0, getFileName().lastIndexOf('.')) + ".tmp";
		
		//If the next file exist remove it
		{
			File test = new File(getFileName());
			if (test.exists()) {
				test.delete();
			}
		}
		
		
		//Open stream for this file
		try {
			if (this.clientSocket == null) {
				System.out.println("Something very wrong! Did you connect first?");
			}
			dis = new DataInputStream(new BufferedInputStream(this.clientSocket.getInputStream()));
			bos = new BufferedOutputStream(new FileOutputStream(tempFilename));
		} catch (IOException e) {
			System.out.println("Error trying to receive file: " + getFileName());
			e.printStackTrace();
		}
		
		//Receive the file
		try {
			long fileSize = dis.readLong();
			int currentBytesRead = 0;
			int bytesRead = 0;
			//Read the file by chunks
			do {
				bytesRead = dis.read(buffer, currentBytesRead, Math.min(this.buffer.length - currentBytesRead, (int)fileSize - currentBytesRead));
				if (bytesRead >= 0) {
					currentBytesRead += bytesRead;
				}
			} while(currentBytesRead < fileSize);
						
	        //Write file into the HD
	        bos.write(this.buffer, 0, currentBytesRead);
	        bos.flush();
		} catch (Exception e) {
			System.out.println("Error trying to receive file");
			//e.printStackTrace();
		}
		
		
		//Closing stream for this file
		try {
			bos.close();
			//Make sure that this file is finished
			File tmp = new File(tempFilename);
			if (tmp.renameTo(new File(getFileName()))) {
				System.out.println("File received: " + getFileName());
			}
		} catch (IOException e) {
			System.out.println("Error trying to close or writtin the current file");
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
		return this.getFolder() + File.separatorChar + this.basename + String.format("%03d", currentFile) + ".jpg";
	}
	
	private void advanceToNextFile() {
		this.currentFile++;
		this.currentFile %= this.numFiles;
	}
	
	public String getInfo() {
		String s = "Pointing at folder: " + this.folder.getAbsolutePath()
		+ "\nExpecting " + this.numFiles + " files";
		
		return s;
	}
	
	public boolean terminate() {
		return false;
	}
}
