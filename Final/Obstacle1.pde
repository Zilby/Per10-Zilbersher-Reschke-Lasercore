import ddf.minim.*; //imports audio
import gifAnimation.*; //imports gif processes

public class Obstacle1{
  int xcor,ycor,b;//b=bumper number, xcor and ycor are where the objects are centered, xshift and yshift are so that when they are drawn, xcor and ycor aren't the top left
  int distance;
  int xshift=0;//-50;
  int yshift=-52;//-60;
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
    distance=300;
    if(b==1){ //all these coordinates were lined up usin test
      rotation=radians(45);
      distance+=30;
      //xcor=48;
      //ycor=40;
    }else if(b==2){
      rotation=radians(-43);
      distance+=15;
      //xcor=30;
      //ycor=540;
    }else if(b==3){
      rotation=radians(-136);
      //xcor=560;
      //ycor=550;
    }else{
      rotation=radians(130);
      distance+=20;
      //xcor=530;
      //ycor=40;
    }
    for(int i=0;i<image.length;i++){ //just used to initialize all the curve names
    image[i]=loadImage(iname[i]);
    }
    cindex=0;
    //current=image[cindex]; //NOTE cannot be c1, image[0] and c1 are considered separate entities
    test=loadImage("Coordinate.png");
  }
  
  void draw(){
//    if(b==1||b==2){
//      if(xcor<290)
//        xcor+=8;
//    }else{
//      if(xcor>290)
//        xcor-=8;
//    }if(b==1||b==4){
//      if(ycor<280)
//        if(ycor>=(30*(cindex+1))+40){
//          cindex++;
//          xshift+=5;
//        }
//        ycor+=8;
//    }else{
//      if(ycor>280)
//        if(ycor<=550-(34*(cindex+1))){
//          cindex++;
//          xshift+=5;
//        }
//        ycor-=8;
//    }
//   if(Math.sqrt(Math.pow(abs(xcor-290),2) + Math.pow(abs(ycor - 280),2)) < 60){
//     alive = false;
//   }                  
//    //rotation was screwy before see this http://www.processing.org/tutorials/transform2d/
//    translate(xcor,ycor); //this essentially moves the origin
//    rotate(rotation); //this rotates ABOUT the ORIGIN
//    image(image[cindex],xshift,yshift); //current coordinates are a bit off for now
//    image(test,0,0);
//    rotate(rotation*(-1.0));
//    translate(-xcor,-ycor);
//    //image(test,xcor,ycor);
    distance-=8;
    translate(292,285);
    rotate(rotation); //this rotates ABOUT the ORIGIN
    image(image[cindex],distance+xshift,yshift); //current coordinates are a bit off for now
    image(test,distance,0);
    rotate(rotation*(-1.0));
    //image(test,0,0);
    translate(-292,-285);
//    if(distance<60){
//      alive=false;
//    }
  }
  
  boolean getAlive(){
    return alive;
  }
  
//  int getX(){
//    return xcor;
//  }
//  
//  int getY(){
//    return ycor;
//  }
  
  float getRotation(){
    return rotation;
  } 
  
  int getDistance(){
    return distance;
  }
}
