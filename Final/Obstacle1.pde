import ddf.minim.*; //imports audio
import gifAnimation.*; //imports gif processes

public class Obstacle1{
  int b;//xcor,ycor //b=bumper number, xcor and ycor are where the objects are centered, xshift and yshift are so that when they are drawn, xcor and ycor aren't the top left
  int distance;
  int xshift=0;//-50;
  int yshift=-62;//-60;
  float rotation;
  PImage c1,c2,c3,c4,c5,c6,c7;//,current;
  int cindex; //current index of arraylist image
  PImage[] image = {c1,c2,c3,c4,c5,c6,c7};
  String[] iname = {"Curve7.png","Curve6.png","Curve5.png","Curve4.png","Curve3.png","Curve2.png","Curve1.png"};//yes the image order is reversed, i screwed up the rotation :(
  PImage test;
  boolean alive;
  
  Obstacle1(int n){
    b=n;
    alive = true;
    distance=280;
    if(b==1){ //all these coordinates were lined up usin test
      rotation=radians(45);
    }else if(b==2){
      rotation=radians(-45);
    }else if(b==3){
      rotation=radians(-135);
    }else{
      rotation=radians(135);
    }
    for(int i=0;i<image.length;i++){ //just used to initialize all the curve names
    image[i]=loadImage(iname[i]);
    }
    cindex=0;
    test=loadImage("Coordinate.png");
  }
  
  void draw(){
    distance-=8;
    if(distance<=260-(18*(cindex+1))&&cindex<6){
      cindex++;
      xshift-=6;
    }
    translate(300,300);
    rotate(rotation); //this rotates ABOUT the ORIGIN
    image(image[cindex],distance+xshift,yshift); //current coordinates are a bit off for now
    //image(test,distance,0);
    rotate(rotation*(-1.0));
    //image(test,0,0);
    translate(-300,-300);
    if(distance<50){
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
