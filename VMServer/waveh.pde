void waveh(){
  beginShape(); 
  for (float x = 0; x <= width+1; x += 1) { // increment in x sample arduino is 0.007
    fill(201,val2,34);
    vertex(x,val3);
  }
    fill(240,206,34);
    vertex(width, height);
    fill(map(val1,0,350,0,255),134,145);
    fill(67,245,210);
    vertex(0, height);
    endShape();
    
    //shape2
    fill(2,206,map(val1,0,350,0,255));
    pushMatrix();
    translate(val2,0);
    beginShape(); 
    for (float i = 0; i <= width; i += 1) { // increment in x sample arduino is 0.007
      vertex(i,val1);
    }
    fill(250,2,134);
    //vertex(width, height);
    fill(map(val1,0,350,0,255),78,145);
    vertex(0, height);
    endShape(CLOSE);
    popMatrix();

}


