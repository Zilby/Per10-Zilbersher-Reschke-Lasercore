import java.io.*;
import java.util.*;
import ddf.minim.*; //imports audio
import gifAnimation.*; //imports gif processes

//Cole to put this as easily as possible, we're basically using polar coordinates. no more xcor and ycor, we're using 
//distance and rotation. To get the origin as the center, use translate(300,300) (i lined up all the bumpers and the ball)
//Only use regular coordinates if you want to do like horizontal writing for 'lives' or 'level' or something like that
//or if you need to account for the change in location of an image being drawn (see xshift and yshift in obstacle1.class)

AudioPlayer M0,M1,M2,M3,M4,M5,M6,gOeffect; // All these are individual song files
AudioPlayer[] AP = {M0,M1,M2,M3,M4,M5,M6}; //array for songs
String[] trackTitle = {"M0.mp3","M1.mp3","M2.mp3","M3.mp3","M4.mp3","M5.mp3","M6.mp3"}; //arrayfor song names
Minim minim; // Audio context (general song player)
int level,lives; //keeps track of current level & lives
boolean advance; //ie: level complete, go to next level
boolean first; //if first time going through the nextLevel()
boolean restart; //for gameover restart
int counter, gCount, gTimer, gcor, gcolor; //for countdown time before levels and glow counter, timer for glow, gx/y-coordinate
boolean gO; //for gameOver (see method)
boolean I0,I1,I2,I3,I4,I5,I6; //tells if first (initial) time running levelZero-Six() for level 0-6
boolean modulator; //for the space gif transparency
int blur1,blur2,blur3,blur4;//for the initial fade in of title, names and countdown
boolean[] Initial = {I0,I1,I2,I3,I4,I5,I6}; //array for all initials times
Gif menuG,names,title,space,gameOver; //ie: background(menuG or gif), alex&cole(names), Lasercore(title), Press space to begin(space)
PImage i1,i2,i3,igo,ball,bumper,bglow1,bglow2,bglow3,bglow4,bglow5; //creates images for countdown
PImage[] Bary = {bumper,bglow1,bglow2,bglow3,bglow4,bglow5};
String[] Bname = {"bumper.png","bglow1.png","bglow2.png","bglow3.png","bglow4.png","bglow5.png"};
ArrayList<Obstacle1> o1s = new ArrayList<Obstacle1>();
PImage testcor; //used as a test for where the coordinates of something are
boolean leftPressed, rightPressed;
Player torment; //torment?


