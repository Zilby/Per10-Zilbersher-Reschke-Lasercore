import java.io.*;
import java.util.*;
import ddf.minim.*; //imports audio
import gifAnimation.*; //imports gif processes

//Important, for timing the stuff as they happen in the song
//AP[level].position() returns how much song has played in milliseconds

//notes for me: tomorrow can do level messages, easy stuff. then shooting, death of enemies, tracking enemies.

//Cole to put this as easily as possible, we're basically using polar coordinates. no more xcor and ycor, we're using 
//distance and rotation. To get the origin as the center, use translate(300,300) (i lined up all the bumpers and the ball)
//Only use regular coordinates if you want to do like horizontal writing for 'lives' or 'level' or something like that
//or if you need to account for the change in location of an image being drawn (see xshift and yshift in obstacle1.class)

AudioPlayer M0, M1, M2, M3, M4, M5, M6, gOeffect, winEffect; // All these are individual song files
AudioPlayer[] AP = {M0, M1, M2, M3, M4, M5, M6}; //array for songs
String[] trackTitle = {"M0.mp3", "M1.mp3", "M2.mp3", "M3.mp3", "M4.mp3", "M5.mp3", "M6.mp3"}; //arrayfor song names
Minim minim; // Audio context (general song player)
int level, lives; //keeps track of current level & lives
boolean advance; //ie: level complete, go to next level
boolean first; //if first time going through the nextLevel()
boolean restart; //for gameover restart
int lasers, counter, lvltimer = 0; //for countdown time before levels and glow counter, timer for glow, gx/y-coordinate
int gCount1,gCount2,gCount3,gCount4, gTimer1,gTimer2,gTimer3,gTimer4, gcor1,gcor2,gcor3,gcor4, gcolor1,gcolor2, gcolor3, gcolor4;
int[] gAll={gCount1,gCount2,gCount3,gCount4, gTimer1,gTimer2,gTimer3,gTimer4, gcor1,gcor2,gcor3,gcor4, gcolor1,gcolor2, gcolor3, gcolor4};
boolean gO; //for gameOver (see method)
boolean st1,st2,st3,st4,sFirst,sInverse,sRising;
boolean[] stream={st1,st2,st3,st4}; //for bulletstream
boolean g1,g2,g3,g4; //for glow
boolean[] gbumper={g1,g2,g3,g4};
int sCount;
float sRotation;
boolean I0, I1, I2, I3, I4, I5, I6; //tells if first (initial) time running levelZero-Six() for level 0-6
boolean modulator; //for the space gif transparency
int blur1, blur2, blur3, blur4, blur5, blur6;//for the initial fade in of title, names, score, new level and countdown
boolean[] Initial = {I0, I1, I2, I3, I4, I5, I6}; //array for all initials times
Gif menuG, names, title, space, gameOver, winner, s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, lvl, lifeG, sline; //ie: background(menuG or gif), alex&cole(names), Lasercore(title), Press space to begin(space)
Gif[] Larray = {s0,s1,s2,s3,s4,s5,s6};
PImage i1, i2, i3, igo, ball, bumper, bglow1, bglow2, bglow3, bglow4, bglow5; //creates images for countdown
PImage las0, las1, las2, las3, las4, las5, las6, las7, las8, las9;
PImage[] Bary = {bumper, bglow1, bglow2, bglow3, bglow4, bglow5};
String[] Bname = {"bumper.png", "bglow1.png", "bglow2.png", "bglow3.png", "bglow4.png", "bglow5.png"};
PImage[] las = {las0, las1, las2, las3, las4, las5, las6, las7, las8, las9};
String[] lasname = {"las0.png", "las1.png", "las2.png", "las3.png", "las4.png", "las5.png", "las6.png", "las7.png", "las8.png", "las9.png"};
ArrayList<Bullet> bullets=new ArrayList<Bullet>();
ArrayList<Obstacle1> o1s = new ArrayList<Obstacle1>();
ArrayList<Obstacle2> o2s = new ArrayList<Obstacle2>();
ArrayList<Obstacle3> o3s = new ArrayList<Obstacle3>();
ArrayList<Obstacle4> o4s = new ArrayList<Obstacle4>();
ArrayList<Obstacle5> o5s = new ArrayList<Obstacle5>();
PImage testcor; //used as a test for where the coordinates of something are
boolean leftPressed, rightPressed, keysbegan = false, increase, decrease;//increase and decrease just test scoring for now
ArrayList<Gif> scores = new ArrayList<Gif>();
int score = 0, uno = 0;
Player torment; //torment?


