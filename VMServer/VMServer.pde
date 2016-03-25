// Example 19-3: Server broadcasting a number (0-255)

// Import the net libraries
import processing.net.*;

// Declare a server
Server server;
int data = 0;
int imgSize = 512;
int bufferSize;
PImage[] frames;
int currentFrame;


void setup() {
  size(imgSize, imgSize);
  frameRate(1);
  // Create the Server on port 5204
  server = new Server(this, 5204);
  currentFrame = 0;
  bufferSize = 3;
  frames = new PImage[bufferSize];
  for (int i = 0; i < frames.length; ++i) {
    frames[i] = createImage(imgSize, imgSize, RGB);
  }
  
}

void draw() {
  background(255);
  // Display data
  textAlign(CENTER);
  textSize(64);
  fill(0);
  text(data, width/2, height/2);
  data++;
  //Load pixels from the frame
  loadPixels();
  int dimension = imgSize * imgSize;
  //Load pixels for the image objects
  frames[currentFrame].loadPixels();
  for (int i = 0; i < dimension; i++) { 
    frames[currentFrame].pixels[i] = pixels[i]; 
  } 
  frames[currentFrame].updatePixels();
  frames[currentFrame].save("test" + currentFrame + ".png");
  currentFrame = (currentFrame + 1) % bufferSize;
  //server.write(data);
}

// The serverEvent function is called whenever a new client connects.
void serverEvent(Server server, Client client) {
  println(" A new client has connected: "+ client.ip());
}




