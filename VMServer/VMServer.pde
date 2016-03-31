import processing.net.*;

// Declare a server
Server server;
int data = 0;
int imgSize = 64;
int bufferSize;
byte[][] frames;
int currentFrame;
boolean haveClients;

void setup() {
  size(imgSize, imgSize);
  frameRate(15);
  colorMode(RGB, 255);
  // Create the Server on port 5204
  server = new Server(this, 5204);
  currentFrame = 0;
  bufferSize = 3;
  frames = new byte[bufferSize][imgSize * imgSize * 3];
  haveClients = false;
}

void draw() {
  /*********************************************/
  /* Here we produce the frame we want to save */
  /*********************************************/
  background(255);
  // Display data
  textAlign(CENTER);
  textSize(20);
  fill(0);
  text(data, width/2, height/2);
  data++;
  /*********************************************/
  /*********************************************/
  
  if (haveClients) {
    //We grab the current screen
    grabScreen();
    //We send the buffer. The frame we just grab
    server.write(frames[currentFrame]);
    //We tried to wrote:
    //println("We send " + frames[currentFrame].length + "bytes");
    //We increment the buffer counter
    currentFrame = (currentFrame + 1) % bufferSize;
  }

}

void grabScreen() {
  //Load pixels from the frame
  loadPixels();
  int dimension = imgSize * imgSize;
  //Load pixels for the image objects
  int j = 0;
  for (int i = 0; i < dimension; i++) { 
    // Using "right shift" as a faster method than red(), green(), and blue()
    color argb = pixels[i];
    //int a = (argb >> 24) & 0xFF;
    int r = (argb >> 16) & 0xFF;  // Faster way of getting red(argb)
    int g = (argb >> 8) & 0xFF;   // Faster way of getting green(argb)
    int b = argb & 0xFF;          // Faster way of getting blue(argb)
    
    frames[currentFrame][j++] = byte(r);
    frames[currentFrame][j++] = byte(g); 
    frames[currentFrame][j++] = byte(b);
  }
}

// The serverEvent function is called whenever a new client connects.
void serverEvent(Server server, Client client) {
  println(" A new client has connected: "+ client.ip());
  haveClients = true;
}




