void spyro(){
  
  //background(20);
  stroke(255);
  strokeWeight(2);
  pushMatrix();
  translate(width/2, height/2);
  for (int i = 0; i < (val3*0.2); i++) {
    line (x1(t + i), y1(t + i), x2(t + i), y2(t + i));
    
   
  }
  popMatrix();
   t+= 0.001*val2; //MINIG adjusts speed
}

float x1(float t) {
  return sin(t / 10) * 500 + sin(t / 25) * 200;
}

float y1(float t) {
  return cos(t / 10) * 500;
}

float x2(float t) {
  return sin(t / 10) * 75 + sin(t / 12) * 100;
}

float y2(float t) {
  return cos(t / 20) * 100;
}
