Read Me

The order to start the programs:

1.- Start Processing server, to populate the data folder. Before start check the outputs and check also the queue size.

2.- Start the java Server
	java -jar VMServer.jar
	Or (Number of milisecond to wait)
	java -jar VMServer.jar -w 40

	Before start check that:
		1.- Data folder is populated
		2.- jar file is located on the parent folder of the data Folder
		
3.- On the client machine start the Java Client (n is the queue size for the client)
	java -jar VMClient.jar -n 20
	Wait to see if they sincronize at least two cycles (If they don't restart, change queue size)


4.- Start Processing client on the client machine (use Processing 3, preferable)
Before start make sure:
	1.- Java client is stable
	2.- data folder exist and have a failSafe.png image
	3.- Queue size coincides with the number pass on java Client
	4.- data is populated

	
To compile java programs w/o using Eclipse (Example using Server, change name for Client)
	1.- Navigate to src directory
	2.- Compile
		javac videomap/*.java
	3.- Create jar (No manifest needed method)
		jar cvfe VMServer.jar videomap.MainServer videomap/*.class
	4.- Move jar to the corresponding directory
		mv VMServer.jar ../../../VMServer
		

	