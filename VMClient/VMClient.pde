import processing.net.*;
// Declare a client
Client client;

// The data we will read from the server
byte[] byteBuffer;
// The image buffer ofr the data
PImage[] images;
int currentImage = 0;
int currentSavedImage = 1;
int imagesNumber = 2;
PImage textureMap;
int imgSize = 32;
boolean haveServer = false;
boolean allocateImageBuffer = false;
//For controlling the rotation
float rotx = 0.0;
float roty = 0.0;

void setup() {
  size(600, 360, P3D);
  // Create the Client
  client = new Client(this, "127.0.0.1", 5204);
  colorMode(RGB, 255);
  textureMode(NORMALIZED);
  noStroke();
  frameRate(24);
  //Image to show if there is no server
  textureMap =  loadImage("test.jpg");
  
}

void draw() {
  
  background(0);
  translate(width / 2.0, height / 2.0, -100.0);
  rotateX(rotx);
  rotateY(roty);
  scale(90.0);
  int desiredSize = imgSize * imgSize * 3;
  if (haveServer) {
    grabImage();
    drawShape(images[currentImage]);
  } else {
    drawShape(textureMap);
  }
}

void grabImage() {
  int byteCount = 0;
  byteCount = client.readBytes(byteBuffer);
  int desiredSize = imgSize * imgSize * 3;
  if (byteCount == desiredSize) {
    println("Image data received!!");
    writeImage();
    //Increment the number of saved images
    currentSavedImage = (currentSavedImage + 1) % imagesNumber;
    currentImage = (currentImage + 1) % imagesNumber;
  } else {
    println("Incomplete image data received");
  }
}

// Let's look at this with the client event callback function
void clientEvent(Client client) {
  
  if (!allocateImageBuffer) {
    images = new PImage[imagesNumber];
    println("We created the images array of size: " + images.length);
    for (int i = 0; i < images.length; ++i) {
      images[i] = createImage(imgSize, imgSize, RGB);
      println("We allocated the images array");
    }
    //Allocate memorry for the byte buffer to store images
    byteBuffer = new byte[imgSize * imgSize * 3];
    allocateImageBuffer = true;
    return;
  }
  
  haveServer = true;
}

/* Update the currentSaved image using the data in byteBuffer */
void writeImage() {
  color c = color(255, 0, 0);
  int dimensions = imgSize * imgSize;
  println("before load pixels");
  images[currentSavedImage].loadPixels();
  println("after load pixels");
  int r = 0, g = 0, b = 0;
  int j = 0;
  println("Number of pixels:" + images[currentSavedImage].pixels.length);
  for (int i = 0; i < dimensions; ++i) {
    r = byteBuffer[j++] + 128;
    g = byteBuffer[j++] + 128;
    b = byteBuffer[j++] + 128;
    //println("R = " + r + " G = " + g + "B = " + b);
    c = 0xFF000000 | (r << 16) | (g << 8) | b;
    images[currentSavedImage].pixels[i] = c;
  }
  images[currentSavedImage].updatePixels();
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

