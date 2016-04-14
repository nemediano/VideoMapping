void page(){  
  background(val1/2,191,135);
  beginShape();
  fill(201,98,frameCount%255);
  vertex(0,277);
  fill(201,val1/2,frameCount%255);
  bezierVertex(0,165,58,108,width/2,val3*1.3);
  bezierVertex(width,101,width,220,width,280);
  fill(201,18,242);
  vertex(width,height);
  fill(203,val2,209);
  vertex(0,height);
  endShape(CLOSE);
}
