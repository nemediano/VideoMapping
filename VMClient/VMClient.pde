import processing.opengl.*; 

PImage backBuffer;
PImage frontBuffer;

PImage textureMap;
PVector A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X;

//Related to the texture loading
int QUEUE_SIZE = 20;
int currentImage;
String baseName = "img-";

void setup(){
   
   size (800,600,OPENGL);
   A = new PVector(72, 55);
   B = new PVector(95,54);
   C = new PVector(162,15);
   D = new PVector(400,0);
   E = new PVector(520,20);
   F = new PVector(511,61);
   G = new PVector(431,181);
   H = new PVector(355,250);
   I = new PVector(59,245);
   J = new PVector(406,421);
   K = new PVector(67,421);
   L = new PVector(89,526);
   M = new PVector(190,561);
   N = new PVector(432,561);
   O = new PVector(634,532);
   P = new PVector(730,200);
   Q = new PVector(781,79);
   R = new PVector(781,31);
   S = new PVector(675,0);
   T = new PVector(616,0);
   U = new PVector(586,27);
   V = new PVector(755,485);
   W = new PVector(781,458);
   X = new PVector(781,319);
   //Texture coordinates are beetween [0, 1]
   textureMode(NORMAL);
   frameRate(10);
   //Clean the screen just at the begining for performance
   background(0);
   currentImage = 0;
   //back buffer load a fail safe image
   backBuffer = loadImage("failSafe.jpg");
}

void draw(){
  //Load a single texture per frame. The 3, is the number of digits in the image number format
  frontBuffer = loadImage(baseName + nf(currentImage, 3) + ".jpg");
  //Or fail some how, use previous frame
  if (frontBuffer == null) {
    if (backBuffer != null) {
      textureMap = backBuffer;
    } else {
      textureMap = loadImage("failSafe.jpg");
    }
  } else { //Use the frame you just got
    textureMap = frontBuffer;
  }
  
  
  //Image processing if needed
  //tint(255,255,255,200);
  
  /************/
  /* Shape  1 */
  /************/
  beginShape();
    texture(textureMap);
    vertex(A.x,A.y,0,1);
    vertex(B.x,B.y);
    vertex(C.x,C.y);
    vertex(D.x,D.y,0,0.3);
    vertex(E.x,E.y,0,0);
    vertex(F.x,F.y);
    vertex(G.x,G.y);
    vertex(H.x,H.y);
    vertex(I.x,I.y);
  endShape(CLOSE);
  
  /************/
  /* Shape  2 */
  /************/  
  beginShape();
    texture(textureMap);
    vertex(I.x,I.y,0,1);
    vertex(H.x,H.y,0,0);
    vertex(J.x,J.y);
    vertex(K.x,K.y,1,1);
  endShape(CLOSE);
  
  /************/
  /* Shape  3 */
  /************/
  beginShape();
    texture(textureMap);  
    vertex(H.x,H.y,1,0.5);
    vertex(J.x,J.y,1,1);
    vertex(O.x,O.y,1,0);
    vertex(P.x,P.y,0,0);
    vertex(G.x,G.y);    
  endShape(CLOSE);
  
  /************/
  /* Shape  4 */
  /************/
  beginShape();
    texture(textureMap);
    vertex(L.x,L.y);
    vertex(M.x,M.y,0,0);
    vertex(N.x,N.y,0,0.3);
    vertex(O.x,O.y);
    vertex(J.x,J.y);
    vertex(K.x,K.y,0,1);
  endShape(CLOSE);
  
  /************/
  /* Shape  5 */
  /************/
  beginShape();
    texture(textureMap);
    vertex(O.x,O.y);
    vertex(V.x,V.y,0,0);
    vertex(W.x,W.y,0,0.3);
    vertex(X.x,X.y);
    vertex(P.x,P.y);
  endShape(CLOSE);
  
  /************/
  /* Shape  6 */
  /************/
  beginShape();
    texture(textureMap);
    vertex(P.x,P.y);
    vertex(X.x,X.y,0,0);
    vertex(Q.x,Q.y,0,0.3);
  endShape(CLOSE);
  
  /************/
  /* Shape  7 */
  /************/
  beginShape();
    texture(textureMap);
    vertex(G.x,G.y,0,1);
    vertex(P.x,P.y);
    vertex(Q.x,Q.y);
    vertex(R.x,R.y,0,0.3);
    vertex(S.x,S.y,0,0);
    vertex(T.x,T.y);
    vertex(U.x,U.y);
    vertex(E.x,E.y);
    vertex(F.x,F.y);
  endShape(CLOSE);
  
  backBuffer = frontBuffer;
  currentImage++;
  currentImage %= QUEUE_SIZE;
}