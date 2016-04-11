void page(){  
  background(val1/2,191,135);
  beginShape();
  fill(201,98,frameCount%255);
  vertex(0,277+100);
  fill(201,val1/2,frameCount%255);
  bezierVertex(0,165,58,108,width/2,val3*1.3);
  bezierVertex(448,101,512,161,512,279+100);
  fill(201,18,242);
  vertex(width,height);
  fill(203,val2,209);
  vertex(0,height);
  endShape(CLOSE);
}
