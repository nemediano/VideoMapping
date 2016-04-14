void room(){
  background(val2);
  fill(val3%255,120,val1%255,90);
   beginShape();
       vertex(0,0,-val3);
       vertex(0,height,-val3);
       vertex(width,height,-val3);
       vertex(width,0,-val3);
      endShape();
      
      fill(val3%255,230,val1);
   beginShape();
       vertex(width,0,0);
       vertex(width,0,-val3);
       vertex(width,height,-val3);
       vertex(width,height,0);
    endShape();
    
    beginShape();
       vertex(0,0,0);
       vertex(0,0,-val3);
       vertex(0,height,-val3);
       vertex(0,height,0);
    endShape();
      
   

}
