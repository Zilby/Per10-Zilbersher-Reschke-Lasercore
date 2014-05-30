import ddf.minim.*; //imports audio
import gifAnimation.*; //imports gif processes

AudioPlayer M0,M1,M2,M3,M4,M5,M6; // All these are individual song files
AudioPlayer[] AP = {M0,M1,M2,M3,M4,M5,M6}; //array for songs
String[] trackTitle = {"M0.mp3","M1.mp3","M2.mp3","M3.mp3","M4.mp3","M5.mp3","M6.mp3"}; //arrayfor song names
Minim minim; // Audio context (general song player)
int level,lives; //keeps track of current level & lives
boolean advance; //ie: level complete, go to next level
boolean first; //if first time going through the nextLevel()
boolean restart; //for gameover restart
int counter; //for countdown time before levels
boolean gO; //for gameOver (see method)
boolean I0,I1,I2,I3,I4,I5,I6; //tells if first (initial) time running levelZero-Six() for level 0-6
boolean modulator; //for the space gif transparency
int blur1,blur2,blur3,blur4;//for the initial fade in of title, names and countdown
boolean[] Initial = {I0,I1,I2,I3,I4,I5,I6}; //array for all initials times
Gif menuG,names,title,space; //ie: background(menuG or gif), alex&cole(names), Lasercore(title), Press space to begin(space)
PImage i1,i2,i3,igo,ball,bumper,rotatedbumper; //creates images for countdown

void setup() {
  size(600, 600); //sets screen size
  frameRate(30); //sets framerate to 30 frames/second (default is 60)
  minim = new Minim(this); //creates the new audio context
  level=0; //sets level to 0 or home
  lives=5;
  counter=0;
  gO=false;//for gameOver (see method)
  I0=true; //sets initial run for lvl 0 to true
  I1=I2=I3=I4=I5=I6=false; //sets the other's initials to false
  i1=loadImage("1.png");
  i2=loadImage("2.png");
  i3=loadImage("3.png");
  igo=loadImage("Go.png");
  ball=loadImage("Ball.png");
  bumper=loadImage("bumper.png");
  rotatedbumper=loadImage("rotatedbumper.png");
  advance = false; //sets advance to its default: false
  first = false; //sets first run through advance to false
  restart = false; //sets the gameover restart to false
  menuG= new Gif(this, "menuG.gif"); //initializes lvl 0 gifs
  names= new Gif(this, "Names.gif");
  title= new Gif(this, "Title.gif");
  space= new Gif(this, "Space.gif");
  AP[level] = minim.loadFile(trackTitle[level], 2048); //loads lvl 0 audiofile
  modulator=true; //sets modulator true (used to make space fade in and out)
  blur1=blur2=blur3=blur4=0; //sets blurs to 0 (used for fading in)
}

void draw(){
    if(lives==0&&level!=-1){
      level=-1;
      first=true;
    }
    //IN BETWEEN LEVELS
    if(advance){ //if advancing to next level,
      nextLevel();
    }
    //each level has its own method
    else if(level==0){
      levelZero();
    }
    else if(level==-1){
      gameOver();
    }
    else if(level==1){
      levelOne();
    }
    else if(level==2){
      levelTwo();
    }
    else if(level==3){
      levelThree();
    }
    else if(level==4){
      levelFour();
    }
    else if(level==5){
      levelFive();
    }
    else if(level==6){
      levelSix();
    }
}

void keyReleased() {
    if(level==0){
        if(key == ' '){
            advance = true;
            first = true;
        }
    }
    //For Testing Only
    if(key=='g'){
      lives=0;
    }
    //Testing Stops Here
    if(level==-1){
        if(key == ' '){
          restart=true;
        }
    }
}