void setup() {
  size(600, 600); //sets screen size
  frameRate(30); //sets framerate to 30 frames/second (default is 60)
  minim = new Minim(this); //creates the new audio context
  level=0; //sets level to 0 or home
  lives=5;
  lasers=0;
  counter=0;
  gO=true;//for gameOver (see method) (works better for intro across the board if just initialized to true
  Initial[0]=true; //sets initial run for lvl 0 to true
  I1=I2=I3=I4=I5=I6=false; //sets the other's initials to false
  for(int k=0;k<stream.length;k++){
    stream[k]=false;
  }
  for(int g=0;g<gbumper.length;g++){
    gbumper[g]=false;
  }
  sFirst=sInverse=sRising=false;
  sCount=0;
  sRotation=0.0;
  i1=loadImage("1.png");
  i2=loadImage("2.png");
  i3=loadImage("3.png");
  igo=loadImage("Go.png");
  ball=loadImage("Ball.png");
  for (int i=0; i<Bary.length; i++) { //just used to initialize all the bumper names
    Bary[i]=loadImage(Bname[i]);
  }
  for (int i = 0; i < las.length; i++){
    las[i]=loadImage(lasname[i]);
  }
  for (int u=0; u<gAll.length; u++) { //just used to initialize all the bumper names
    gAll[u]=0;
  }
  //gCount=gTimer=gcor=gcolor=0;
  advance = false; //sets advance to its default: false
  first = false; //sets first run through advance to false
  restart = false; //sets the gameover restart to false
  menuG= new Gif(this, "menuG.gif"); //initializes lvl 0 gifs
  names= new Gif(this, "Names.gif");
  title= new Gif(this, "Title.gif");
  space= new Gif(this, "Space.gif");
  gameOver= new Gif(this, "gameOver.gif");
  winner=new Gif(this, "Winner.gif");
  sline = new Gif(this,"scoreline.gif"); 
  sline.loop();
  Larray[0]=s0 = new Gif(this, "s0.gif");
  Larray[1]=s1 = new Gif(this, "s1.gif");
  Larray[2]=s2 = new Gif(this, "s2.gif");
  Larray[3]=s3 = new Gif(this, "s3.gif");
  Larray[4]=s4 = new Gif(this, "s4.gif");
  Larray[5]=s5 = new Gif(this, "s5.gif");
  Larray[6]=s6 = new Gif(this, "s6.gif");
  s7 = new Gif(this, "s7.gif");
  s8 = new Gif(this, "s8.gif");
  s9 = new Gif(this, "s9.gif");
  
  lvl = new Gif(this, "level.gif");
  lifeG= new Gif(this, "lives.gif");
  scores.add(s0);
  scores.add(s1);
  scores.add(s2);
  scores.add(s3);
  scores.add(s4);
  scores.add(s5);
  scores.add(s6);
  scores.add(s7);
  scores.add(s8);
  scores.add(s9);
  for (int i = 0; i < scores.size (); i ++) {
    scores.get(i).loop();
  }
  lvl.loop();
  AP[level] = minim.loadFile(trackTitle[level], 2048); //loads lvl 0 audiofile
  modulator=true; //sets modulator true (used to make space fade in and out)
  blur1=blur2=blur3=blur4=blur5=blur6=0; //sets blurs to 0 (used for fading in)
  testcor=loadImage("Coordinate.png");
  torment = new Player(); //torment?
  leftPressed=rightPressed=false;
}

