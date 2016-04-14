import processing.opengl.*;
//import cc.arduino.*;
import processing.serial.*;
import processing.net.*;

Server myServer;
boolean haveClients = false;
//Arduino arduino;

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

//Package for the net
NetworkPackage netPackage = new NetworkPackage();

void setup(){
size(350,350,OPENGL);

  if (andruinoThere) {
//     arduino = new Arduino(this, Arduino.list()[5], 57600);
//     arduino.pinMode(Xcv[0], Arduino.INPUT);
//     arduino.pinMode(Ycv[0], Arduino.INPUT);
//     arduino.pinMode(Xcv[1], Arduino.INPUT);
//     arduino.pinMode(Xcv[2], Arduino.INPUT);
//     arduino.pinMode(Ycv[1], Arduino.INPUT);
//     arduino.pinMode(Ycv[2], Arduino.INPUT);
  }
  myServer = new Server(this, 5204);
  
  stroke(255);
  strokeWeight(0.5);
  A = new PVector(0, 44);
  B = new PVector(142, 44);
  C = new PVector(142, 0);
  D = new PVector(370, 0);
  E = new PVector(370, 44);
  F = new PVector(512, 44);
  frameRate(24);
}

void draw(){
   lights();
  
    
  ambientLight(val3%255,val2%255,val1%255);
  //assign minigorille or noise variables
   if (andruinoThere) { // adjust ranges again?
//   val1=map(arduino.analogRead(Xcv[0]), 0, 1023, 0, height);//ambient
//   val3=map(arduino.analogRead(Ycv[0]), 0, 500, 10, height); //percussive
//    val2=map(noise(xoff), 0, 1, 0,val3); //noise version of val3
//    val4=map(arduino.analogRead(Xcv[1]), 0, 1023, 10, height);
  }
  if (!andruinoThere){ 
    val2=map(noise(xoff), 0, 1, 0,220);
    val1=int(random(250,height)); 
    val3=map(noise(xoff), 0, 1, 0,550);
    val4=map(noise(yoff), 0, 1, 0,550);
    
    //Enviar variables al cliente
    int values[] = new int[11];
    values[0] = int(val1);
    values[1] = int(val2);
    values[2] = int(val3);
    values[3] = int(val4);
    values[4] = int(backy);
    values[5] = int(scene1);
    values[6] = int(scene2);
    values[7] = int(scene3);
    values[8] = int(scene4);
    values[9] = int(scene5);
    values[10] = int(scene6);
    netPackage.setValues(values);
    netPackage.print();
    myServer.write(netPackage.getData());
  }
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
  tint(255,255,255,alphavid);
  
  tint(255,255,255,255);
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

// The serverEvent function is called whenever a new client connects.
void serverEvent(Server server, Client client) {
  println(" A new client has connected: "+ client.ip());
  haveClients = true;
}