void nextLevel(){
    if(first){ //if first time performing nextLevel
        minim.stop(); //stop the music!
        blur1=blur2=blur3=blur4=0; //resets blurs
        if(level==0){
          menuG.stop(); //stops main menu gifs
          title.stop();
          space.stop();
          names.stop();
          modulator=true; //resets modulator for future use
          I0=true; //resets initial
        }
        first=false; //no longer first occurence of advance
      } //This sets up the count down
      if(counter<65){
        background(0);
        if(counter<15){ //all this is just to blur in the 3, 2, 1, GO
          if(blur1<255&&counter<5){ //blurs in for first five frames
             tint(255,blur1);
             image(i3,210,210);
             tint(255,255);
             blur1=blur1+60;
           }else if(blur1>=0&&counter>10){ //blurs out for last five frames
             tint(255,blur1);
             image(i3,210,210);
             tint(255,255);
             blur1=blur1-60;
           }else{
             image(i3,210,210);
           }
        }else if(counter<30){
          if(blur2<255&&counter<20){
             tint(255,blur2);
             image(i2,210,210);
             tint(255,255);
             blur2=blur2+60;
           }else if(blur2>=0&&counter>25){
             tint(255,blur2);
             image(i2,210,210);
             tint(255,255);
             blur2=blur2-60;
           }else{
             image(i2,210,210);
           }
        }else if(counter<45){
          if(blur3<255&&counter<35){
             tint(255,blur3);
             image(i1,210,210);
             tint(255,255);
             blur3=blur3+60;
           }else if(blur3>=0&&counter>40){
             tint(255,blur3);
             image(i1,210,210);
             tint(255,255);
             blur3=blur3-60;
           }else{
             image(i1,210,210);
           }
        }else{
          if(blur4<255&&counter<50){
             tint(255,blur4);
             image(igo,130,210);
             tint(255,255);
             blur4=blur4+60;
           }else if(blur4>=0&&counter>59){
             tint(255,blur4);
             image(igo,130,210);
             tint(255,255);
             blur4=blur4-60;
           }else{
             image(igo,130,210);
           }
        }
        counter++; //countdown stops here, begins to start next level
      }else{
        level++; //make level higher
        advance=false; //set advance false
        AP[level] = minim.loadFile(trackTitle[level], 2048); //loads song file for corresponding level
        Initial[level]=true; //sets level's initial run to true
        //AP[level].play(); //**has been moved to each individual level method
      }
}

void levelZero(){ //AKA: Menu
   int m = millis();
   if(I0){
     frameRate(30);
     if(m>3600){ //after ~3 seconds initializes the background and starts song
       menuG.loop(); //loops gif
       AP[level].loop(); //loops song
       I0=false; //sets initial to false
     }
   }else{
    background(menuG); //sets background
     if(m>7800){ //sets of alex & cole on a timer
       if(!names.isPlaying()){ //if not already initialized the names is initialized
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
     if(m>10800){
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
     if(m>15500){
         if(!space.isPlaying()){
           space.loop();
         }
         int t = ((frameCount%63)*4); //sets timing for fade in and out
         if(modulator){ //determines if fading in or out
           tint(255,t);
         }else{
           tint(255,250-t);
         }
         if(t==248){ //switches the fade in vs. fade out
           modulator=!modulator;
         }
         if(gO){ //for gameOver to make sure fade happens
           if(t==0&&modulator){
             image(space,12,80); //draws image
             gO=false;
           }
         }else{
           image(space,12,80); //draws image
         }
         tint(255,255); //normalizes transparency
     }
  }
}

void gameOver(){
  if(first){
    first=false;
    frameRate(30);
    minim.stop();
    //AP[level] = minim.loadFile(trackTitle[level], 2048); //loads song file for corresponding level ie: -1
  }
  if(restart){
    restart=false;
    modulator=true; //sets modulator true (used to make space fade in and out)
    blur1=blur2=blur3=blur4=0; //sets blurs to 0 (used for fading in)
    counter=0;
    lives=5;
    level=0;
    I0=true; //sets initial run to true
    AP[level] = minim.loadFile(trackTitle[level], 2048); //loads song file for corresponding level ie: 0
    gO=true;//gameOver t setter so that the space doesn't appear at the very start
  }
}

void levelOne(){
  if(Initial[level]){ //if initial time running this method...
    frameRate(45);
    AP[level].play(); //play song 1
    //ball.loop();
    Initial[level]=false; //no longer true
  }
  background(0);
  if(blur1<255){
    tint(255,blur1);
    image(ball,100,50);
    image(rotatedbumper,-10,420);
    image(bumper,175,500);
    tint(255,255);
    blur1=blur1+2;
  }else{
    image(ball,100,50);
    image(rotatedbumper,-10,420);
    image(bumper,175,500);
  }
}

void levelTwo(){
}

void levelThree(){
}

void levelFour(){
}

void levelFive(){
}

void levelSix(){
}

/*class player(){
}

class laser(){
}

class obstacle(){
}

-for way to draw, make arraylist of class objects
-can have a draw method inside a class
-tell in the draw method to draw each in the arraylist
-when want new object, add to the arraylist (can set coordinates)
*/
