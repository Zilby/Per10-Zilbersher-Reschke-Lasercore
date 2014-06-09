import ddf.minim.*; //imports audio
import gifAnimation.*; //imports gif processes

public class Obstacle2{
  int b;//b=bumper number, xshift and yshift are so that when they are drawn it is centered
  boolean left,right; //if going to be left of primary direction or right
  int distance;
  int xshift=5;//tbd
  int yshift=-18;//tbd
  float rotation; //amount obstacle is rotated about the origin.
  PImage c1;
  PImage test; //for testing the true coordinates
  boolean alive;
  
  Obstacle2(int n){
    b=n;//sets bumper number
    left=false;
    right=false;
    alive = true;
    distance=280;//sets initial distance from center
    if(b==1){ //all these coordinates were lined up usin test
      rotation=radians(45);
    }else if(b==2){
      rotation=radians(315);
    }else if(b==3){
      rotation=radians(225);
    }else{
      rotation=radians(135);
    }
    c1=loadImage("obstacle2.png");
    test=loadImage("Coordinate.png");
  }
  
  Obstacle2(int n,boolean r,boolean l){
    b=n;//sets bumper number
    left=l;
    right=r;
    alive = true;
    distance=280;//sets initial distance from center
    if(b==1){ //all these coordinates were lined up usin test
      rotation=radians(45);
    }else if(b==2){
      rotation=radians(315);
    }else if(b==3){
      rotation=radians(225);
    }else{
      rotation=radians(135);
    }
    c1=loadImage("obstacle2.png");
    test=loadImage("Coordinate.png");
  }
  
  void draw(){
    distance-=4; //ie: move toward center
    if(left){
      rotation-=(radians(.6));
    }
    if(right){
      rotation+=(radians(.6));
    }
    translate(300,300); //switches origin from top left to center
    rotate(rotation); //this rotates ABOUT the ORIGIN
    image(c1,distance+xshift,yshift); //draws image at the distance and then accounts for the size of the current image
    //image(test,distance,0);
    rotate(rotation*(-1.0)); //undoes rotation
    translate(-300,-300); //undoes translation
    if(distance<40){ //if too close to ball, die
      alive=false;
    }
  }
  
  boolean getAlive(){
    return alive;
  }
  
  void die(){
   alive=false;
  } 
  
  float getRotation(){
    return rotation;
  } 
  
  int getDistance(){
    return distance;
  }
  
  boolean getRight(){
    return right;
  }
  
  boolean getLeft(){
    return left;
  }
  
}