void draw() {
  kill();
  if(!torment.getAlive()){
    renew();
  }
  if (lives==0&&level!=-1) {
    level=-1;
    first=true;
  }
  //IN BETWEEN LEVELS
  if (advance) { //if advancing to next level,
    nextLevel();
  }
  //each level has its own method
  else if (level==0) {
    levelZero();
  } else if (level==-1) {
    gameOver();
  } else if (level==1) {
    levelOne();
  } else if (level==2) {
    levelTwo();
  } else if (level==3) {
    levelThree();
  } else if (level==4) {
    levelFour();
  } else if (level==5) {
    levelFive();
  } else if (level==6) {
    levelSix();
  } else if (level==7) {
    win();
  }
  println("x-coordinate: " + mouseX + ", y-coordinate: " + mouseY);
}


void keyPressed() {
  if (keyCode == LEFT) {
    leftPressed = true;
  }
  if (keyCode == RIGHT) {
    rightPressed = true;
  }
  //testing
  if (key=='s') {
    increase = true;
  }
  if (key=='d') {
    decrease = true;
  }
}

void keyReleased() {
  if (level==0) {
    if (key == ' '&&!Initial[0]) { //!Initial[0] is to prevent it from calling this during countdown
      advance = true;
      first = true;
    }
  }else if(key==' '){
    shoot(torment.getRotation());
  }
  //For Testing Only
  if (key=='g') {
    lives=0;
  }
  if (key=='x') {
    glow(1);
  }
  if (key=='c') {
    glow(2);
  }
  if (key=='v') {
    glow(3);
  }
  if (key=='b') {
    glow(4);
  }
  if (key=='1') {
    wave(1);
  }
  if (key=='2') {
    wave(2);
  }
  if (key=='3') {
    bStreamOn(2);
  }
  if (key=='4') {
    bStreamOff(2);
  }
  if (key=='5') {
    miniball(3,false);
  }
  if (key=='6') {
    miniball(4,true,false,true,1);
  }
  if (key=='s') {
    increase = false;
  }
  if (key=='d') {
    decrease = false;
  }
  if (key=='f'){
    AP[level].skip(10000);
  }
  if (key=='n') {
    advance = true;
    first=true;
  }
  if (key=='w') {
    level=7;
    first=true;
  }
  //Testing Stops Here
  if (keyCode == LEFT) { 
    leftPressed = false;
  }
  if (keyCode == RIGHT) {
    rightPressed = false;
  }
  if (level > 0) {
    if (!keysbegan) {
      keysbegan = true;
    }
  }
  if (level==-1||level==7) {
    if (key == ' ') {
      restart=true;
    }
  }
}

void renew(){
  frameRate(30);
  level--;
 //  Initial[level]=true;
 //  minim.stop();
 //  AP[level] = minim.loadFile(trackTitle[level], 2048); //loads song file for corresponding level
  bullets.clear();
  o1s.clear(); //removes extra obstacles
  o2s.clear();
  o3s.clear();
  o4s.clear();
  o5s.clear();
  lives--;
  torment.rise();
  score-=(level*100)+100;
  if(lives!=0){
    first=true;
    advance=true;
  }
  for(int i=0;i<stream.length;i++){
    stream[i]=false;
  }
}
 
