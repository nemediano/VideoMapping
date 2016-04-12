//import cc.arduino.*;
//import processing.serial.*;
import processing.opengl.*;
//import codeanticode.gsvideo.*;

//Arduino arduino;
//GSCapture cam;
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
float val1,val2,val3,val4;


//For the image server
int QUEUE_SIZE = 20;
int currentFrame;
String baseName = "data/image-";
int imgSize = 400;

void setup(){
  size(imgSize,imgSize,OPENGL);
  frameRate(24);
  //cam = new GSCapture(this, 640, 480);
  //cam.start();
  
  if (andruinoThere) {
     //arduino = new Arduino(this, Arduino.list()[5], 57600);
     //arduino.pinMode(Xcv[0], Arduino.INPUT);
     //arduino.pinMode(Ycv[0], Arduino.INPUT);
     //arduino.pinMode(Xcv[1], Arduino.INPUT);
     //arduino.pinMode(Xcv[2], Arduino.INPUT);
     //arduino.pinMode(Ycv[1], Arduino.INPUT);
     //arduino.pinMode(Ycv[2], Arduino.INPUT);
  }
  
  stroke(255);
  strokeWeight(0.5);
  A = new PVector(0, 44);
  B = new PVector(142, 44);
  C = new PVector(142, 0);
  D = new PVector(370, 0);
  E = new PVector(370, 44);
  F = new PVector(512, 44);
  
  currentFrame = 0;
}

void draw(){
   lights();
   //cam.read();
    
  ambientLight(val3%255,val2%255,val1%255);
  //assign minigorille or noise variables
   if (andruinoThere) { // adjust ranges again?
    //val1=map(arduino.analogRead(Xcv[0]), 0, 1023, 0, height);//ambient
    //val3=map(arduino.analogRead(Ycv[0]), 0, 1023, 10, height); //percussive
    //val2=map(noise(xoff), 0, 1, 0,val3); //noise version of val3
    //val4=map(arduino.analogRead(Xcv[1]), 0, 1023, 10, height);
  }
  if (!andruinoThere){ 
    val2=map(noise(xoff), 0, 1, 0,220);
    val1=int(random(250,height)); 
    val3=map(noise(xoff), 0, 1, 0,550);
    val4=map(noise(yoff), 0, 1, 0,550);
  }
  if(backy){
   //noStroke();
   //fill(0);
   //rect(0,0,width,height);
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
  tint(255,255,255,alphavid);
  //image(cam, 0, 0,width,height);
  
  tint(255,255,255,255);
  text(alphavid,100,100);
  
  //Saving the frame to HD
  save(baseName + nf(currentFrame, 2) + ".jpg");
  currentFrame++;
  currentFrame %= QUEUE_SIZE;
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
  if ( key == 'z' )backy = !backy;
  
  if (keyCode == UP) {
     alphavid+=2; 
     if (alphavid>255) {
        alphavid=255;
     }
  }
  if (keyCode == DOWN) {
     alphavid-=2; 
     if (alphavid<0) {
       alphavid=0;
     }
  }

}

