import ddf.minim.*; //imports audio
import gifAnimation.*; //imports gif processes

public class Obstacle1{
  int xcor,ycor,b;//b=bumper number
  float rotation;
  PImage c1,c2,c3,c4,c5,c6,c7,current;
  PImage[] image = {c1,c2,c3,c4,c5,c6,c7};
  String[] iname = {"Curve1.png","Curve2.png","Curve3.png","Curve4.png","Curve5.png","Curve6.png","Curve7.png"};
  
  Obstacle1(int n){
    b=n;
    if(b==1){
      rotation=(3*PI)/4;
      xcor=40;
      ycor=40;
    }else if(b==2){
      rotation=-(3*PI)/4;
      xcor=40;
      ycor=560;
    }else if(b==3){
      rotation=PI/4;
      xcor=560;
      ycor=560;
    }else{
      rotation=-PI/4;
      xcor=560;
      ycor=40;
    }
    for(int i=0;i<image.length;i++){ //just used to initialize all the curve names
    image[i]=loadImage(iname[i]);
    }
    current=image[0]; //NOTE cannot be c1, image[0] and c1 are considered separate entities
  }
  
void draw(){
    if(b==1||b==2){
      if(xcor<300)
        xcor+=1;
    }else{
      if(xcor>300)
        xcor-=1;
    }if(b==1||b==4){
      if(ycor<300)
        ycor+=1;
    }else{
      if(ycor>300)
        ycor-=1;
    }
    image(current,xcor,ycor);
  }
  
  int getX(){
    return xcor;
  }
  
  int getY(){
    return ycor;
  }
  
  float getRotation(){
    return rotation;
  }
   
}