void nextLevel() {
  if (first) { //if first time performing nextLevel
    frameRate(30);
    minim.stop(); //stop the music!
    blur1=blur2=blur3=blur4=0; //resets blurs
    Initial[level]=true;
    if (level==0&&lives==5) {
      menuG.stop(); //stops main menu gifs
      title.stop();
      space.stop();
      names.stop();
      modulator=true; //resets modulator for future use
      //Initial[0]=true; //resets initial
    }
    first=false; //no longer first occurence of advance
  } //This sets up the count down
  if (counter<65) {
    background(0);
    if (counter<15) { //all this is just to blur in the 3, 2, 1, GO
      if (blur1<255&&counter<5) { //blurs in for first five frames
        tint(255, blur1);
        image(i3, 210, 210);
        tint(255, 255);
        blur1=blur1+60;
      } else if (blur1>=0&&counter>10) { //blurs out for last five frames
        tint(255, blur1);
        image(i3, 210, 210);
        tint(255, 255);
        blur1=blur1-60;
      } else {
        image(i3, 210, 210);
      }
    } else if (counter<30) {
      if (blur2<255&&counter<20) {
        tint(255, blur2);
        image(i2, 210, 210);
        tint(255, 255);
        blur2=blur2+60;
      } else if (blur2>=0&&counter>25) {
        tint(255, blur2);
        image(i2, 210, 210);
        tint(255, 255);
        blur2=blur2-60;
      } else {
        image(i2, 210, 210);
      }
    } else if (counter<45) {
      if (blur3<255&&counter<35) {
        tint(255, blur3);
        image(i1, 210, 210);
        tint(255, 255);
        blur3=blur3+60;
      } else if (blur3>=0&&counter>40) {
        tint(255, blur3);
        image(i1, 210, 210);
        tint(255, 255);
        blur3=blur3-60;
      } else {
        image(i1, 210, 210);
      }
    } else {
      if (blur4<255&&counter<50) {
        tint(255, blur4);
        image(igo, 130, 210);
        tint(255, 255);
        blur4=blur4+60;
      } else if (blur4>=0&&counter>59) {
        tint(255, blur4);
        image(igo, 130, 210);
        tint(255, 255);
        blur4=blur4-60;
      } else {
        image(igo, 130, 210);
      }
    }
    counter++; //countdown stops here, begins to start next level
  } else {
    counter=0;
    score+=level*100;
    if(score<0){
      score=0;
    }
    level++; //make level higher
    advance=false; //set advance false
    torment.setRotation(radians(270));
    AP[level] = minim.loadFile(trackTitle[level], 2048); //loads song file for corresponding level
    Initial[level]=true; //sets level's initial run to true
    //AP[level].play(); //**has been moved to each individual level method
  }
}

void levelZero() { //AKA: Menu
  int m = millis();
  if (Initial[0]) {
    frameRate(30);
    if (m>3600) { //after ~3 seconds initializes the background and starts song
      menuG.loop(); //loops gif
      AP[level].loop(); //loops song
      Initial[0]=false; //sets initial to false
    }
  } else {
    background(menuG); //sets background
    if (m>7800) { //sets of alex & cole on a timer
      if (!names.isPlaying()) { //if not already initialized the names is initialized
        names.loop();
      }
      if (blur1<255) {
        tint(255, blur1);
        image(names, 30, 570);
        tint(255, 255);
        blur1=blur1+2;
      } else {
        image(names, 30, 570);
      }
    }
    if (m>10800) {
      if (!title.isPlaying()) {
        title.loop();
      }
      if (blur2<255) {
        tint(255, blur2);
        image(title, 15, 10);
        tint(255, 255);
        blur2=blur2+2;
      } else {
        image(title, 15, 10);
      }
    }
    if (m>13500) {
      if (!space.isPlaying()) {
        space.loop();
      }
      int t = ((frameCount%63)*4); //sets timing for fade in and out
      if (modulator) { //determines if fading in or out
        tint(255, t);
      } else {
        tint(255, 250-t);
      }
      if (t==248) { //switches the fade in vs. fade out
        modulator=!modulator;
      }
      if (gO) { //to make sure space fades in rather than suddenly appearing
        if (t==0&&modulator) {
          image(space, 12, 80); //draws image
          gO=false;
        }
      } else {
        image(space, 12, 80); //draws image
      }
      tint(255, 255); //normalizes transparency
    }
  }
}

void gameOver() {
  keysbegan = false;
  if (first) {
    first=false;
    frameRate(60);
    if(score<0){
      score=0;
    }
    blur1=0;
    minim.stop();
    gameOver.loop();
    gOeffect = minim.loadFile("GameOver.mp3", 2048); 
    gOeffect.play();
  }
  background(0);
  if (blur1<255) {
    tint(255, blur1);
    image(gameOver, 40, 160);
    tint(255,77,0,blur1);
    pushMatrix();
    scale(.7);
    image(sline,220,550);
    score();
    popMatrix();
    noTint();
    blur1++;
  } else {
    image(gameOver, 40, 160);
    tint(255,77,0);
    pushMatrix();
    scale(.7);
    image(sline,220,550);
    score();
    popMatrix();
    noTint();
  }
  if (restart) {
    minim.stop();
    restart=false;
    modulator=true; //sets modulator true (used to make space fade in and out)
    blur1=blur2=blur3=blur4=0; //sets blurs to 0 (used for fading in)
    counter=0;
    lives=5;
    level=0;
    Initial[0]=true; //sets initial run to true
    AP[level] = minim.loadFile(trackTitle[level], 2048); //loads song file for corresponding level ie: 0
    gO=true;//gameOver t setter so that the space doesn't appear at the very start
    score=0;
    frameRate(30);
  }
}