void setup() {
  size(600, 600); //sets screen size
  frameRate(30); //sets framerate to 30 frames/second (default is 60)
  minim = new Minim(this); //creates the new audio context
  level=0; //sets level to 0 or home
  lives=5;
  counter=0;
  gO=true;//for gameOver (see method) (works better for intro across the board if just initialized to true
  I0=true; //sets initial run for lvl 0 to true
  I1=I2=I3=I4=I5=I6=false; //sets the other's initials to false
  i1=loadImage("1.png");
  i2=loadImage("2.png");
  i3=loadImage("3.png");
  igo=loadImage("Go.png");
  ball=loadImage("Ball.png");
  for(int i=0;i<Bary.length;i++){ //just used to initialize all the bumper names
    Bary[i]=loadImage(Bname[i]);
  }
  gCount=gTimer=gcor=gcolor=0;
  advance = false; //sets advance to its default: false
  first = false; //sets first run through advance to false
  restart = false; //sets the gameover restart to false
  menuG= new Gif(this, "menuG.gif"); //initializes lvl 0 gifs
  names= new Gif(this, "Names.gif");
  title= new Gif(this, "Title.gif");
  space= new Gif(this, "Space.gif");
  gameOver= new Gif(this, "gameOver.gif");
  AP[level] = minim.loadFile(trackTitle[level], 2048); //loads lvl 0 audiofile
  modulator=true; //sets modulator true (used to make space fade in and out)
  blur1=blur2=blur3=blur4=0; //sets blurs to 0 (used for fading in)
  testcor=loadImage("Coordinate.png");
  torment = new Player(); //torment?
  leftPressed=rightPressed=false;
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


void keyPressed(){
  if (keyCode == LEFT){
    leftPressed = true;
  }
  if (keyCode == RIGHT){
    rightPressed = true;
  }
}
  
void keyReleased() {
    if(level==0){
        if(key == ' '&&!I0){ //!I0 is to prevent it from calling this during countdown
            advance = true;
            first = true;
        }
    }
    //For Testing Only
    if(key=='g'){
      lives=0;
    }
    if(key=='b'){
      glow();
    }
    if(key=='1'){
      wave(1);
    }
    if(key=='2'){
      wave(2);
    }
    if(key=='3'){
      wave(3);
    }
    if(key=='4'){
      wave(4);
    }
    if(keyCode == LEFT){ 
      leftPressed = false;
    }
    if(keyCode == RIGHT){
      rightPressed = false;
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
     if(m>13500){
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
         if(gO){ //to make sure space fades in rather than suddenly appearing
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
    frameRate(60);
    blur1=0;
    minim.stop();
    gameOver.loop();
    gOeffect = minim.loadFile("GameOver.mp3", 2048); 
    gOeffect.play();
  }
  background(0);
  if(blur1<255){
    tint(255,blur1);
    image(gameOver,40,160);
    noTint();
    blur1++;
  }else
    image(gameOver,40,160);
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
    frameRate(30);
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
    tint(125,255,130,blur1);
    image(ball,163,125);
    //image(testcor,295,295);
    tint(10+gcolor,216+(gcolor/10),15+gcolor,blur1);
    drawBumpers();
    torment.draw(leftPressed,rightPressed);
    noTint();
    blur1=blur1+2;
  }else{
    tint(125,255,130);
    image(ball,163,125);
    //image(testcor,295,295);
    tint(10+gcolor,216+(gcolor/10),15+gcolor);
    drawBumpers();
    noTint();
    tint(10,216,15);
    torment.draw(leftPressed,rightPressed);
    noTint();
  }
  tint(10,216,15);
  for(int i=0;i<o1s.size();i++){
    o1s.get(i).draw();
    if(!o1s.get(i).getAlive())
      o1s.remove(i);
  }
  noTint();
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

void drawBumpers(){
  translate(300,300);
  rotate(radians(45));
  image(gImage(),270-gcor,-165-(gcor/2));
  rotate(radians(90));
  image(gImage(),270-gcor,-165-(gcor/2));
  rotate(radians(90));
  image(gImage(),270-gcor,-165-(gcor/2));
  rotate(radians(90));
  image(gImage(),270-gcor,-165-(gcor/2));
  rotate(radians(45));
  translate(-300,-300);
//  image(gImage(),-170,450-gcor);
//  image(gImage(),430-gcor,450-gcor);
//  image(gImage(),-170,-180);
//  image(gImage(),430-gcor,-180);
}

PImage gImage(){ //ie: glowed image
  if(gCount!=0&&gTimer%4==0)
    gCount--;
  if(gTimer!=0)
    gTimer--;
  if(gCount==9||gCount==1){
    gcor=5;
    gcolor=50;
    return Bary[1];
  }else if (gCount==8||gCount==2){
    gcor=10;
    gcolor=100;
    return Bary[2];
  }else if (gCount==7||gCount==3){
    gcor=15;
    gcolor=150;
    return Bary[3];
  }else if (gCount==6||gCount==4){
    gcor=20;
    gcolor=200;
    return Bary[4];
  }else if (gCount==5){
    gcor=25;
    gcolor=250;
    return Bary[5];
  }else{
    gcor=0;
    gcolor=0;
    return Bary[0];
  }
}

void glow(){
  gCount=10;
  gTimer=40;
  gcor=0;
  gcolor=0;
}

void wave(int b){ //ie:make an obstacle one at b bumper
  Obstacle1 o = new Obstacle1(b);
  o1s.add(o);
}

/*class player(){
    int[] bulletX;
int[] bulletY;
boolean alive;
int thisBullet;
int px;
int py;
boolean shotReleased;
}

class enemy(){
int [] enemyX;
int [] enemyY;
int[] enemyBulletX;
int[] enemyBulletY;
int[] enemyYspeed;
int[] enemyXspeed;
int shootingEnemy;
int shootingEnemyTimer;
int deadEnemyCount;
}
void enemy1(){
  implements standard projectile
}
void enemy2(){
   implements certain type of new projectile
}
void enemy3(){
  *same as above
}
void enemy4(){
  *same as above
}
void enemy5(){
  *same as above
}
void enemy6(){
  *same as above
}

class obstacle(){
}

-for way to draw, make arraylist of class objects
-can have a draw method inside a class
-tell in the draw method to draw each in the arraylist
-when want new object, add to the arraylist (can set coordinates)
*/
