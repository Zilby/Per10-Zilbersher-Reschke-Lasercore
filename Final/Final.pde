import ddf.minim.*;
import gifAnimation.*;
import java.awt.event.KeyEvent;

AudioPlayer M0,M1,M2,M3,M4,M5,M6; // All these are individual song files
AudioPlayer[] AP = {M0,M1,M2,M3,M4,M5,M6}; //array for songs
String[] trackTitle = {"M0.mp3","M1.mp3","M2.mp3","M3.mp3","M4.mp3","M5.mp3","M6.mp3"}; //arrayfor song names
Minim minim; // Audio context (general song player)
int level; //keeps track of current level
boolean advance; //ie: level complete, go to next level
boolean I0,I1,I2,I3,I4,I5,I6; //Initial run (ie: setup) for level 0-6
boolean modulator; //for the space gif transparency
int blur1,blur2;//for the initial blur for title and names
boolean[] Initial = {I0,I1,I2,I3,I4,I5,I6}; //array for all initials
Gif menuG,names,title,space;

void setup() {
  size(600, 600);                       //sets screen size
  frameRate(50);                        //sets framerate to 45 frames/second
  minim = new Minim(this);              //creates the new audio context
  level=0;                              //sets level to 0 or home
  I0=true;                              //sets initial run for lvl 0 to true
  I1=I2=I3=I4=I5=I6=false;
  advance = false;                      //sets advance to its default: false
  menuG= new Gif(this, "menuG.gif");
  names= new Gif(this, "Names.gif");
  title= new Gif(this, "Title.gif");
  space= new Gif(this, "Space.gif");
  M0 = minim.loadFile("M0.mp3", 2048);  //loads first audiofile
  modulator=true;
  blur1=blur2=0;
}

void draw(){
    if(advance==true){ //if advancing to next level, 
      level++;         //make level higher
      advance=false;   //set advance false
      minim.stop();    //stop the music!
      if(level==1){
        menuG.stop(); //stops main menu gif
        //M1 = minim.loadFile("M1.mp3", 2048);
        //I1=true;
        //M1.play();
      }
      AP[level] = minim.loadFile(trackTitle[level], 2048); //loads file for corresponding level
      Initial[level]=true; //sets level's initial run to true
      AP[level].play(); //**may move to later in draw function rather than the setup
    }
    if(level==0){
       int m = millis();
       if(I0){
         if(m>3000){
           menuG.loop(); //loops gif
           M0.loop(); //loops song
           I0=false; //sets initial to false
         }
       }else{
         background(menuG);
         //image(menuG,0,0);
         if(m>6600){
           if(!names.isPlaying()){
             names.loop();
           }
           if(blur1<255){
             tint(255,blur1);
             image(names,30,570);
             tint(255,255);
             blur1=blur1+2;
           }else{
           image(names,30,570);
           }
         }
         if(m>9000){
           if(!title.isPlaying()){
             title.loop();
           }
           if(blur2<255){
             tint(255,blur2);
             image(title,15,10);
             tint(255,255);
             blur2=blur2+2;
           }else{
           image(title,15,10);
           }
         }
         if(m>12000){
           if(!space.isPlaying()){
             space.loop();
           }
           int t = ((frameCount%125)*2); //sets timing for fade in and out
           if(modulator){ //determines if fading in or out
             tint(255,t);
           }else{
             tint(255,250-t);
           }
           if(t==248){
             modulator=!modulator;
           }
           image(space,12,80);
           tint(255,255); //normalizes tint
         }
       }
    }
    else if(level==1){
    }
    else if(level==2){
    }
    else if(level==3){
    }
    else if(level==4){
    }
    else if(level==5){
    }
    else if(level==6){
    }
}

void keyReleased() {
    if(level==0){
        if(key == ' '){
            advance = true;
        }
    }
}

/*class player(){
}

class laser(){
}

class obstacle(){
}
*/