void win(){
  keysbegan = false;
  if (first) {
    first=false;
    frameRate(60);
    blur1=0;
    minim.stop();
    winner.loop();
    winEffect = minim.loadFile("win.mp3", 2048); 
    winEffect.play();
  }
  background(0);
  if (blur1<255) {
    tint(255, blur1);
    image(winner, 50, 160);
    tint(0,111,255,blur1);
    pushMatrix();
    scale(.7);
    image(sline,220,450);
    score();
    popMatrix();
    noTint();
    blur1++;
  } else {
    image(winner, 50, 160);
    tint(0,111,255);
    pushMatrix();
    scale(.7);
    image(sline,220,450);
    score();
    popMatrix();
    noTint();
  }
  if (restart) {
    minim.stop();
    restart=false;
    modulator=true; //sets modulator true (used to make space fade in and out)
    blur1=blur2=blur3=blur4=0; //sets blurs to 0 (used for fading in)
    counter=0;
    lives=5;
    level=0;
    Initial[0]=true; //sets initial run to true
    AP[level] = minim.loadFile(trackTitle[level], 2048); //loads song file for corresponding level ie: 0
    gO=true;//gameOver t setter so that the space doesn't appear at the very start
    score=0;
    frameRate(30);
  }
}

void currscore(int a, int y) {
  int x = 390;
  int length = 1 + (int)Math.floor(Math.log10(Math.abs(a))) + ((a < 0)? 1 : 0);
  if (length < 2) {
    if (blur5 < 225) {
      tint(225, blur5);
      //Gif temp = scores[a];
      image(scores.get(a), x, y);
      noTint();
      blur5 += 6;
    } else {
      image(scores.get(a), x, y);
    }
  } else {
    if (length % 2 == 0) {
      x = x + 40 + 80*(length/2 - 1);
    } else {
      x += 80*(length/2);
    }
    if (blur5 < 225) {
      for (int o = 0; o < length; o ++) {
        int h = a%10;
        tint(255, blur5);
        image(scores.get(h), x, y);
        noTint();
        a = a/10;
        x -= 80;
      }
      blur5 +=6;
    } else {
      for (int o = 0; o < length; o ++) {
        int h = a%10;
        image(scores.get(h), x, y);
        a = a/10;
        x -= 80;
      }
    }
  }
}

void score() {
  if (increase) {
    score ++;
  }
  if (decrease && score > 0) {
  score --;}
  if (uno == 0) {
    blur5=0;
    uno++;
  } else {
    frameRate(90);
    if(level == -1){
      currscore(score, 620);
    }
    else if(level==7){
      currscore(score,520);
    }
    else{
      currscore(score,0);
    }
  }
}

