import ddf.minim.*; //imports audio
import gifAnimation.*; //imports gif processes

public class Obstacle5{
  int b;//b=bumper number, xshift and yshift are so that when they are drawn it is centered
  boolean inverse; //if going to be left of primary direction or right
  float curve; //amount of left or right curve
  int distance;
  int xshift=1;//tbd
  int yshift=-3;//tbd
  float rotation; //amount obstacle is rotated about the origin.
  PImage c1; //there used to be multiple currents for the image, the name is a remnant of that
  PImage test; //for testing the true coordinates
  boolean alive;
  
  Obstacle5(int n,boolean i,float c){
    b=n;//sets bumper number
    inverse=i;
    curve=c;
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
    c1=loadImage("obstacle5.png");
    test=loadImage("Coordinate.png");
  }
  
  void draw(){
    distance-=12; //ie: move toward center
    if(inverse){
      rotation-=(radians(curve)); //curve should be .5 for semi, .8 for greatly
    }else{
      rotation+=(radians(curve));
    }
    translate(300,300); //switches origin from top left to center
    rotate(rotation); //this rotates ABOUT the ORIGIN
    image(c1,distance+xshift,yshift); //draws image at the distance and then accounts for the size of the current image
    //image(test,distance,0);
    rotate(rotation*(-1.0)); //undoes rotation
    translate(-300,-300); //undoes translation
    if(distance<50){ //if too close to ball, die
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
  
  boolean getInverse(){
    return inverse;
  }
}
