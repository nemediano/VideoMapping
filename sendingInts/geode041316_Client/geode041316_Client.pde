import processing.opengl.*;
import processing.net.*;
Client myClient;
boolean haveServer = false;

PVector A,B,C,D,E,F;
PImage tex;
float t;
int alphavid;

float xoff, yoff;
int[]Xcv = {0, 2, 4, 2};
int[]Ycv= {1, 3, 5, 3};

boolean andruinoThere = false;
boolean backy = true;
boolean scene1 = true;
boolean scene2 = false;
boolean scene3 = false;
boolean scene4 = false;
boolean scene5 = false;
boolean scene6 = false;
int val1,val2,val3,val4;


//Package for the net
NetworkPackage netPackage = new NetworkPackage();
byte byteBuffer[] = new byte[netPackage.sizeExpected()];

void setup(){
size(350,350,OPENGL);

  myClient = new Client(this, "127.0.0.1", 5204); 
  
  stroke(255);
  strokeWeight(0.5);
  A = new PVector(0, 44);
  B = new PVector(142, 44);
  C = new PVector(142, 0);
  D = new PVector(370, 0);
  E = new PVector(370, 44);
  F = new PVector(512, 44);
  
}

void draw(){
   lights();
   if (myClient.available() > 0) { 
    // Acá quiero leer val1, val2, val3 y val4
    int desiredSize = netPackage.sizeExpected();
    int byteCount = 0;
    byteCount = myClient.readBytes(byteBuffer);
    if (byteCount == desiredSize) {
      netPackage.setData(byteBuffer);
      netPackage.print();
    }
    //In the same order that were written in the Server
    int values[] = netPackage.getValues();
    val1 = values[0];
    val2 = values[1];
    val3 = values[2];
    val4 = values[3];
    backy = boolean(values[4]);
    scene1 = boolean(values[5]);
    scene2 = boolean(values[6]);
    scene3 = boolean(values[7]);
    scene4 = boolean(values[8]);
    scene5 = boolean(values[9]);
    scene6 = boolean(values[10]);
  } 
  
    
    ambientLight(val3%255,val2%255,val1%255);
  
  if(backy){
  background(0,0,0,20);
    }
  
   smooth();
  if (scene1) page();
  if (scene2) waveh();
  if (scene3) ripples();
  if (scene4) wall01();
  if (scene5) spyro();
  if (scene6) room();
  
  
    
 
  xoff += random(-0.5,0.5);
  save("cross.png");
 
}

void keyPressed() {
  if ( key == '1' )scene1 = !scene1;
  if ( key == '2' )scene2 = !scene2;
  if ( key == '3' )scene3 = !scene3;
  if ( key == '4' )scene4 = !scene4;
  if ( key == '5' )scene5 = !scene5;
  if ( key == '6' )scene6 = !scene6;
  if ( key == 'a' )stroke(255);
  if ( key == 's' )noStroke();
  if ( key == 'd' )stroke(0);
  if ( key == 'f' )fill(val1,val2,val3);
  if (key == 'z')backy=!backy;
}

