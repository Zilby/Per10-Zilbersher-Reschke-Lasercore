import ddf.minim.*; //imports audio
import gifAnimation.*; //imports gif processes

public class Obstacle1{
  int xcor,ycor,b;//b=bumper number
  float rotation;
  PImage c1,c2,c3,c4,c5,c6,c7,current;
  PImage[] image = {c1,c2,c3,c4,c5,c6,c7};
  String[] iname = {"Curve1.png","Curve2.png","Curve3.png","Curve4.png","Curve5.png","Curve6.png","Curve7.png"};
  PImage test;
  
  Obstacle1(int n){
    b=n;
    if(b==1){
      rotation=radians(45);
      xcor=40;
      ycor=40;
    }else if(b==2){
      rotation=radians(-45);
      xcor=40;
      ycor=560;
    }else if(b==3){
      rotation=radians(-135);
      xcor=560;
      ycor=560;
    }else{
      rotation=radians(135);
      xcor=560;
      ycor=40;
    }
    for(int i=0;i<image.length;i++){ //just used to initialize all the curve names
    image[i]=loadImage(iname[i]);
    }
    current=image[0]; //NOTE cannot be c1, image[0] and c1 are considered separate entities
    test=loadImage("Coordinate.png");
  }
  
void draw(){
    if(b==1||b==2){
      if(xcor<290)
        xcor+=4;
    }else{
      if(xcor>290)
        xcor-=4;
    }if(b==1||b==4){
      if(ycor<280)
        ycor+=4;
    }else{
      if(ycor>280)
        ycor-=4;
    } //rotation was screwy before see this http://www.processing.org/tutorials/transform2d/
    translate(xcor,ycor); //this essentially moves the origin
    rotate(rotation); //this rotates ABOUT the ORIGIN
    image(current,0,0); //current coordinates are a bit off for now
    image(test,0,0);
    rotate(rotation*(-1.0));
    translate(-xcor,-ycor);
  }
  /*
  int getX(){
    return xcor;
  }
  
  int getY(){
    return ycor;
  }
  
  float getRotation(){
    return rotation;
  }
  */ 
}
