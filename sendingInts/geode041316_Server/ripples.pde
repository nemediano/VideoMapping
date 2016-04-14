void ripples(){
  if ( key == 'g' )noFill();
 pushMatrix();
  translate(0,frameCount%120,val2*0.8);
  for (int i=-168; i<=width+160; i+=80){
  pushMatrix();
  beginShape();
  scale(0.7);
  translate(4,i);
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
