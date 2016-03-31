package videomap;

import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.net.Inet4Address;
import java.net.ServerSocket;
import java.net.UnknownHostException;
import java.util.regex.Pattern;

public class ImageServer {
	private int port;
	private String address;
	private String pattern;
	private File folder;
	private ServerSocket socket;
	private File[] filesToSend;
	private int clients;
	
	public ImageServer(String address, int port, String folder) {	
		setAddress(address);
		setPort(port);
		setFolder(folder);
		clients = 0;
	}
	
	public ImageServer(String folder) {
		try {
			setAddress(Inet4Address.getLocalHost().getHostAddress());
		} catch (UnknownHostException e) {
			System.out.println("Invalid adress");
			e.printStackTrace();
		}
		setPort(8888);
		setFolder(folder);
		clients = 0;
	}
	
	public ImageServer() {
		try {
			setAddress(Inet4Address.getLocalHost().getHostAddress());
		} catch (UnknownHostException e) {
			System.out.println("Invalid adress");
			e.printStackTrace();
		}
		setPort(8888);
		setFolder("data" + File.separatorChar);
		clients = 0;
	}

	public boolean hasConnections() {
		return clients != 0;
	}
	
	public int getClientsNumber() {
		return clients;
	}
	
	public void start() {
		try {
			socket = new ServerSocket(port);
		} catch (IOException e) {
			System.out.println("Could not create server...");
			e.printStackTrace();
		}
	}
	
	public void stop() {
		try {
			socket.close();
		} catch (IOException e) {
			System.out.println("Could not close the server...");
			e.printStackTrace();
		}
	}
	
	public int getPort() {
		return port;
	}
	
	public String getAddress() {
		return address;
	}
	
	public String getFolder() {
		return folder.getAbsolutePath();
	}
	
	public String getPattern() {
		return pattern;
	}
	
	private void setPort(int port) {
		if (port > 1024 && port < 65000) {
			this.port = port;
		}
	}
	
	private void setAddress(String addres) {		
		final String IPADDRESS_PATTERN = 
				"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\." +
				"([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\." +
				"([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\." +
				"([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
		final Pattern pattern = Pattern.compile(IPADDRESS_PATTERN);
	    if (pattern.matcher(addres).matches()) {
	        this.address = addres;
	    }
	}
	
	private void setFolder (String folder) {
		File file = new File(folder);
		if (file.exists() && file.canRead()) {
			this.folder = new File(folder);
		}
	}
	
	public void setPattern(String pattern) {
		this.pattern = pattern;
	}
	
	private void updateFileList() {
		if (folder.isDirectory()) {
			filesToSend = folder.listFiles(IMAGE_FILTER);
		}
	}
	
	static final FilenameFilter IMAGE_FILTER = new FilenameFilter() {
		final String[] EXTENSIONS = new String[]{
		        "jpg", "png" // and other formats you need
		    };
        @Override
        public boolean accept(final File dir, final String name) {
            for (final String ext : EXTENSIONS) {
                if (name.endsWith("." + ext)) {
                    return (true);
                }
            }
            return (false);
        }
    };
    //In bytes, the default is quarter MB
    static final int chunkSize = 1024 * 1024 / 4; 
}
