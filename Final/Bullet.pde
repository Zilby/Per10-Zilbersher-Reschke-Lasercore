import ddf.minim.*; //imports audio
import gifAnimation.*; //imports gif processes

public class Bullet{
  int distance;
  int xshift=1;//tbd
  int yshift=-3;//tbd
  float rotation; //amount obstacle is rotated about the origin.
  PImage c1;
  PImage test; //for testing the true coordinates
  boolean alive;
  
  Bullet(float n){
    rotation=n;//sets bumper number
    alive = true;
    distance=75;//sets initial distance from center
    c1=loadImage("obstacle5.png");
    test=loadImage("Coordinate.png");
  }
  
  void draw(){
    distance+=8; //ie: move toward center
    translate(300,300); //switches origin from top left to center
    rotate(rotation); //this rotates ABOUT the ORIGIN
    image(c1,distance+xshift,yshift); //draws image at the distance and then accounts for the size of the current image
    //image(test,distance,0);
    rotate(rotation*(-1.0)); //undoes rotation
    translate(-300,-300); //undoes translation
    if(distance>400){ //if too close to ball, die
      alive=false;
    }
  }
  
  boolean getAlive(){
    return alive;
  }
  
  float getRotation(){
    return rotation;
  } 
  
  int getDistance(){
    return distance;
  }
  
}
