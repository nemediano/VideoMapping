package videomap;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.net.Socket;
import java.nio.channels.FileChannel;
import java.nio.channels.FileLock;
import java.nio.channels.OverlappingFileLockException;


public class ClientHandler extends Thread {
	private Socket conection;
	private int nextFile;
	private int totalFiles;
	private File[] filesToSend;
	private int waitTime;
	
	public ClientHandler(Socket conection) {
		super("VM Image server thread");
		if (conection != null) {
			this.conection = conection;
		}
		setTotalFiles(2);
		setWaitTime(40);
	}
	
	public ClientHandler(Socket conection, int totalFiles) {
		super("VM Image server thread");
		if (conection != null) {
			this.conection = conection;
		}
		setTotalFiles(totalFiles);
		setWaitTime(200);
	}
	
	public void run () {
		while (true) {
			try {
				this.nextElement();		
				this.sendFile(filesToSend[nextFile]);
				Thread.sleep(waitTime);
				
			} catch (Exception e) {
				System.out.println("Client got disconected!");
				try {
					this.conection.close();
				} catch (IOException e1) {
					System.out.println("Could not close connection!");
					//e1.printStackTrace();
				}
				System.out.println(e.getMessage());
				//e.printStackTrace();
				break;
			}
		}
	}
	
	public void setFilesToSend(File[] filesToSend) {
		if (filesToSend != null && filesToSend.length != 0 ) {
			this.filesToSend = filesToSend;
		}
	}
	
	public boolean sendFile(File file) throws IOException {
		BufferedInputStream bis = null; //To read file from HD
		DataOutputStream dos = null; //For sending file over the network
		//DataInputStream dis = null; //For receiving the client recipe
		
		String tmpFileName;
		File tmpFile;
		if (!file.isFile() || !file.canRead()) {
			System.out.println("Could not read the file: " + file.getAbsolutePath());
			return false;
		} else { 
			//Lock the file copy it and unlocked
			try {
				@SuppressWarnings("resource")
				FileChannel channel = new RandomAccessFile(file, "rw").getChannel();
		        // Use the file channel to create a lock on the file.
		        // This method blocks until it can retrieve the lock.
		        FileLock lock = channel.lock();
		        try {
		            lock = channel.tryLock();
		        } catch (OverlappingFileLockException e) {
		            // File is already locked in this thread or virtual machine
		        }
		        
		        tmpFileName = file.getAbsolutePath().substring(0, file.getAbsolutePath().length() - 4) + ".tmp";
		        tmpFile = new File(tmpFileName);
		        copyFile(file, tmpFile);
		        // Release the lock - if it is not null!
		        if( lock != null ) {
		            lock.release();
		        }
		        
		        // Release the lock - if it is not null!
		        if( lock != null ) {
		            lock.release();
		        }
	
		        // Close the file
		        channel.close();
			} catch (IOException e) {
				System.out.println("Could not lock file: " + file.getAbsolutePath());
				return false;
			}
		}
		
		//Prepare to send the tmp file
		byte[] memChunk = new byte[(int) tmpFile.length()];
        bis = new BufferedInputStream(new FileInputStream(tmpFile));
        
        bis.read(memChunk,0,memChunk.length);
        dos = new DataOutputStream(new BufferedOutputStream(conection.getOutputStream()));
        //dis = new DataInputStream(new BufferedInputStream(conection.getInputStream()));
        //Send
        //First send the file size 
        dos.writeLong(file.length());
        dos.flush();
        //Now send the file
        dos.write(memChunk, 0, memChunk.length);
        dos.flush();
        
        int status = 1;
        
        //status = dis.readInt();
        
        if (status == 1) {
        	incrementCounter();
        } else {
        	System.out.println("Client lost the file");
        }
        
  
        //Clean
		bis.close();
		tmpFile.delete();
		
		return true;
	}
	
	@SuppressWarnings("resource")
	private void copyFile(File sourceFile, File destFile) throws IOException {
	    if(!destFile.exists()) {
	        destFile.createNewFile();
	    }

	    FileChannel source = null;
	    FileChannel destination = null;

	    try {
	        source = new FileInputStream(sourceFile).getChannel();
	        destination = new FileOutputStream(destFile).getChannel();
	        destination.transferFrom(source, 0, source.size());
	    }
	    finally {
	        if(source != null) {
	            source.close();
	        }
	        if(destination != null) {
	            destination.close();
	        }
	    }
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
	
	public void setWaitTime(int miliseconds) {
		if (miliseconds > 0) {
			this.waitTime = miliseconds;
		}
	}
}