void genericLevel(int r1,int g1,int b1,int r2,int g2,int b2,int glowr,int glowg,int glowb){
  if (Initial[level]) { //if initial time running this method...
    frameRate(90);
    AP[level].play(); //play song 1
    lasers=13-level;
    //ball.loop();
    Initial[level]=false; //no longer true
    bullets.clear();
    o1s.clear();  
    o2s.clear();
    o3s.clear();
    o4s.clear();
    o5s.clear();
  }
  background(0);
  if (blur1<255) {
    tint(r1, g1, b1, blur1);
    image(ball, 163, 125);
    //image(testcor,295,295);
    pushMatrix();
    scale(.7);
    score();
    popMatrix();
    noTint();
    laserleft();
    tint(r2+(gAll[12]/glowr), g2+(gAll[12]/glowg), b2+(gAll[12]/glowb), blur1);
    drawBumpers(1);
    tint(r2+(gAll[13]/glowr), g2+(gAll[13]/glowg), b2+(gAll[13]/glowb), blur1);
    drawBumpers(2);
    tint(r2+(gAll[14]/glowr), g2+(gAll[14]/glowg), b2+(gAll[14]/glowb), blur1);
    drawBumpers(3);
    tint(r2+(gAll[15]/glowr), g2+(gAll[15]/glowg), b2+(gAll[15]/glowb), blur1);
    drawBumpers(4);
    tint(r2,g2,b2);
    torment.draw(leftPressed, rightPressed);
    tint(r1, g1, b1, blur1);
    //    pushMatrix();
    //    //scale(2);
    //    lvlmessage();
    //    popMatrix();
    tint(r1, g1, b1, blur1);
    drawLives();
    noTint();
    blur1=blur1+2;
  } else {
    tint(r1, g1, b1);
    //    pushMatrix();
    //    //scale(2);
    //    lvlmessage();
    //    popMatrix();
    drawLives();
    image(ball, 163, 125);
    //image(testcor,295,295);
    pushMatrix();
    scale(.7);
    score();
    popMatrix();
    noTint();
    laserleft();
    tint(r2+(gAll[12]/glowr), g2+(gAll[12]/glowg), b2+(gAll[12]/glowb), blur1);
    drawBumpers(1);
    tint(r2+(gAll[13]/glowr), g2+(gAll[13]/glowg), b2+(gAll[13]/glowb), blur1);
    drawBumpers(2);
    tint(r2+(gAll[14]/glowr), g2+(gAll[14]/glowg), b2+(gAll[14]/glowb), blur1);
    drawBumpers(3);
    tint(r2+(gAll[15]/glowr), g2+(gAll[15]/glowg), b2+(gAll[15]/glowb), blur1);
    drawBumpers(4);
    noTint();
    tint(r2, g2, b2);
    torment.draw(leftPressed, rightPressed);
    noTint();
  }
  tint(r2, g2, b2);
  for (int p=0; p<bullets.size (); p++) {
    bullets.get(p).draw();
    if (!bullets.get(p).getAlive())
      bullets.remove(p);
  }
  for (int i=0; i<o1s.size (); i++) {
    o1s.get(i).draw();
    if (!o1s.get(i).getAlive())
      o1s.remove(i);
  }
  for (int j=0; j<o2s.size (); j++) {
    o2s.get(j).draw();
    if (!o2s.get(j).getAlive())
      o2s.remove(j);
  }
  for (int k=0; k<o3s.size (); k++) {
    o3s.get(k).draw();
    if (!o3s.get(k).getAlive())
      o3s.remove(k);
  }
  for (int n=0; n<o4s.size (); n++) {
    o4s.get(n).draw();
    if (!o4s.get(n).getAlive())
      o4s.remove(n);
  }
  for (int m=0; m<o5s.size (); m++) {
    o5s.get(m).draw();
    if (!o5s.get(m).getAlive())
      o5s.remove(m);
  }
  bulletStream();
  noTint();
  if(!AP[level].isPlaying()){
    if(level!=6){
      advance=true;
    }else{
      level++;
    }
    first=true;
  }
}

void levelOne() {
  genericLevel(125,255,130,10,216,15,1,10,1);
}

void levelTwo() {
  genericLevel(126,159,218,12,98,212,1,1,1);
}

void levelThree() {
  genericLevel(235,239,122,233,247,36,1,1,1);
}

void levelFour() {
  genericLevel(239,200,122,255,154,0,1,1,1);
}

void levelFive() {
  genericLevel(239,138,122,247,64,36,1,1,1);
}

void levelSix() {
  genericLevel(181,122,239,156,36,247,1,1,1);
}

