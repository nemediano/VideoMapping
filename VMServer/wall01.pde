void wall01(){
  
  //background(0);
  noFill();
  pushMatrix();
  strokeWeight(2);
  stroke(255);
  translate(0,frameCount%150);
  for (int i=-500; i<=height; i+=150){
  pushMatrix();
  translate(0,i);
  beginShape();
  vertex(0,0);
  bezierVertex(154,0,328,200,306,170+val4);
  vertex(width,100);
  endShape();
  
  popMatrix();
}
popMatrix();
}
