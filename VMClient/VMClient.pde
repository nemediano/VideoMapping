import processing.net.*;
// Declare a client
Client client;

// The data we will read from the server
byte[] byteBuffer;
// The image buffer ofr the data
PImage[] images;
int currentImage;
int imagesNumber;
PImage textureMap;

//For controlling the rotation
float rotx = 0.0;
float roty = 0.0;

void setup() {
  size(600, 360, P3D);
  // Create the Client
  //client = new Client(this, "127.0.0.1", 5204);
  currentImage = 0;
  imagesNumber = 3;
  //rectMode(CENTER);
  colorMode(RGB, 255);
  textureMode(NORMALIZED);
  frameRate(15);
  noStroke();
}

void draw() {
  textureMap =  loadImage("test" + str(currentImage) + ".png");
  background(0);
  translate(width / 2.0, height / 2.0, -100.0);
  rotateX(rotx);
  rotateY(roty);
  scale(90.0);
  drawShape(textureMap);
  currentImage = (currentImage + 1) % imagesNumber;
}

// Let's look at this with the client event callback function
void clientEvent(Client client) {
  int byteCount = 0;
  byteCount = client.readBytes(byteBuffer);
}


void mouseDragged() {
  float rate = 0.01;
  rotx += (pmouseY-mouseY) * rate;
  roty += (mouseX-pmouseX) * rate;
}

void drawShape(PImage textMap) {
  beginShape(QUADS);
    texture(textMap);
    vertex(-1, -1,  0, 0, 0);
    vertex( 1, -1,  0, 1, 0);
    vertex( 1,  1,  0, 1, 1);
    vertex(-1,  1,  0, 0, 1);
  endShape();
}