void drawBumpers(int b) {
  translate(300, 300);
  rotate(radians(45));
  if(b==1){
    image(gImage(1), 270-gAll[8], -165-(gAll[8]/2));
  }
  rotate(radians(90));
  if(b==2){
    image(gImage(2), 270-gAll[9], -165-(gAll[9]/2));
  }
  rotate(radians(90));
  if(b==3){
    image(gImage(3), 270-gAll[10], -165-(gAll[10]/2));
  }
  rotate(radians(90));
  if(b==4){
    image(gImage(4), 270-gAll[11], -165-(gAll[11]/2));
  }
  rotate(radians(45));
  translate(-300, -300);
  //  image(gImage(),-170,450-gcor);
  //  image(gImage(),430-gcor,450-gcor);
  //  image(gImage(),-170,-180);
  //  image(gImage(),430-gcor,-180);
}

PImage gImage(int b) { //ie: glowed image
  if (gAll[b-1]!=0&&gAll[b+3]%2==0)
    gAll[b-1]--;
  if (gAll[b+3]!=0)
    gAll[b+3]--;
  if (gAll[b-1]==9||gAll[b-1]==1) {
    gAll[b+7]=5;
    gAll[b+11]=50;
    return Bary[1];
  } else if (gAll[b-1]==8||gAll[b-1]==2) {
    gAll[b+7]=10;
    gAll[b+11]=100;
    return Bary[2];
  } else if (gAll[b-1]==7||gAll[b-1]==3) {
    gAll[b+7]=15;
    gAll[b+11]=150;
    return Bary[3];
  } else if (gAll[b-1]==6||gAll[b-1]==4) {
    gAll[b+7]=20;
    gAll[b+11]=200;
    return Bary[4];
  } else if (gAll[b-1]==5) {
    gAll[b+7]=25;
    gAll[b+11]=250;
    return Bary[5];
  } else {
    gAll[b+7]=0;
    gAll[b+11]=0;
    return Bary[0];
  }
}

void glow(int b) {
  gbumper[b-1]=true;
  gAll[b-1]=10;//gcount
  gAll[b+3]=80;//gtimer
  gAll[b+7]=0;//gcor
  gAll[b+11]=0;//gcolor
}

//void lvlmessage() {
//  if (level > 0) {
//    if (!keysbegan) {
//      if (blur6 < 225) {
//        tint(225, blur6);
//        image(lvl, 50, 50);
//        image(scores.get(level),480,50);
//        blur6 += 3;
//      } else {
//        image(lvl, 50, 50);
//        image(scores.get(level),480,50);
//      }
//    }
//  } else {
//    blur6 = 0;
//  }
//}

void drawLives(){
  if(!lifeG.isPlaying()) { 
        lifeG.loop();
  }
  if(!lvl.isPlaying()) { 
        lvl.loop();
  }
  if(!Larray[lives].isPlaying()) {
        Larray[lives].loop();
  }
  if(!Larray[level].isPlaying()) {
        Larray[level].loop();
  }
  pushMatrix();
  scale(.6);
  image(lifeG,253,920);
  image(Larray[lives],675,920);
  popMatrix();
  pushMatrix();
  scale(.4);
  image(lvl,480,1310);
  image(Larray[level],930,1310);
  popMatrix();
}


void shoot(float r){
  if(lasers!=0){
    Bullet b = new Bullet(r);
    bullets.add(b);
    lasers--;
  }
}

void wave(int b) { //ie:make an obstacle one at b bumper
  Obstacle1 o = new Obstacle1(b);
  o1s.add(o);
}

void wave(int b,boolean r,boolean l) { //ie:make an obstacle one at b bumper
  Obstacle4 o = new Obstacle4(b,r,l);
  o4s.add(o);
}

void ball(int b){
  Obstacle2 o = new Obstacle2(b);
  o2s.add(o);
}

void ball(int b,boolean r,boolean l){
  Obstacle2 o = new Obstacle2(b,r,l);
  o2s.add(o);
}

void miniball(int b,boolean f){
  Obstacle3 o = new Obstacle3(b,f);
  o3s.add(o);
}

void miniball(int b,boolean f,boolean r,boolean l,float c){
  if(c==1){
    c=.5;
  }else{
    c=.9;
  }
  Obstacle3 o = new Obstacle3(b,f,r,l,c);
  o3s.add(o);
}

