import ddf.minim.*; //imports audio
import gifAnimation.*; //imports gif processes

public class Player{
  int px, py;
  PImage arrow;
  boolean alive;
  float rotation;
  boolean onTop;
  
  Player(){
    alive = true;
    px = 260;
    py = 160;
    onTop = true;
    arrow = loadImage("arrow.png");
  }
  void draw(){
    image(arrow,px,py);
  }
  void counter(){
    if(onTop)
    px -=3;
    else px+=3;
    recalculate();
    //rotate if needed
  }
  void clock(){
    if(onTop)
    px += 3;
    else px -= 3;
    recalculate();
    //rotate if needed
  }
  void recalculate(){
    if (px == 260 || px == 320)
    py = 280;
    else{
      if(py < 280)
      py = (int)Math.round(280+Math.sqrt(900 - Math.pow((px-280),2)));
      if(py > 280)
      py = (int)Math.round(280-(Math.sqrt(900 - Math.pow((px-280),2))));
    }
  }
  int getPX(){
    return px;
  }
  int getPY(){
    return py;
  }
  boolean getPAlive(){
    return alive;
  }
  float getPRotation(){
    return rotation;
  }
  
  
}
