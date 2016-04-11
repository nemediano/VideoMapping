void ripples(){
  if ( key == 'g' )noFill();
 pushMatrix();
  translate(0,frameCount%120,val2);
  for (int i=-100; i<=width; i+=60){
  pushMatrix();
  beginShape();
  translate(0,i);
    vertex(A.x,A.y);
    vertex(B.x,B.y);
    vertex(C.x,C.y);
    vertex(D.x,D.y);
    vertex(E.x,E.y);
    vertex(F.x,F.y);
  endShape();
  popMatrix();
  }
  popMatrix();
}