void bStreamOn(int b){
  stream[b-1]=true;
  sFirst=true;
}

void bStreamOff(int b){
  stream[b-1]=false;
}

void bulletStream(){
  for(int i=0;i<stream.length;i++){
    if(stream[i]){
      if(sFirst){
        sFirst=false;
        sRotation=0;
        sCount=0;
        sRising=sInverse=false;
      }
      if(sCount%2==0){
        Obstacle5 o=new Obstacle5(i+1,sInverse,sRotation);
        o5s.add(o);
      }
      
    }
  }
  sCount++;
  if(sRising){
    sRotation-=.04;
  }else{
    sRotation+=.04;
  }
  if(sRotation>2.4||sRotation<-2.4||sRotation==0){
    sRising=!sRising;
  }
  if(sRotation==0){
    sInverse=!sInverse;
  }
}


void kill(){ //used in draw method, add other obstacle arrays as necessary, lives are deducted in restart()
  int d1,d2,d3;
  float r1,r2,r3;
  d1=torment.getDistance();
  r1=torment.getRotation();
  for(int i=0;i<o1s.size();i++){
    d2=o1s.get(i).getDistance();
    r2=o1s.get(i).getRotation();
    if(d1>=d2&&d1<=d2+5&&r1<=r2+radians(45)&&r1>=r2-radians(45)){
      torment.die();
    }
    for(int h=0;h<bullets.size();h++){
      d3=bullets.get(h).getDistance();
      r3=bullets.get(h).getRotation();
      if(d3>=d2&&d3<=d2+20&&r3<=r2+radians(45)&&r3>=r2-radians(45)){
        o1s.get(i).die();
        bullets.get(h).die();
      }
    }
  }
  for(int j=0;j<o2s.size();j++){
    d2=o2s.get(j).getDistance();
    r2=o2s.get(j).getRotation();
    if(d1>=d2+2/*&&d1<=d2+80*/&&r1<=r2+radians(15)&&r1>=r2-radians(15)){
      torment.die();
    }
    for(int h=0;h<bullets.size();h++){
      d3=bullets.get(h).getDistance();
      r3=bullets.get(h).getRotation();
      if(d3>=d2+2&&r3<=r2+radians(15)&&r3>=r2-radians(15)){
        o2s.get(j).die();
        bullets.get(h).die();
      }
    }
  }
  for(int k=0;k<o3s.size();k++){
    d2=o3s.get(k).getDistance();
    r2=o3s.get(k).getRotation();
    if(d1>=d2/*&&d1<=d2+80*/&&r1<=r2+radians(5.7)&&r1>=r2-radians(5.7)){
      torment.die();
    }
    for(int h=0;h<bullets.size();h++){
      d3=bullets.get(h).getDistance();
      r3=bullets.get(h).getRotation();
      if(d3>=d2&&r3<=r2+radians(5.7)&&r3>=r2-radians(5.7)){
        o3s.get(k).die();
        bullets.get(h).die();
      }
    }
  }
  for(int n=0;n<o4s.size();n++){
    d2=o4s.get(n).getDistance();
    r2=o4s.get(n).getRotation();
    if(d1>=d2&&d1<=d2+3&&r1<=r2+radians(22)&&r1>=r2-radians(22)){
      torment.die();
    }
    for(int h=0;h<bullets.size();h++){
      d3=bullets.get(h).getDistance();
      r3=bullets.get(h).getRotation();
      if(d3>=d2&&d3<=d2+3&&r3<=r2+radians(22)&&r3>=r2-radians(22)){
        o4s.get(n).die();
        bullets.get(h).die();
      }
    }
  }
  for(int u=0;u<o5s.size();u++){
    d2=o5s.get(u).getDistance();
    r2=o5s.get(u).getRotation();
    if(d1>=d2&&r1<=r2+radians(2.9)&&r1>=r2-radians(2.9)){
      torment.die();
    }
  }
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
 
 -for way to draw, make arraylist of class objects
 -can have a draw method inside a class
 -tell in the draw method to draw each in the arraylist
 -when want new object, add to the arraylist (can set coordinates)
 */
