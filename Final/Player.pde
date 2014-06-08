import ddf.minim.*; //imports audio
import gifAnimation.*; //imports gif processes

//Cole, I be needin' them comments 

public class Player{
  //int px, py; 
  int distance=85; //because polar coordinates
  int xshift,yshift;
  PImage arrow;
  boolean alive;
  float rotation; //gracias
  boolean onTop; //????
  PImage test=loadImage("Coordinate.png");
  
  Player(){
    alive = true;
//    px = 260;
//    py = 160;
    xshift=-25;
    yshift=-10;
    onTop = true; //??????
    rotation=radians(-90);
    arrow = loadImage("arrow.png");
  }
  void draw(boolean left, boolean right){
    if(rotation>2*PI){
      rotation-=2*PI;
    }else if(rotation<0){
      rotation+=2*PI;
    }
    if(left){
      rotation-=radians(6);
    }
    if(right){
      rotation+=radians(6);
    }
    translate(300,300);
    rotate(rotation);
    image(arrow,distance+xshift,yshift);
    //image(test,distance,0);
    rotate(rotation*(-1));
    translate(-300,-300);
  }
  
  //This looks like it was effortful, unfortunately polar coordinates make it 1,000,000x easier :P
  
//  void counter(){
//    if(onTop)
//    px -=3;
//    else px+=3;
//    recalculate();
//    //rotate if needed
//  }
//  void clock(){
//    if(onTop)
//    px += 3;
//    else px -= 3;
//    recalculate();
//    //rotate if needed
//  }
//  void recalculate(){
//    if (px == 260 || px == 320)
//    py = 280;
//    else{
//      if(py < 280)
//      py = (int)Math.round(280+Math.sqrt(900 - Math.pow((px-280),2)));
//      if(py > 280)
//      py = (int)Math.round(280-(Math.sqrt(900 - Math.pow((px-280),2))));
//    }
//  }
  
//  int getPX(){
//    return px;
//  }
//  int getPY(){
//    return py;
//  }

  boolean getAlive(){
    return alive;
  }
  float getRotation(){
    return rotation;
  }
  
  void setRotation(float x){
    rotation=x;
  }
  
  int getDistance(){
    return distance;
  }
  
  void die(){
   alive=false;
  } 
  
  void rise(){
    alive=true;
  }
  
}
