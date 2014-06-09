import ddf.minim.*; //imports audio
import gifAnimation.*; //imports gif processes

public class Obstacle4{
  int b;//xcor,ycor //b=bumper number, xcor and ycor are where the objects are centered, xshift and yshift are so that when they are drawn, xcor and ycor aren't the top left
  int distance;
  int xshift=0;//-50;
  int yshift=-31;//-60;
  float rotation; //amount obstacle is rotated about the origin.
  PImage c1,c2,c3,c4,c5,c6,c7;//,current;
  int cindex; //current index of arraylist image
  PImage[] image = {c1,c2,c3,c4,c5,c6,c7};
  String[] iname = {"sCurve7.png","sCurve6.png","sCurve5.png","sCurve4.png","sCurve3.png","sCurve2.png","sCurve1.png"};//yes the image order is reversed, i screwed up the rotation :(
  PImage test; //for testing the true coordinates
  boolean alive,right,left;
  
  Obstacle4(int n,boolean r,boolean l){
    b=n;//sets bumper number
    alive = true;
    right=r;
    left=l;
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
    for(int i=0;i<image.length;i++){ //just used to initialize all the curve names
    image[i]=loadImage(iname[i]);
    }
    cindex=0; //current image is the first image in the arraylist so cindex=0
    test=loadImage("Coordinate.png");
  }
  
  void draw(){
    distance-=4; //ie: move toward center
    if(distance<=260-(18*(cindex+1))&&cindex<6){ //this is just a fancy way of changing the image as it moves
      cindex++;
      xshift-=3; //used because if you don't shift the image's location the actual coordinates don't line up with the curve because the image changes. 
    }
    if(left){
      rotation-=radians(.9);
    }
    if(right){
      rotation+=radians(.9);
    }
    translate(300,300); //switches origin from top left to center
    rotate(rotation); //this rotates ABOUT the ORIGIN
    image(image[cindex],distance+xshift,yshift); //draws image at the distance and then accounts for the size of the current image
    //image(test,distance,0);
    rotate(rotation*(-1.0)); //undoes rotation
    //image(test,0,0);
    translate(-300,-300); //undoes translation
    if(distance<40){ //if too close to ball, die
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
  
  boolean getRight(){
    return right;
  }
  
  boolean getLeft(){
    return left;
  }
}
