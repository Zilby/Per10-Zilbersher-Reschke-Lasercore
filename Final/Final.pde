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
boolean[] event = new boolean[1000000];
boolean shift=false;
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
  for(int e=0;e<event.length;e++){
    event[e]=true;
  }
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
  //println("x-coordinate: " + mouseX + ", y-coordinate: " + mouseY);
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
  if (key=='/'){
    shift=true;
  }
  //
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
  if(key=='.'){
    AP[level].skip(10000);
  }
  if(key==';'){
    AP[level].skip(-10000);
  }
  if(key=='/'){
    shift=false;
  }
  if (key=='1'){
    wave(3);
    printIt("wave(3)",3);
  }
  if (key=='2'){
    wave(2);
    printIt("wave(2)",2);
  }
  if (key=='3'){
    wave(1);
    printIt("wave(1)",1);
  }
  if (key=='4'){
    wave(4);
    printIt("wave(4)",4);
  }
  if (key=='q'){
    wave(3,false,true);
    printIt("wave(3,false,true)",3);
  }
  if (key=='e'){
    wave(2,false,true);
    printIt("wave(2,false,true)",2);
  }
  if (key=='t'){
    wave(1,false,true);
    printIt("wave(1,false,true)",1);
  }
  if (key=='u'){
    wave(4,false,true);
    printIt("wave(4,false,true)",4);
  }
  if (key=='w'){
    wave(3,true,false);
    printIt("wave(3,true,false)",3);
  }
  if (key=='r'){
    wave(2,true,false);
    printIt("wave(2,true,false)",2);
  }
  if (key=='y'){
    wave(1,true,false);
    printIt("wave(1,true,false)",1);
  }
  if (key=='i'){
    wave(4,true,false);
    printIt("wave(4,true,false)",4);
  }
  if (key=='5'){
    ball(3);
    printIt("ball(3)",3);
  }
  if (key=='6'){
    ball(2);
    printIt("ball(2)",2);
  }
  if (key=='7'){
    ball(1);
    printIt("ball(1)",1);
  }
  if (key=='8'){
    ball(4);
    printIt("ball(4)",4);
  }
  if (key=='a'){
    miniball(3,false);
    printIt("miniball(3,false)",3);
  }
  if (key=='s'){
    miniball(2,false);
    printIt("miniball(2,false)",2);
  }
  if (key=='d'){
    miniball(1,false);
    printIt("miniball(1,false)",1);
  }
  if (key=='f'){
    miniball(4,false);
    printIt("miniball(4,false)",4);
  }
  if (key=='g'){
    miniball(3,true);
    printIt("miniball(3,true)",3);
  }
  if (key=='h'){
    miniball(2,true);
    printIt("miniball(2,true)",2);
  }
  if (key=='j'){
    miniball(1,true);
    printIt("miniball(1,true)",1);
  }
  if (key=='k'){
    miniball(4,true);
    printIt("miniball(4,true)",4);
  }
//  if (key=='z'){
//    miniball(3,false);
//    println("miniball(3,false) "+AP[level].position());
//  }
//  if (key=='c'){
//    miniball(2,false);
//    println("miniball(2,false) "+AP[level].position());
//  }
//  if (key=='b'){
//    miniball(1,false);
//    println("miniball(1,false) "+AP[level].position());
//  }
//  if (key=='m'){
//    miniball(4,false);
//    println("miniball(4,false) "+AP[level].position());
//  }
  if (key=='z'&&!shift){
    miniball(3,false,false,true,1);
    printIt("miniball(3,false,false,true,1)",3);
  }
  if (key=='c'&&!shift){
    miniball(2,false,false,true,1);
    printIt("miniball(2,false,false,true,1)",2);
  }
  if (key=='b'&&!shift){
    miniball(1,false,false,true,1);
    printIt("miniball(1,false,false,true,1)",1);
  }
  if (key=='m'&&!shift){
    miniball(4,false,false,true,1);
    printIt("miniball(4,false,false,true,1)",4);
  }
  if (key=='x'&&!shift){
    miniball(3,false,true,false,1);
    printIt("miniball(3,false,true,false,1)",3);
  }
  if (key=='v'&&!shift){
    miniball(2,false,true,false,1);
    printIt("miniball(2,false,true,false,1)",2);
  }
  if (key=='n'&&!shift){
    miniball(1,false,true,false,1);
    printIt("miniball(1,false,true,false,1)",1);
  }
  if (key==','&&!shift){
    miniball(4,false,true,false,1);
    printIt("miniball(4,false,true,false,1)",4);
  }
  if (key=='z'&&shift){
    miniball(3,false,false,true,2);
    printIt("miniball(3,false,false,true,2)",3);
  }
  if (key=='c'&&shift){
    miniball(2,false,false,true,2);
    printIt("miniball(2,false,false,true,2)",2);
  }
  if (key=='b'&&shift){
    miniball(1,false,false,true,2);
    printIt("miniball(1,false,false,true,2)",1);
  }
  if (key=='m'&&shift){
    miniball(4,false,false,true,2);
    printIt("miniball(4,false,false,true,2)",4);
  }
  if (key=='x'&&shift){
    miniball(3,false,true,false,2);
    printIt("miniball(3,false,true,false,2)",3);
  }
  if (key=='v'&&shift){
    miniball(2,false,true,false,2);
    printIt("miniball(2,false,true,false,2)",2);
  }
  if (key=='n'&&shift){
    miniball(1,false,true,false,2);
    printIt("miniball(1,false,true,false,2)",1);
  }
  if (key==','&&shift){
    miniball(4,false,true,false,2);
    printIt("miniball(4,false,true,false,2)",4);
  }
  if (key=='o'){
    bStreamOn(3);
    printIt("bStreamOn(3)");
  }
  if (key=='p'){
    bStreamOn(2);
    printIt("bStreamOn(2)");
  }
  if (key=='['){
    bStreamOn(1);
    printIt("bStreamOn(1)");
  }
  if (key==']'){
    bStreamOn(4);
    printIt("bStreamOn(4)");
  }
  if (key=='9'){
    glow(3);
    printIt("glow(3)");
  }
  if (key=='0'){
    glow(4);
    printIt("glow(4)");
  }
  if (key=='-'){
    glow(1);
    printIt("glow(1)");
  }
  if (key=='='){
    glow(2);
    printIt("glow(2)");
  }
  if (key=='`'){
    glow();
    printIt("glow()");
  }
//  if (key=='g') {
//    lives=0;
//  }
//  if (key=='x') {
//    glow(1);
//  }
//  if (key=='c') {
//    glow(2);
//  }
//  if (key=='v') {
//    glow(3);
//  }
//  if (key=='b') {
//    glow(4);
//  }
//  if (key=='1') {
//    wave(1);
//  }
//  if (key=='2') {
//    wave(2);
//  }
//  if (key=='3') {
//    bStreamOn(2);
//  }
//  if (key=='4') {
//    bStreamOff(2);
//  }
//  if (key=='5') {
//    miniball(3,false);
//  }
//  if (key=='6') {
//    miniball(4,true,false,true,1);
//  }
//  if (key=='s') {
//    increase = false;
//  }
//  if (key=='d') {
//    decrease = false;
//  }
//  if (key=='f'){
//    AP[level].skip(10000);
//  }
//  if (key=='n') {
//    advance = true;
//    first=true;
//  }
//  if (key=='w') {
//    level=7;
//    first=true;
//  }
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

void printIt(String s){
  Random generator = new Random(); 
  int i = generator.nextInt(100) + 1;
  int j= AP[level].position()-i;
  println("if("+j+"<p&&event["+j+"]){ \n  "+s+"; \n  event["+j+"]=false; \n}");
}

void printIt(String s,int n){
  int k;
  if(n==2){
    k=4;
  }else if(n==4){
    k=2;
  }else{
    k=n;
  }
  Random generator = new Random(); 
  int i = generator.nextInt(100) + 1;
  int j= AP[level].position()-i;
  println("if("+j+"<p&&event["+j+"]){ \n  "+s+"; \n  glow("+k+"); \n  event["+j+"]=false; \n}");
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
    for(int e=0;e<event.length;e++){
      event[e]=true;
    }
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
    tint(255,blur1);
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

void levelOne() { //tempo 131 ie: 1beat/2183ms
  genericLevel(125,255,130,10,216,15,1,10,1);
  int p=AP[level].position();
//  if(x<p&&event[x]){
//    
//    event[x]=false;
//  }
  if(2136<p&&event[2136]){ 
  glow(3); 
  event[2136]=false; 
  }
  if(2600<p&&event[2600]){ 
    glow(4); 
    event[2600]=false; 
  }
  if(3018<p&&event[3018]){ 
    glow(1); 
    event[3018]=false; 
  }
  if(3529<p&&event[3529]){ 
    glow(2); 
    event[3529]=false; 
  }
  if(3993<p&&event[3993]){ 
    glow(3); 
    event[3993]=false; 
  }
  if(4458<p&&event[4458]){ 
    glow(4); 
    event[4458]=false; 
  }
  if(4876<p&&event[4876]){ 
    glow(1); 
    event[4876]=false; 
  }
  if(5387<p&&event[5387]){ 
    glow(2); 
    event[5387]=false; 
  }
  if(5851<p&&event[5851]){ 
    glow(3); 
    event[5851]=false; 
  }
  if(6315<p&&event[6315]){ 
    glow(4); 
    event[6315]=false; 
  }
  if(6733<p&&event[6733]){ 
    glow(1); 
    event[6733]=false; 
  }
  if(7151<p&&event[7151]){ 
    glow(2); 
    event[7151]=false; 
  }
  if(7616<p&&event[7616]){ 
    glow(3); 
    event[7616]=false; 
  }
  if(8080<p&&event[8080]){ 
    glow(4); 
    event[8080]=false; 
  }
  if(8591<p&&event[8591]){ 
    glow(1); 
    event[8591]=false; 
  }
  if(9009<p&&event[9009]){ 
    glow(2); 
    event[9009]=false; 
  }
  if(9520<p&&event[9520]){ 
    glow(3); 
    event[9520]=false; 
  }
  if(9938<p&&event[9938]){ 
    glow(4); 
    event[9938]=false; 
  }
  if(10402<p&&event[10402]){ 
    glow(1); 
    event[10402]=false; 
  }
  if(10866<p&&event[10866]){ 
    glow(2); 
    event[10866]=false; 
  }
  if(11331<p&&event[11331]){ 
    glow(3); 
    event[11331]=false; 
  }
  if(11795<p&&event[11795]){ 
    glow(4); 
    event[11795]=false; 
  }
  if(12213<p&&event[12213]){ 
    glow(1); 
    event[12213]=false; 
  }
  if(12678<p&&event[12678]){ 
    glow(2); 
    event[12678]=false; 
  }
  if(13188<p&&event[13188]){ 
    glow(3); 
    event[13188]=false; 
  }
  if(13606<p&&event[13606]){ 
    glow(4); 
    event[13606]=false; 
  }
  if(14024<p&&event[14024]){ 
    glow(1); 
    event[14024]=false; 
  }
  if(14532<p&&event[14582]){ 
    glow(); 
    event[14582]=false; 
  }
  if(15041<p&&event[15041]){ 
  wave(3); 
  event[15041]=false; 
  }
  if(15037<p&&event[15037]){ 
    glow(3); 
    event[15037]=false; 
  }
  if(15504<p&&event[15504]){ 
    wave(2); 
    event[15504]=false; 
  }
  if(15502<p&&event[15502]){ 
    glow(4); 
    event[15502]=false; 
  }
  if(15922<p&&event[15922]){ 
    wave(1); 
    event[15922]=false; 
  }
  if(15918<p&&event[15918]){ 
    glow(1); 
    event[15918]=false; 
  }
  if(16387<p&&event[16387]){ 
    glow(2); 
    event[16387]=false; 
  }
  if(16383<p&&event[16383]){ 
    wave(4); 
    event[16383]=false; 
  }
  if(16852<p&&event[16852]){ 
    glow(3); 
    event[16852]=false; 
  }
  if(16900<p&&event[16900]){ 
    wave(3); 
    event[16900]=false; 
  }
  if(17321<p&&event[17321]){ 
    wave(2); 
    event[17321]=false; 
  }
  if(17313<p&&event[17313]){ 
    glow(4); 
    event[17313]=false; 
  }
  if(17733<p&&event[17733]){ 
    glow(1); 
    event[17733]=false; 
  }
  if(17732<p&&event[17732]){ 
    wave(1); 
    event[17732]=false; 
  }
  if(18201<p&&event[18201]){ 
    glow(2); 
    event[18201]=false; 
  }
  if(18247<p&&event[18247]){ 
    wave(4); 
    event[18247]=false; 
  }
  if(18665<p&&event[18665]){ 
    glow(3); 
    event[18665]=false; 
  }
  if(18760<p&&event[18760]){ 
    wave(3); 
    event[18760]=false; 
  }
  if(19178<p&&event[19178]){ 
    glow(4); 
    event[19178]=false; 
  }
  if(19172<p&&event[19172]){ 
    wave(2); 
    event[19172]=false; 
  }
  if(19587<p&&event[19587]){ 
    wave(1); 
    event[19587]=false; 
  }
  if(19590<p&&event[19590]){ 
    glow(1); 
    event[19590]=false; 
  }
  if(20055<p&&event[20055]){ 
    wave(4); 
    event[20055]=false; 
  }
  if(20056<p&&event[20056]){ 
    glow(2); 
    event[20056]=false; 
  }
  if(20571<p&&event[20571]){ 
    glow(3); 
    event[20571]=false; 
  }
  if(20562<p&&event[20562]){ 
    wave(3); 
    event[20562]=false; 
  }
  if(20939<p&&event[20939]){ 
    wave(2); 
    event[20939]=false; 
  }
  if(20935<p&&event[20935]){ 
    glow(4); 
    event[20935]=false; 
  }
  if(21398<p&&event[21398]){ 
    wave(1); 
    event[21398]=false; 
  }
  if(21401<p&&event[21401]){ 
    glow(1); 
    event[21401]=false; 
  }
  if(21910<p&&event[21910]){ 
    glow(2); 
    event[21910]=false; 
  }
  if(21918<p&&event[21918]){ 
    wave(4); 
    event[21918]=false; 
  }
  if(22376<p&&event[22376]){ 
    wave(3); 
    event[22376]=false; 
  }
  if(22375<p&&event[22375]){ 
    glow(3); 
    event[22375]=false; 
  }
  if(22749<p&&event[22749]){ 
    wave(2); 
    event[22749]=false; 
  }
  if(22754<p&&event[22754]){ 
    glow(4); 
    event[22754]=false; 
  }
  if(23169<p&&event[23169]){ 
    glow(1); 
    event[23169]=false; 
  }
  if(23260<p&&event[23260]){ 
    wave(1); 
    event[23260]=false; 
  }
  if(23682<p&&event[23682]){ 
    wave(4); 
    event[23682]=false; 
  }
  if(23677<p&&event[23677]){ 
    glow(2); 
    event[23677]=false; 
  }
  if(24138<p&&event[24138]){ 
    glow(3); 
    event[24138]=false; 
  }
  if(24192<p&&event[24192]){ 
    wave(3); 
    event[24192]=false; 
  }
  if(24606<p&&event[24606]){ 
    wave(2); 
    event[24606]=false; 
  }
  if(24606<p&&event[24606]){ 
    glow(4); 
    event[24606]=false; 
  }
  if(25074<p&&event[25074]){ 
    wave(1); 
    event[25074]=false; 
  }
  if(25069<p&&event[25069]){ 
    glow(1); 
    event[25069]=false; 
  }
  if(25489<p&&event[25489]){ 
    glow(2); 
    event[25489]=false; 
  }
  if(25487<p&&event[25487]){ 
    wave(4); 
    event[25487]=false; 
  }
  if(25954<p&&event[25954]){ 
    wave(3); 
    event[25954]=false; 
  }
  if(25951<p&&event[25951]){ 
    glow(3); 
    event[25951]=false; 
  }
  if(26417<p&&event[26417]){ 
    wave(2); 
    event[26417]=false; 
  }
  if(26420<p&&event[26420]){ 
    glow(4); 
    event[26420]=false; 
  }
  if(26838<p&&event[26838]){ 
    glow(1); 
    event[26838]=false; 
  }
  if(26926<p&&event[26926]){ 
    wave(1); 
    event[26926]=false; 
  }
  if(27300<p&&event[27300]){ 
    wave(4); 
    event[27300]=false; 
  }
  if(27304<p&&event[27304]){ 
    glow(2); 
    event[27304]=false; 
  }
  if(27763<p&&event[27763]){ 
    glow(3); 
    event[27763]=false; 
  }
  if(27765<p&&event[27765]){ 
    wave(3); 
    event[27765]=false; 
  }
  if(28226<p&&event[28226]){ 
    wave(2); 
    event[28226]=false; 
  }
  if(28234<p&&event[28234]){ 
    glow(4); 
    event[28234]=false; 
  }
  if(28698<p&&event[28698]){ 
    glow(1); 
    event[28698]=false; 
  }
  if(28741<p&&event[28741]){ 
    wave(1); 
    event[28741]=false; 
  }
  if(29155<p&&event[29155]){ 
    glow(2); 
    event[29155]=false; 
  }
  if(29202<p&&event[29202]){ 
    wave(4); 
    event[29202]=false; 
  }
  if(29665<p&&event[29665]){ 
    glow(2); 
    event[29665]=false; 
  }
  if(29766<p&&event[29766]){ 
    wave(4); 
    event[29766]=false; 
  }
  if(30085<p&&event[30085]){ 
    glow(1); 
    event[30085]=false; 
  }
  if(30178<p&&event[30178]){ 
    wave(1); 
    event[30178]=false; 
  }
  if(30554<p&&event[30554]){ 
    glow(4); 
    event[30554]=false; 
  }
  if(30597<p&&event[30597]){ 
    wave(2); 
    event[30597]=false; 
  }
  if(31013<p&&event[31013]){ 
    glow(3); 
    event[31013]=false; 
  }
  if(31013<p&&event[31013]){ 
    wave(3); 
    event[31013]=false; 
  }
  if(31478<p&&event[31478]){ 
    wave(4); 
    event[31478]=false; 
  }
  if(31481<p&&event[31481]){ 
    glow(2); 
    event[31481]=false; 
  }
  if(31903<p&&event[31903]){ 
    glow(1); 
    event[31903]=false; 
  }
  if(31898<p&&event[31898]){ 
    wave(1); 
    event[31898]=false; 
  }
  if(32320<p&&event[32320]){ 
    glow(4); 
    event[32320]=false; 
  }
  if(32320<p&&event[32320]){ 
    wave(2); 
    event[32320]=false; 
  }
  if(32830<p&&event[32830]){ 
    glow(3); 
    event[32830]=false; 
  }
  if(32829<p&&event[32829]){ 
    wave(3); 
    event[32829]=false; 
  }
  if(33289<p&&event[33289]){ 
    wave(2); 
    event[33289]=false; 
  }
  if(33293<p&&event[33293]){ 
    glow(4); 
    event[33293]=false; 
  }
  if(33706<p&&event[33706]){ 
    wave(1); 
    event[33706]=false; 
  }
  if(33712<p&&event[33712]){ 
    glow(1); 
    event[33712]=false; 
  }
  if(34219<p&&event[34219]){ 
    wave(4); 
    event[34219]=false; 
  }
  if(34221<p&&event[34221]){ 
    glow(2); 
    event[34221]=false; 
  }
  if(34687<p&&event[34687]){ 
    wave(3); 
    event[34687]=false; 
  }
  if(34682<p&&event[34682]){ 
    glow(3); 
    event[34682]=false; 
  }
  if(35105<p&&event[35105]){ 
    wave(2); 
    event[35105]=false; 
  }
  if(35107<p&&event[35107]){ 
    glow(4); 
    event[35107]=false; 
  }
  if(35562<p&&event[35562]){ 
    wave(1); 
    event[35562]=false; 
  }
  if(35565<p&&event[35565]){ 
    glow(1); 
    event[35565]=false; 
  }
  if(36031<p&&event[36031]){ 
    glow(2); 
    event[36031]=false; 
  }
  if(36074<p&&event[36074]){ 
    wave(4); 
    event[36074]=false; 
  }
  if(36491<p&&event[36491]){ 
    glow(3); 
    event[36491]=false; 
  }
  if(36500<p&&event[36500]){ 
    wave(3); 
    event[36500]=false; 
  }
  if(31153<p&&event[31153]){ 
    wave(3); 
    event[31153]=false; 
  }
  if(32397<p&&event[32397]){ 
    wave(2); 
    event[32397]=false; 
  }
  if(11791<p&&event[11791]){ 
    glow(4); 
    event[11791]=false; 
  }
  //won
  if(37786<p&&event[37786]){ 
    wave(3); 
    glow(3); 
    event[37786]=false; 
  }
  if(37870<p&&event[37870]){ 
    wave(2); 
    glow(4); 
    event[37870]=false; 
  }
  if(38079<p&&event[38079]){ 
    wave(3); 
    glow(3); 
    event[38079]=false; 
  }
  if(38063<p&&event[38063]){ 
    wave(2); 
    glow(4); 
    event[38063]=false; 
  }
  if(38248<p&&event[38248]){ 
    wave(3); 
    glow(3); 
    event[38248]=false; 
  }
  if(38304<p&&event[38304]){ 
    wave(2); 
    glow(4); 
    event[38304]=false; 
  }
  if(38525<p&&event[38525]){ 
    wave(3); 
    glow(3); 
    event[38525]=false; 
  }
  if(38429<p&&event[38429]){ 
    wave(2); 
    glow(4); 
    event[38429]=false; 
  }
  if(38642<p&&event[38642]){ 
    wave(3); 
    glow(3); 
    event[38642]=false; 
  }
  if(38632<p&&event[38632]){ 
    wave(2); 
    glow(4); 
    event[38632]=false; 
  }
  if(38734<p&&event[38734]){ 
    wave(3); 
    glow(3); 
    event[38734]=false; 
  }
  if(38724<p&&event[38724]){ 
    wave(2); 
    glow(4); 
    event[38724]=false; 
  }
  if(39648<p&&event[39648]){ 
    wave(4); 
    glow(2); 
    event[39648]=false; 
  }
  if(39732<p&&event[39732]){ 
    wave(1); 
    glow(1); 
    event[39732]=false; 
  }
  if(39903<p&&event[39903]){ 
    wave(1); 
    glow(1); 
    event[39903]=false; 
  }
  if(39904<p&&event[39904]){ 
    wave(4); 
    glow(2); 
    event[39904]=false; 
  }
  if(40143<p&&event[40143]){ 
    wave(1); 
    glow(1); 
    event[40143]=false; 
  }
  if(40112<p&&event[40112]){ 
    wave(4); 
    glow(2); 
    event[40112]=false; 
  }
  if(40294<p&&event[40294]){ 
    wave(1); 
    glow(1); 
    event[40294]=false; 
  }
  if(40409<p&&event[40409]){ 
    wave(4); 
    glow(2); 
    event[40409]=false; 
  }
  if(40518<p&&event[40518]){ 
    wave(1); 
    glow(1); 
    event[40518]=false; 
  }
  if(40558<p&&event[40558]){ 
    wave(4); 
    glow(2); 
    event[40558]=false; 
  }
  if(41469<p&&event[41469]){ 
    wave(3); 
    glow(3); 
    event[41469]=false; 
  }
  if(41565<p&&event[41565]){ 
    wave(2); 
    glow(4); 
    event[41565]=false; 
  }
  if(41773<p&&event[41773]){ 
    wave(3); 
    glow(3); 
    event[41773]=false; 
  }
  if(41813<p&&event[41813]){ 
    wave(2); 
    glow(4); 
    event[41813]=false; 
  }
  if(41995<p&&event[41995]){ 
    wave(3); 
    glow(3); 
    event[41995]=false; 
  }
  if(41970<p&&event[41970]){ 
    wave(2); 
    glow(4); 
    event[41970]=false; 
  }
  if(42179<p&&event[42179]){ 
    wave(3); 
    glow(3); 
    event[42179]=false; 
  }
  if(42146<p&&event[42146]){ 
    wave(2); 
    glow(4); 
    event[42146]=false; 
  }
  if(42292<p&&event[42292]){ 
    wave(3); 
    glow(3); 
    event[42292]=false; 
  }
  if(42316<p&&event[42316]){ 
    wave(2); 
    glow(4); 
    event[42316]=false; 
  }
  if(42433<p&&event[42433]){ 
    wave(3); 
    glow(3); 
    event[42433]=false; 
  }
  if(42469<p&&event[42469]){ 
    wave(2); 
    glow(4); 
    event[42469]=false; 
  }
  if(43275<p&&event[43275]){ 
    wave(1); 
    glow(1); 
    event[43275]=false; 
  }
  if(43348<p&&event[43348]){ 
    wave(4); 
    glow(2); 
    event[43348]=false; 
  }
  if(43615<p&&event[43615]){ 
    wave(1); 
    glow(1); 
    event[43615]=false; 
  }
  if(43581<p&&event[43581]){ 
    wave(4); 
    glow(2); 
    event[43581]=false; 
  }
  if(43823<p&&event[43823]){ 
    wave(1); 
    glow(1); 
    event[43823]=false; 
  }
  if(43845<p&&event[43845]){ 
    wave(4); 
    glow(2); 
    event[43845]=false; 
  }
  if(43971<p&&event[43971]){ 
    wave(1); 
    glow(1); 
    event[43971]=false; 
  }
  if(44057<p&&event[44057]){ 
    wave(4); 
    glow(2); 
    event[44057]=false; 
  }
  if(44321<p&&event[44321]){ 
    wave(1); 
    glow(1); 
    event[44321]=false; 
  }
  if(44241<p&&event[44241]){ 
    wave(4); 
    glow(2); 
    event[44241]=false; 
  }
  if(44519<p&&event[44519]){ 
    wave(1); 
    glow(1); 
    event[44519]=false; 
  }
  if(44518<p&&event[44518]){ 
    wave(4); 
    glow(2); 
    event[44518]=false; 
  }
  if(45228<p&&event[45228]){ 
    wave(3); 
    glow(3); 
    event[45228]=false; 
  }
  if(45185<p&&event[45185]){ 
    wave(2); 
    glow(4); 
    event[45185]=false; 
  }
  if(45429<p&&event[45429]){ 
    wave(3); 
    glow(3); 
    event[45429]=false; 
  }
  if(45478<p&&event[45478]){ 
    wave(2); 
    glow(4); 
    event[45478]=false; 
  }
  if(45602<p&&event[45602]){ 
    wave(3); 
    glow(3); 
    event[45602]=false; 
  }
  if(45673<p&&event[45673]){ 
    wave(2); 
    glow(4); 
    event[45673]=false; 
  }
  if(45790<p&&event[45790]){ 
    wave(3); 
    glow(3); 
    event[45790]=false; 
  }
  if(45898<p&&event[45898]){ 
    wave(2); 
    glow(4); 
    event[45898]=false; 
  }
  if(45937<p&&event[45937]){ 
    wave(3); 
    glow(3); 
    event[45937]=false; 
  }
  if(45947<p&&event[45947]){ 
    wave(2); 
    glow(4); 
    event[45947]=false; 
  }
  if(46080<p&&event[46080]){ 
    wave(2); 
    glow(4); 
    event[46080]=false; 
  }
  if(46262<p&&event[46262]){ 
    wave(3); 
    glow(3); 
    event[46262]=false; 
  }
  if(46259<p&&event[46259]){ 
    wave(2); 
    glow(4); 
    event[46259]=false; 
  }
  if(47315<p&&event[47315]){ 
    wave(1); 
    glow(1); 
    event[47315]=false; 
  }
  if(47300<p&&event[47300]){ 
    wave(4); 
    glow(2); 
    event[47300]=false; 
  }
  if(47461<p&&event[47461]){ 
    wave(1); 
    glow(1); 
    event[47461]=false; 
  }
  if(47574<p&&event[47574]){ 
    wave(4); 
    glow(2); 
    event[47574]=false; 
  }
  if(47734<p&&event[47734]){ 
    wave(1); 
    glow(1); 
    event[47734]=false; 
  }
  if(47679<p&&event[47679]){ 
    wave(4); 
    glow(2); 
    event[47679]=false; 
  }
  if(47903<p&&event[47903]){ 
    wave(1); 
    glow(1); 
    event[47903]=false; 
  }
  if(47905<p&&event[47905]){ 
    wave(4); 
    glow(2); 
    event[47905]=false; 
  }
  if(48112<p&&event[48112]){ 
    wave(1); 
    glow(1); 
    event[48112]=false; 
  }
  if(48109<p&&event[48109]){ 
    wave(4); 
    glow(2); 
    event[48109]=false; 
  }
  if(48885<p&&event[48885]){ 
    wave(3); 
    glow(3); 
    event[48885]=false; 
  }
  if(48832<p&&event[48832]){ 
    wave(2); 
    glow(4); 
    event[48832]=false; 
  }
  if(49087<p&&event[49087]){ 
    wave(3); 
    glow(3); 
    event[49087]=false; 
  }
  if(49115<p&&event[49115]){ 
    wave(2); 
    glow(4); 
    event[49115]=false; 
  }
  if(49275<p&&event[49275]){ 
    wave(3); 
    glow(3); 
    event[49275]=false; 
  }
  if(49317<p&&event[49317]){ 
    wave(2); 
    glow(4); 
    event[49317]=false; 
  }
  if(49525<p&&event[49525]){ 
    wave(3); 
    glow(3); 
    event[49525]=false; 
  }
  if(49547<p&&event[49547]){ 
    wave(2); 
    glow(4); 
    event[49547]=false; 
  }
  if(49577<p&&event[49577]){ 
    wave(3); 
    glow(3); 
    event[49577]=false; 
  }
  if(49594<p&&event[49594]){ 
    wave(2); 
    glow(4); 
    event[49594]=false; 
  }
  if(49907<p&&event[49907]){ 
    wave(3); 
    glow(3); 
    event[49907]=false; 
  }
  if(49927<p&&event[49927]){ 
    wave(2); 
    glow(4); 
    event[49927]=false; 
  }
  if(50937<p&&event[50937]){ 
    wave(1); 
    glow(1); 
    event[50937]=false; 
  }
  if(50959<p&&event[50959]){ 
    wave(4); 
    glow(2); 
    event[50959]=false; 
  }
  if(51115<p&&event[51115]){ 
    wave(1); 
    glow(1); 
    event[51115]=false; 
  }
  if(51130<p&&event[51130]){ 
    wave(4); 
    glow(2); 
    event[51130]=false; 
  }
  if(51338<p&&event[51338]){ 
    wave(1); 
    glow(1); 
    event[51338]=false; 
  }
  if(51419<p&&event[51419]){ 
    wave(4); 
    glow(2); 
    event[51419]=false; 
  }
  if(51607<p&&event[51607]){ 
    wave(1); 
    glow(1); 
    event[51607]=false; 
  }
  if(51547<p&&event[51547]){ 
    wave(4); 
    glow(2); 
    event[51547]=false; 
  }
  if(51746<p&&event[51746]){ 
    wave(1); 
    glow(1); 
    event[51746]=false; 
  }
  if(51854<p&&event[51854]){ 
    wave(4); 
    glow(2); 
    event[51854]=false; 
  }
  if(52486<p&&event[52486]){ 
    wave(3); 
    glow(3); 
    event[52486]=false; 
  }
  if(52419<p&&event[52419]){ 
    wave(2); 
    glow(4); 
    event[52419]=false; 
  }
  //won2
  if(54362<p&&event[54362]){ 
    wave(1); 
    glow(1); 
    event[54362]=false; 
  }
  if(54429<p&&event[54429]){ 
    wave(4); 
    glow(2); 
    event[54429]=false; 
  }
  if(54369<p&&event[54369]){ 
    wave(2); 
    glow(4); 
    event[54369]=false; 
  }
  if(54817<p&&event[54817]){ 
    wave(1); 
    glow(1); 
    event[54817]=false; 
  }
  if(54812<p&&event[54812]){ 
    wave(4); 
    glow(2); 
    event[54812]=false; 
  }
  if(54772<p&&event[54772]){ 
    wave(2); 
    glow(4); 
    event[54772]=false; 
  }
  if(55267<p&&event[55267]){ 
    wave(1); 
    glow(1); 
    event[55267]=false; 
  }
  if(55321<p&&event[55321]){ 
    wave(4); 
    glow(2); 
    event[55321]=false; 
  }
  if(55277<p&&event[55277]){ 
    wave(2); 
    glow(4); 
    event[55277]=false; 
  }
  if(55680<p&&event[55680]){ 
    wave(4); 
    glow(2); 
    event[55680]=false; 
  }
  if(55682<p&&event[55682]){ 
    wave(1); 
    glow(1); 
    event[55682]=false; 
  }
  if(55742<p&&event[55742]){ 
    wave(2); 
    glow(4); 
    event[55742]=false; 
  }
  if(56127<p&&event[56127]){ 
    wave(4); 
    glow(2); 
    event[56127]=false; 
  }
  if(56155<p&&event[56155]){ 
    wave(1); 
    glow(1); 
    event[56155]=false; 
  }
  if(56163<p&&event[56163]){ 
    wave(2); 
    glow(4); 
    event[56163]=false; 
  }
  if(58100<p&&event[58100]){ 
    wave(4); 
    glow(2); 
    event[58100]=false; 
  }
  if(58118<p&&event[58118]){ 
    wave(3); 
    glow(3); 
    event[58118]=false; 
  }
  if(58101<p&&event[58101]){ 
    wave(1); 
    glow(1); 
    event[58101]=false; 
  }
  if(58466<p&&event[58466]){ 
    wave(4); 
    glow(2); 
    event[58466]=false; 
  }
  if(58463<p&&event[58463]){ 
    wave(3); 
    glow(3); 
    event[58463]=false; 
  }
  if(58471<p&&event[58471]){ 
    wave(1); 
    glow(1); 
    event[58471]=false; 
  }
  if(58970<p&&event[58970]){ 
    wave(3); 
    glow(3); 
    event[58970]=false; 
  }
  if(59033<p&&event[59033]){ 
    wave(1); 
    glow(1); 
    event[59033]=false; 
  }
  if(59292<p&&event[59292]){ 
    wave(4); 
    glow(2); 
    event[59292]=false; 
  }
  if(59448<p&&event[59448]){ 
    wave(3); 
    glow(3); 
    event[59448]=false; 
  }
  if(59360<p&&event[59360]){ 
    wave(1); 
    glow(1); 
    event[59360]=false; 
  }
  if(59801<p&&event[59801]){ 
    wave(4); 
    glow(2); 
    event[59801]=false; 
  }
  if(59800<p&&event[59800]){ 
    wave(1); 
    glow(1); 
    event[59800]=false; 
  }
  if(59870<p&&event[59870]){ 
    wave(3); 
    glow(3); 
    event[59870]=false; 
  }
  if(61694<p&&event[61694]){ 
    wave(4); 
    glow(2); 
    event[61694]=false; 
  }
  if(61825<p&&event[61825]){ 
    wave(3); 
    glow(3); 
    event[61825]=false; 
  }
  if(61736<p&&event[61736]){ 
    wave(2); 
    glow(4); 
    event[61736]=false; 
  }
  if(62221<p&&event[62221]){ 
    wave(3); 
    glow(3); 
    event[62221]=false; 
  }
  if(62190<p&&event[62190]){ 
    wave(4); 
    glow(2); 
    event[62190]=false; 
  }
  if(62213<p&&event[62213]){ 
    wave(2); 
    glow(4); 
    event[62213]=false; 
  }
  if(62572<p&&event[62572]){ 
    wave(4); 
    glow(2); 
    event[62572]=false; 
  }
  if(62657<p&&event[62657]){ 
    wave(3); 
    glow(3); 
    event[62657]=false; 
  }
  if(62680<p&&event[62680]){ 
    wave(2); 
    glow(4); 
    event[62680]=false; 
  }
  if(62985<p&&event[62985]){ 
    wave(4); 
    glow(2); 
    event[62985]=false; 
  }
  if(62996<p&&event[62996]){ 
    wave(2); 
    glow(4); 
    event[62996]=false; 
  }
  if(63099<p&&event[63099]){ 
    wave(3); 
    glow(3); 
    event[63099]=false; 
  }
  if(63517<p&&event[63517]){ 
    wave(4); 
    glow(2); 
    event[63517]=false; 
  }
  if(63569<p&&event[63569]){ 
    wave(3); 
    glow(3); 
    event[63569]=false; 
  }
  if(63564<p&&event[63564]){ 
    wave(2); 
    glow(4); 
    event[63564]=false; 
  }
  if(65383<p&&event[65383]){ 
    wave(3); 
    glow(3); 
    event[65383]=false; 
  }
  if(65419<p&&event[65419]){ 
    wave(2); 
    glow(4); 
    event[65419]=false; 
  }
  if(65388<p&&event[65388]){ 
    wave(1); 
    glow(1); 
    event[65388]=false; 
  }
  if(65573<p&&event[65573]){ 
    wave(3); 
    glow(3); 
    event[65573]=false; 
  }
  if(65615<p&&event[65615]){ 
    wave(2); 
    glow(4); 
    event[65615]=false; 
  }
  if(65607<p&&event[65607]){ 
    wave(1); 
    glow(1); 
    event[65607]=false; 
  }
  if(65801<p&&event[65801]){ 
    wave(3); 
    glow(3); 
    event[65801]=false; 
  }
  if(65849<p&&event[65849]){ 
    wave(1); 
    glow(1); 
    event[65849]=false; 
  }
  if(65853<p&&event[65853]){ 
    wave(2); 
    glow(4); 
    event[65853]=false; 
  }
  if(66055<p&&event[66055]){ 
    wave(2); 
    glow(4); 
    event[66055]=false; 
  }
  if(66130<p&&event[66130]){ 
    wave(1); 
    glow(1); 
    event[66130]=false; 
  }
  if(66143<p&&event[66143]){ 
    wave(3); 
    glow(3); 
    event[66143]=false; 
  }
  //won3
  if(67073<p&&event[67073]){ 
    wave(3); 
    glow(3); 
    event[67073]=false; 
  }
  if(67540<p&&event[67540]){ 
    wave(2); 
    glow(4); 
    event[67540]=false; 
  }
  if(68107<p&&event[68107]){ 
    wave(1); 
    glow(1); 
    event[68107]=false; 
  }
  if(68486<p&&event[68486]){ 
    wave(4); 
    glow(2); 
    event[68486]=false; 
  }
  if(68965<p&&event[68965]){ 
    wave(3); 
    glow(3); 
    event[68965]=false; 
  }
  if(69358<p&&event[69358]){ 
    wave(2); 
    glow(4); 
    event[69358]=false; 
  }
  if(69901<p&&event[69901]){ 
    wave(1); 
    glow(1); 
    event[69901]=false; 
  }
  if(70309<p&&event[70309]){ 
    wave(4); 
    glow(2); 
    event[70309]=false; 
  }
  if(70803<p&&event[70803]){ 
    wave(3); 
    glow(3); 
    event[70803]=false; 
  }
  if(71292<p&&event[71292]){ 
    wave(2); 
    glow(4); 
    event[71292]=false; 
  }
  if(71677<p&&event[71677]){ 
    wave(1); 
    glow(1); 
    event[71677]=false; 
  }
  if(72112<p&&event[72112]){ 
    wave(4); 
    glow(2); 
    event[72112]=false; 
  }
  if(72598<p&&event[72598]){ 
    wave(3); 
    glow(3); 
    event[72598]=false; 
  }
  if(72993<p&&event[72993]){ 
    wave(2); 
    glow(4); 
    event[72993]=false; 
  }
  if(73494<p&&event[73494]){ 
    wave(1); 
    glow(1); 
    event[73494]=false; 
  }
  if(73973<p&&event[73973]){ 
    wave(4); 
    glow(2); 
    event[73973]=false; 
  }
  if(74477<p&&event[74477]){ 
    wave(3); 
    glow(3); 
    event[74477]=false; 
  }
  if(74909<p&&event[74909]){ 
    wave(2); 
    glow(4); 
    event[74909]=false; 
  }
  if(75367<p&&event[75367]){ 
    wave(1); 
    glow(1); 
    event[75367]=false; 
  }
  if(75794<p&&event[75794]){ 
    wave(4); 
    glow(2); 
    event[75794]=false; 
  }
  if(76242<p&&event[76242]){ 
    wave(3); 
    glow(3); 
    event[76242]=false; 
  }
  if(76728<p&&event[76728]){ 
    wave(2); 
    glow(4); 
    event[76728]=false; 
  }
  if(77151<p&&event[77151]){ 
    wave(1); 
    glow(1); 
    event[77151]=false; 
  }
  if(77707<p&&event[77707]){ 
    wave(4); 
    glow(2); 
    event[77707]=false; 
  }
  if(78069<p&&event[78069]){ 
    wave(3); 
    glow(3); 
    event[78069]=false; 
  }
  if(78561<p&&event[78561]){ 
    wave(2); 
    glow(4); 
    event[78561]=false; 
  }
  if(79030<p&&event[79030]){ 
    wave(1); 
    glow(1); 
    event[79030]=false; 
  }
  if(79501<p&&event[79501]){ 
    wave(4); 
    glow(2); 
    event[79501]=false; 
  }
  if(80005<p&&event[80005]){ 
    wave(3); 
    glow(3); 
    event[80005]=false; 
  }
  if(80383<p&&event[80383]){ 
    wave(2); 
    glow(4); 
    event[80383]=false; 
  }
  if(80901<p&&event[80901]){ 
    wave(1); 
    glow(1); 
    event[80901]=false; 
  }
  if(81286<p&&event[81286]){ 
    wave(4); 
    glow(2); 
    event[81286]=false; 
  }
  if(81862<p&&event[81862]){ 
    wave(1); 
    glow(1); 
    event[81862]=false; 
  }
  if(82202<p&&event[82202]){ 
    wave(2); 
    glow(4); 
    event[82202]=false; 
  }
  if(82647<p&&event[82647]){ 
    wave(3); 
    glow(3); 
    event[82647]=false; 
  }
  if(83317<p&&event[83317]){ 
    wave(2); 
    glow(4); 
    event[83317]=false; 
  }
  if(83611<p&&event[83611]){ 
    wave(1); 
    glow(1); 
    event[83611]=false; 
  }
  if(84114<p&&event[84114]){ 
    wave(4); 
    glow(2); 
    event[84114]=false; 
  }
  if(84482<p&&event[84482]){ 
    wave(1); 
    glow(1); 
    event[84482]=false; 
  }
  if(84941<p&&event[84941]){ 
    wave(2); 
    glow(4); 
    event[84941]=false; 
  }
  if(85491<p&&event[85491]){ 
    wave(3); 
    glow(3); 
    event[85491]=false; 
  }
  if(85936<p&&event[85936]){ 
    wave(2); 
    glow(4); 
    event[85936]=false; 
  }
  if(86399<p&&event[86399]){ 
    wave(1); 
    glow(1); 
    event[86399]=false; 
  }
  if(86829<p&&event[86829]){ 
    wave(4); 
    glow(2); 
    event[86829]=false; 
  }
  if(87267<p&&event[87267]){ 
    wave(1); 
    glow(1); 
    event[87267]=false; 
  }
  if(87718<p&&event[87718]){ 
    wave(2); 
    glow(4); 
    event[87718]=false; 
  }
  if(88243<p&&event[88243]){ 
    wave(3); 
    glow(3); 
    event[88243]=false; 
  }
  if(88700<p&&event[88700]){ 
    wave(2); 
    glow(4); 
    event[88700]=false; 
  }
  if(89110<p&&event[89110]){ 
    wave(1); 
    glow(1); 
    event[89110]=false; 
  }
  if(89591<p&&event[89591]){ 
    wave(4); 
    glow(2); 
    event[89591]=false; 
  }
  if(90067<p&&event[90067]){ 
    wave(1); 
    glow(1); 
    event[90067]=false; 
  }
  if(90435<p&&event[90435]){ 
    wave(2); 
    glow(4); 
    event[90435]=false; 
  }
  if(90879<p&&event[90879]){ 
    wave(3); 
    glow(3); 
    event[90879]=false; 
  }
  if(91374<p&&event[91374]){ 
    wave(2); 
    glow(4); 
    event[91374]=false; 
  }
  if(91867<p&&event[91867]){ 
    wave(1); 
    glow(1); 
    event[91867]=false; 
  }
  if(92322<p&&event[92322]){ 
    wave(4); 
    glow(2); 
    event[92322]=false; 
  }
  if(92793<p&&event[92793]){ 
    wave(1); 
    glow(1); 
    event[92793]=false; 
  }
  if(93254<p&&event[93254]){ 
    wave(2); 
    glow(4); 
    event[93254]=false; 
  }
  if(93593<p&&event[93593]){ 
    wave(3); 
    glow(3); 
    event[93593]=false; 
  }
  if(94132<p&&event[94132]){ 
    wave(2); 
    glow(4); 
    event[94132]=false; 
  }
  if(94631<p&&event[94631]){ 
    wave(1); 
    glow(1); 
    event[94631]=false; 
  }
  if(95057<p&&event[95057]){ 
    wave(4); 
    glow(2); 
    event[95057]=false; 
  }
  if(95500<p&&event[95500]){ 
    wave(1); 
    glow(1); 
    event[95500]=false; 
  }
  if(95931<p&&event[95931]){ 
    wave(2); 
    glow(4); 
    event[95931]=false; 
  }
  if(96457<p&&event[96457]){ 
    wave(3); 
    glow(3); 
    event[96457]=false; 
  }
  if(96898<p&&event[96898]){ 
    wave(2); 
    glow(4); 
    event[96898]=false; 
  }
  if(97308<p&&event[97308]){ 
    wave(1); 
    glow(1); 
    event[97308]=false; 
  }
  if(97726<p&&event[97726]){ 
    wave(4); 
    glow(2); 
    event[97726]=false; 
  }
  if(98322<p&&event[98322]){ 
    wave(1); 
    glow(1); 
    event[98322]=false; 
  }
  if(98744<p&&event[98744]){ 
    wave(2); 
    glow(4); 
    event[98744]=false; 
  }
  if(99228<p&&event[99228]){ 
    wave(3); 
    glow(3); 
    event[99228]=false; 
  }
  if(99650<p&&event[99650]){ 
    wave(2); 
    glow(4); 
    event[99650]=false; 
  }
  if(100060<p&&event[100060]){ 
    wave(1); 
    glow(1); 
    event[100060]=false; 
  }
  if(100505<p&&event[100505]){ 
    wave(4); 
    glow(2); 
    event[100505]=false; 
  }
  if(100995<p&&event[100995]){ 
    wave(1); 
    glow(1); 
    event[100995]=false; 
  }
  if(101410<p&&event[101410]){ 
    wave(2); 
    glow(4); 
    event[101410]=false; 
  }
  if(101874<p&&event[101874]){ 
    wave(3); 
    glow(3); 
    event[101874]=false; 
  }
  if(102342<p&&event[102342]){ 
    wave(2); 
    glow(4); 
    event[102342]=false; 
  }
  if(102843<p&&event[102843]){ 
    wave(1); 
    glow(1); 
    event[102843]=false; 
  }
  if(103249<p&&event[103249]){ 
    wave(4); 
    glow(2); 
    event[103249]=false; 
  }
  //won4
  if(104835<p&&event[104835]){ 
    wave(2,false,true); 
    glow(4); 
    event[104835]=false; 
  }
  if(104870<p&&event[104870]){ 
    wave(3,false,true); 
    glow(3); 
    event[104870]=false; 
  }
  if(105016<p&&event[105016]){ 
    wave(3,true,false); 
    glow(3); 
    event[105016]=false; 
  }
  if(105073<p&&event[105073]){ 
    wave(2,true,false); 
    glow(4); 
    event[105073]=false; 
  }
  if(105301<p&&event[105301]){ 
    wave(2,false,true); 
    glow(4); 
    event[105301]=false; 
  }
  if(105301<p&&event[105301]){ 
    wave(3,false,true); 
    glow(3); 
    event[105301]=false; 
  }
  if(105519<p&&event[105519]){ 
    wave(3,true,false); 
    glow(3); 
    event[105519]=false; 
  }
  if(105531<p&&event[105531]){ 
    wave(2,true,false); 
    glow(4); 
    event[105531]=false; 
  }
  if(105761<p&&event[105761]){ 
    wave(3,false,true); 
    glow(3); 
    event[105761]=false; 
  }
  if(105775<p&&event[105775]){ 
    wave(2,false,true); 
    glow(4); 
    event[105775]=false; 
  }
  if(106068<p&&event[106068]){ 
    wave(3,true,false); 
    glow(3); 
    event[106068]=false; 
  }
  if(105992<p&&event[105992]){ 
    wave(2,true,false); 
    glow(4); 
    event[105992]=false; 
  }
  if(106245<p&&event[106245]){ 
    wave(3,false,true); 
    glow(3); 
    event[106245]=false; 
  }
  if(106309<p&&event[106309]){ 
    wave(2,false,true); 
    glow(4); 
    event[106309]=false; 
  }
  if(106500<p&&event[106500]){ 
    wave(3,true,false); 
    glow(3); 
    event[106500]=false; 
  }
  if(106560<p&&event[106560]){ 
    wave(2,true,false); 
    glow(4); 
    event[106560]=false; 
  }
  if(106701<p&&event[106701]){ 
    wave(2,false,true); 
    glow(4); 
    event[106701]=false; 
  }
  if(106718<p&&event[106718]){ 
    wave(3,false,true); 
    glow(3); 
    event[106718]=false; 
  }
  if(106992<p&&event[106992]){ 
    wave(3,true,false); 
    glow(3); 
    event[106992]=false; 
  }
  if(106997<p&&event[106997]){ 
    wave(2,true,false); 
    glow(4); 
    event[106997]=false; 
  }
  if(107177<p&&event[107177]){ 
    wave(3,false,true); 
    glow(3); 
    event[107177]=false; 
  }
  if(107213<p&&event[107213]){ 
    wave(2,false,true); 
    glow(4); 
    event[107213]=false; 
  }
  if(107368<p&&event[107368]){ 
    wave(3,true,false); 
    glow(3); 
    event[107368]=false; 
  }
  if(107406<p&&event[107406]){ 
    wave(2,true,false); 
    glow(4); 
    event[107406]=false; 
  }
  if(107563<p&&event[107563]){ 
    wave(3,false,true); 
    glow(3); 
    event[107563]=false; 
  }
  if(107679<p&&event[107679]){ 
    wave(2,false,true); 
    glow(4); 
    event[107679]=false; 
  }
  if(107909<p&&event[107909]){ 
    wave(3,true,false); 
    glow(3); 
    event[107909]=false; 
  }
  if(107864<p&&event[107864]){ 
    wave(2,true,false); 
    glow(4); 
    event[107864]=false; 
  }
  if(107991<p&&event[107991]){ 
    wave(2,false,true); 
    glow(4); 
    event[107991]=false; 
  }
  if(108002<p&&event[108002]){ 
    wave(3,false,true); 
    glow(3); 
    event[108002]=false; 
  }
  if(112227<p&&event[112227]){ 
    wave(3,false,true); 
    glow(3); 
    event[112227]=false; 
  }
  if(112238<p&&event[112238]){ 
    wave(2,false,true); 
    glow(4); 
    event[112238]=false; 
  }
  if(112478<p&&event[112478]){ 
    wave(3,true,false); 
    glow(3); 
    event[112478]=false; 
  }
  if(112400<p&&event[112400]){ 
    wave(2,true,false); 
    glow(4); 
    event[112400]=false; 
  }
  if(112636<p&&event[112636]){ 
    wave(2,false,true); 
    glow(4); 
    event[112636]=false; 
  }
  if(112631<p&&event[112631]){ 
    wave(3,false,true); 
    glow(3); 
    event[112631]=false; 
  }
  if(112934<p&&event[112934]){ 
    wave(3,true,false); 
    glow(3); 
    event[112934]=false; 
  }
  if(112882<p&&event[112882]){ 
    wave(2,true,false); 
    glow(4); 
    event[112882]=false; 
  }
  if(113185<p&&event[113185]){ 
    wave(3,false,true); 
    glow(3); 
    event[113185]=false; 
  }
  if(113178<p&&event[113178]){ 
    wave(2,false,true); 
    glow(4); 
    event[113178]=false; 
  }
  if(113277<p&&event[113277]){ 
    wave(3,true,false); 
    glow(3); 
    event[113277]=false; 
  }
  if(113461<p&&event[113461]){ 
    wave(2,true,false); 
    glow(4); 
    event[113461]=false; 
  }
  if(113619<p&&event[113619]){ 
    wave(3,false,true); 
    glow(3); 
    event[113619]=false; 
  }
  if(113611<p&&event[113611]){ 
    wave(2,false,true); 
    glow(4); 
    event[113611]=false; 
  }
  if(113882<p&&event[113882]){ 
    wave(3,true,false); 
    glow(3); 
    event[113882]=false; 
  }
  if(113785<p&&event[113785]){ 
    wave(2,true,false); 
    glow(4); 
    event[113785]=false; 
  }
  if(114100<p&&event[114100]){ 
    wave(3,false,true); 
    glow(3); 
    event[114100]=false; 
  }
  if(114100<p&&event[114100]){ 
    wave(2,false,true); 
    glow(4); 
    event[114100]=false; 
  }
  if(114227<p&&event[114227]){ 
    wave(3,true,false); 
    glow(3); 
    event[114227]=false; 
  }
  if(114265<p&&event[114265]){ 
    wave(2,true,false); 
    glow(4); 
    event[114265]=false; 
  }
  if(114520<p&&event[114520]){ 
    wave(3,false,true); 
    glow(3); 
    event[114520]=false; 
  }
  if(114484<p&&event[114484]){ 
    wave(2,false,true); 
    glow(4); 
    event[114484]=false; 
  }
  if(114725<p&&event[114725]){ 
    wave(3,true,false); 
    glow(3); 
    event[114725]=false; 
  }
  if(114731<p&&event[114731]){ 
    wave(2,true,false); 
    glow(4); 
    event[114731]=false; 
  }
  if(114917<p&&event[114917]){ 
    wave(3,false,true); 
    glow(3); 
    event[114917]=false; 
  }
  if(114942<p&&event[114942]){ 
    wave(2,false,true); 
    glow(4); 
    event[114942]=false; 
  }
  if(115193<p&&event[115193]){ 
    wave(3,true,false); 
    glow(3); 
    event[115193]=false; 
  }
  if(115234<p&&event[115234]){ 
    wave(2,true,false); 
    glow(4); 
    event[115234]=false; 
  }
  if(115424<p&&event[115424]){ 
    wave(2,false,true); 
    glow(4); 
    event[115424]=false; 
  }
  if(115407<p&&event[115407]){ 
    wave(3,false,true); 
    glow(3); 
    event[115407]=false; 
  }
  if(115471<p&&event[115471]){ 
    wave(3,true,false); 
    glow(3); 
    event[115471]=false; 
  }
  if(115516<p&&event[115516]){ 
    wave(2,true,false); 
    glow(4); 
    event[115516]=false; 
  }
  if(119391<p&&event[119391]){ 
    wave(2,false,true); 
    glow(4); 
    event[119391]=false; 
  }
  if(119372<p&&event[119372]){ 
    wave(3,false,true); 
    glow(3); 
    event[119372]=false; 
  }
  if(119615<p&&event[119615]){ 
    wave(3,true,false); 
    glow(3); 
    event[119615]=false; 
  }
  if(119607<p&&event[119607]){ 
    wave(2,true,false); 
    glow(4); 
    event[119607]=false; 
  }
  if(119901<p&&event[119901]){ 
    wave(3,false,true); 
    glow(3); 
    event[119901]=false; 
  }
  if(119920<p&&event[119920]){ 
    wave(2,false,true); 
    glow(4); 
    event[119920]=false; 
  }
  if(120135<p&&event[120135]){ 
    wave(3,true,false); 
    glow(3); 
    event[120135]=false; 
  }
  if(120060<p&&event[120060]){ 
    wave(2,true,false); 
    glow(4); 
    event[120060]=false; 
  }
  if(120316<p&&event[120316]){ 
    wave(3,false,true); 
    glow(3); 
    event[120316]=false; 
  }
  if(120348<p&&event[120348]){ 
    wave(2,false,true); 
    glow(4); 
    event[120348]=false; 
  }
  if(120579<p&&event[120579]){ 
    wave(3,true,false); 
    glow(3); 
    event[120579]=false; 
  }
  if(120613<p&&event[120613]){ 
    wave(2,true,false); 
    glow(4); 
    event[120613]=false; 
  }
  if(120735<p&&event[120735]){ 
    wave(2,false,true); 
    glow(4); 
    event[120735]=false; 
  }
  if(120846<p&&event[120846]){ 
    wave(3,false,true); 
    glow(3); 
    event[120846]=false; 
  }
  if(120949<p&&event[120949]){ 
    wave(3,true,false); 
    glow(3); 
    event[120949]=false; 
  }
  if(120949<p&&event[120949]){ 
    wave(2,true,false); 
    glow(4); 
    event[120949]=false; 
  }
  if(121246<p&&event[121246]){ 
    wave(2,false,true); 
    glow(4); 
    event[121246]=false; 
  }
  if(121285<p&&event[121285]){ 
    wave(3,false,true); 
    glow(3); 
    event[121285]=false; 
  }
  if(121531<p&&event[121531]){ 
    wave(2,true,false); 
    glow(4); 
    event[121531]=false; 
  }
  if(121534<p&&event[121534]){ 
    wave(3,true,false); 
    glow(3); 
    event[121534]=false; 
  }
  if(121685<p&&event[121685]){ 
    wave(2,false,true); 
    glow(4); 
    event[121685]=false; 
  }
  if(121638<p&&event[121638]){ 
    wave(3,false,true); 
    glow(3); 
    event[121638]=false; 
  }
  if(121925<p&&event[121925]){ 
    wave(2,true,false); 
    glow(4); 
    event[121925]=false; 
  }
  if(121950<p&&event[121950]){ 
    wave(3,true,false); 
    glow(3); 
    event[121950]=false; 
  }
  if(122161<p&&event[122161]){ 
    wave(2,false,true); 
    glow(4); 
    event[122161]=false; 
  }
  if(122183<p&&event[122183]){ 
    wave(3,false,true); 
    glow(3); 
    event[122183]=false; 
  }
  if(122439<p&&event[122439]){ 
    wave(3,true,false); 
    glow(3); 
    event[122439]=false; 
  }
  if(122438<p&&event[122438]){ 
    wave(2,true,false); 
    glow(4); 
    event[122438]=false; 
  }
  if(122532<p&&event[122532]){ 
    wave(2,false,true); 
    glow(4); 
    event[122532]=false; 
  }
  if(122593<p&&event[122593]){ 
    wave(3,false,true); 
    glow(3); 
    event[122593]=false; 
  }
  if(122823<p&&event[122823]){ 
    wave(3,true,false); 
    glow(3); 
    event[122823]=false; 
  }
  if(122884<p&&event[122884]){ 
    wave(2,true,false); 
    glow(4); 
    event[122884]=false; 
  }
  if(126726<p&&event[126726]){ 
    wave(2,false,true); 
    glow(4); 
    event[126726]=false; 
  }
  if(126701<p&&event[126701]){ 
    wave(3,false,true); 
    glow(3); 
    event[126701]=false; 
  }
  if(126995<p&&event[126995]){ 
    wave(3,true,false); 
    glow(3); 
    event[126995]=false; 
  }
  if(127005<p&&event[127005]){ 
    wave(2,true,false); 
    glow(4); 
    event[127005]=false; 
  }
  if(127136<p&&event[127136]){ 
    wave(3,false,true); 
    glow(3); 
    event[127136]=false; 
  }
  if(127194<p&&event[127194]){ 
    wave(2,false,true); 
    glow(4); 
    event[127194]=false; 
  }
  if(127425<p&&event[127425]){ 
    wave(2,true,false); 
    glow(4); 
    event[127425]=false; 
  }
  if(127399<p&&event[127399]){ 
    wave(3,true,false); 
    glow(3); 
    event[127399]=false; 
  }
  if(127654<p&&event[127654]){ 
    wave(2,false,true); 
    glow(4); 
    event[127654]=false; 
  }
  if(127675<p&&event[127675]){ 
    wave(3,false,true); 
    glow(3); 
    event[127675]=false; 
  }
  if(127860<p&&event[127860]){ 
    wave(2,true,false); 
    glow(4); 
    event[127860]=false; 
  }
  if(127906<p&&event[127906]){ 
    wave(3,true,false); 
    glow(3); 
    event[127906]=false; 
  }
  if(128101<p&&event[128101]){ 
    wave(2,false,true); 
    glow(4); 
    event[128101]=false; 
  }
  if(128123<p&&event[128123]){ 
    wave(3,false,true); 
    glow(3); 
    event[128123]=false; 
  }
  if(128320<p&&event[128320]){ 
    wave(3,true,false); 
    glow(3); 
    event[128320]=false; 
  }
  if(128303<p&&event[128303]){ 
    wave(2,true,false); 
    glow(4); 
    event[128303]=false; 
  }
  if(128518<p&&event[128518]){ 
    wave(2,false,true); 
    glow(4); 
    event[128518]=false; 
  }
  if(128579<p&&event[128579]){ 
    wave(3,false,true); 
    glow(3); 
    event[128579]=false; 
  }
  if(128742<p&&event[128742]){ 
    wave(3,true,false); 
    glow(3); 
    event[128742]=false; 
  }
  if(128777<p&&event[128777]){ 
    wave(2,true,false); 
    glow(4); 
    event[128777]=false; 
  }
  if(128985<p&&event[128985]){ 
    wave(2,false,true); 
    glow(4); 
    event[128985]=false; 
  }
  if(129025<p&&event[129025]){ 
    wave(3,false,true); 
    glow(3); 
    event[129025]=false; 
  }
  if(129213<p&&event[129213]){ 
    wave(2,true,false); 
    glow(4); 
    event[129213]=false; 
  }
  if(129293<p&&event[129293]){ 
    wave(3,true,false); 
    glow(3); 
    event[129293]=false; 
  }
  if(129452<p&&event[129452]){ 
    wave(2,false,true); 
    glow(4); 
    event[129452]=false; 
  }
  if(129420<p&&event[129420]){ 
    wave(3,false,true); 
    glow(3); 
    event[129420]=false; 
  }
  if(129643<p&&event[129643]){ 
    wave(2,true,false); 
    glow(4); 
    event[129643]=false; 
  }
  if(129632<p&&event[129632]){ 
    wave(3,true,false); 
    glow(3); 
    event[129632]=false; 
  }
  if(129946<p&&event[129946]){ 
    wave(2,false,true); 
    glow(4); 
    event[129946]=false; 
  }
  if(129937<p&&event[129937]){ 
    wave(3,false,true); 
    glow(3); 
    event[129937]=false; 
  }
  if(130141<p&&event[130141]){ 
    wave(3,true,false); 
    glow(3); 
    event[130141]=false; 
  }
  if(130160<p&&event[130160]){ 
    wave(2,true,false); 
    glow(4); 
    event[130160]=false; 
  }
  //won5
  if(109044<p&&event[109044]){ 
    wave(4,false,true); 
    glow(2); 
    event[109044]=false; 
  }
  if(109076<p&&event[109076]){ 
    wave(1,false,true); 
    glow(1); 
    event[109076]=false; 
  }
  if(109267<p&&event[109267]){ 
    wave(4,true,false); 
    glow(2); 
    event[109267]=false; 
  }
  if(109329<p&&event[109329]){ 
    wave(1,true,false); 
    glow(1); 
    event[109329]=false; 
  }
  if(109463<p&&event[109463]){ 
    wave(4,false,true); 
    glow(2); 
    event[109463]=false; 
  }
  if(109522<p&&event[109522]){ 
    wave(1,false,true); 
    glow(1); 
    event[109522]=false; 
  }
  if(111491<p&&event[111491]){ 
    wave(4,false,true); 
    glow(2); 
    event[111491]=false; 
  }
  if(111492<p&&event[111492]){ 
    wave(1,false,true); 
    glow(1); 
    event[111492]=false; 
  }
  if(116381<p&&event[116381]){ 
    wave(4,false,true); 
    glow(2); 
    event[116381]=false; 
  }
  if(116440<p&&event[116440]){ 
    wave(1,false,true); 
    glow(1); 
    event[116440]=false; 
  }
  if(116669<p&&event[116669]){ 
    wave(4,true,false); 
    glow(2); 
    event[116669]=false; 
  }
  if(116620<p&&event[116620]){ 
    wave(1,true,false); 
    glow(1); 
    event[116620]=false; 
  }
  if(116782<p&&event[116782]){ 
    wave(1,false,true); 
    glow(1); 
    event[116782]=false; 
  }
  if(116847<p&&event[116847]){ 
    wave(4,false,true); 
    glow(2); 
    event[116847]=false; 
  }
  if(118141<p&&event[118141]){ 
    wave(1,true,false); 
    glow(1); 
    event[118141]=false; 
  }
  if(118187<p&&event[118187]){ 
    wave(4,true,false); 
    glow(2); 
    event[118187]=false; 
  }
  if(118417<p&&event[118417]){ 
    wave(4,false,true); 
    glow(2); 
    event[118417]=false; 
  }
  if(118405<p&&event[118405]){ 
    wave(1,false,true); 
    glow(1); 
    event[118405]=false; 
  }
  if(123927<p&&event[123927]){ 
    wave(4,false,true); 
    glow(2); 
    event[123927]=false; 
  }
  if(123901<p&&event[123901]){ 
    wave(1,false,true); 
    glow(1); 
    event[123901]=false; 
  }
  if(124000<p&&event[124000]){ 
    wave(1,true,false); 
    glow(1); 
    event[124000]=false; 
  }
  if(124056<p&&event[124056]){ 
    wave(4,true,false); 
    glow(2); 
    event[124056]=false; 
  }
  if(124181<p&&event[124181]){ 
    wave(4,false,true); 
    glow(2); 
    event[124181]=false; 
  }
  if(124223<p&&event[124223]){ 
    wave(1,false,true); 
    glow(1); 
    event[124223]=false; 
  }
  if(126026<p&&event[126026]){ 
    wave(1,true,false); 
    glow(1); 
    event[126026]=false; 
  }
  if(126059<p&&event[126059]){ 
    wave(4,true,false); 
    glow(2); 
    event[126059]=false; 
  }
  if(126252<p&&event[126252]){ 
    wave(4,false,true); 
    glow(2); 
    event[126252]=false; 
  }
  if(126311<p&&event[126311]){ 
    wave(1,false,true); 
    glow(1); 
    event[126311]=false; 
  }
  if(126476<p&&event[126476]){ 
    wave(1,true,false); 
    glow(1); 
    event[126476]=false; 
  }
  if(126462<p&&event[126462]){ 
    wave(4,true,false); 
    glow(2); 
    event[126462]=false; 
  }
  if(131047<p&&event[131047]){ 
    wave(4,true,false); 
    glow(2); 
    event[131047]=false; 
  }
  if(131070<p&&event[131070]){ 
    wave(1,true,false); 
    glow(1); 
    event[131070]=false; 
  }
  if(131606<p&&event[131606]){ 
    wave(1,false,true); 
    glow(1); 
    event[131606]=false; 
  }
  if(131551<p&&event[131551]){ 
    wave(4,false,true); 
    glow(2); 
    event[131551]=false; 
  }
  if(132771<p&&event[132771]){ 
    wave(4,true,false); 
    glow(2); 
    event[132771]=false; 
  }
  if(132797<p&&event[132797]){ 
    wave(1,true,false); 
    glow(1); 
    event[132797]=false; 
  }
  if(133124<p&&event[133124]){ 
    wave(4,false,true); 
    glow(2); 
    event[133124]=false; 
  }
  if(133040<p&&event[133040]){ 
    wave(1,false,true); 
    glow(1); 
    event[133040]=false; 
  }
  //won6
  if(134031<p&&event[134031]){ 
    wave(2); 
    glow(4); 
    event[134031]=false; 
  }
  if(134060<p&&event[134060]){ 
    wave(3); 
    glow(3); 
    event[134060]=false; 
  }
  if(134273<p&&event[134273]){ 
    wave(3); 
    glow(3); 
    event[134273]=false; 
  }
  if(134242<p&&event[134242]){ 
    wave(2); 
    glow(4); 
    event[134242]=false; 
  }
  if(134443<p&&event[134443]){ 
    wave(2); 
    glow(4); 
    event[134443]=false; 
  }
  if(134536<p&&event[134536]){ 
    wave(3); 
    glow(3); 
    event[134536]=false; 
  }
  if(134717<p&&event[134717]){ 
    wave(3); 
    glow(3); 
    event[134717]=false; 
  }
  if(134699<p&&event[134699]){ 
    wave(2); 
    glow(4); 
    event[134699]=false; 
  }
  if(135000<p&&event[135000]){ 
    wave(3); 
    glow(3); 
    event[135000]=false; 
  }
  if(134976<p&&event[134976]){ 
    wave(2); 
    glow(4); 
    event[134976]=false; 
  }
  if(135152<p&&event[135152]){ 
    wave(3); 
    glow(3); 
    event[135152]=false; 
  }
  if(135262<p&&event[135262]){ 
    wave(2); 
    glow(4); 
    event[135262]=false; 
  }
  if(135453<p&&event[135453]){ 
    wave(3); 
    glow(3); 
    event[135453]=false; 
  }
  if(135407<p&&event[135407]){ 
    wave(2); 
    glow(4); 
    event[135407]=false; 
  }
  if(135649<p&&event[135649]){ 
    wave(3); 
    glow(3); 
    event[135649]=false; 
  }
  if(135619<p&&event[135619]){ 
    wave(2); 
    glow(4); 
    event[135619]=false; 
  }
  if(135804<p&&event[135804]){ 
    wave(3); 
    glow(3); 
    event[135804]=false; 
  }
  if(135863<p&&event[135863]){ 
    wave(2); 
    glow(4); 
    event[135863]=false; 
  }
  if(136102<p&&event[136102]){ 
    wave(3); 
    glow(3); 
    event[136102]=false; 
  }
  if(136111<p&&event[136111]){ 
    wave(2); 
    glow(4); 
    event[136111]=false; 
  }
  if(136390<p&&event[136390]){ 
    wave(2); 
    glow(4); 
    event[136390]=false; 
  }
  if(136365<p&&event[136365]){ 
    wave(3); 
    glow(3); 
    event[136365]=false; 
  }
  if(136537<p&&event[136537]){ 
    wave(2); 
    glow(4); 
    event[136537]=false; 
  }
  if(136502<p&&event[136502]){ 
    wave(3); 
    glow(3); 
    event[136502]=false; 
  }
  if(136811<p&&event[136811]){ 
    wave(3); 
    glow(3); 
    event[136811]=false; 
  }
  if(136819<p&&event[136819]){ 
    wave(2); 
    glow(4); 
    event[136819]=false; 
  }
  if(136965<p&&event[136965]){ 
    wave(3); 
    glow(3); 
    event[136965]=false; 
  }
  if(137011<p&&event[137011]){ 
    wave(2); 
    glow(4); 
    event[137011]=false; 
  }
  if(138290<p&&event[138290]){ 
    wave(1); 
    glow(1); 
    event[138290]=false; 
  }
  if(138283<p&&event[138283]){ 
    wave(4); 
    glow(2); 
    event[138283]=false; 
  }
  if(138592<p&&event[138592]){ 
    wave(1); 
    glow(1); 
    event[138592]=false; 
  }
  if(138591<p&&event[138591]){ 
    wave(4); 
    glow(2); 
    event[138591]=false; 
  }
  if(138842<p&&event[138842]){ 
    wave(1); 
    glow(1); 
    event[138842]=false; 
  }
  if(138801<p&&event[138801]){ 
    wave(4); 
    glow(2); 
    event[138801]=false; 
  }
  if(139490<p&&event[139490]){ 
    wave(1); 
    glow(1); 
    event[139490]=false; 
  }
  if(139562<p&&event[139562]){ 
    wave(4); 
    glow(2); 
    event[139562]=false; 
  }
  if(139983<p&&event[139983]){ 
    wave(1); 
    glow(1); 
    event[139983]=false; 
  }
  if(139992<p&&event[139992]){ 
    wave(4); 
    glow(2); 
    event[139992]=false; 
  }
  if(140537<p&&event[140537]){ 
    wave(1); 
    glow(1); 
    event[140537]=false; 
  }
  if(140491<p&&event[140491]){ 
    wave(4); 
    glow(2); 
    event[140491]=false; 
  }
  if(140856<p&&event[140856]){ 
    wave(1); 
    glow(1); 
    event[140856]=false; 
  }
  if(140860<p&&event[140860]){ 
    wave(4); 
    glow(2); 
    event[140860]=false; 
  }
  if(142014<p&&event[142014]){ 
    wave(3); 
    glow(3); 
    event[142014]=false; 
  }
  if(142047<p&&event[142047]){ 
    wave(4); 
    glow(2); 
    event[142047]=false; 
  }
  if(142259<p&&event[142259]){ 
    wave(3); 
    glow(3); 
    event[142259]=false; 
  }
  if(142285<p&&event[142285]){ 
    wave(4); 
    glow(2); 
    event[142285]=false; 
  }
  if(142523<p&&event[142523]){ 
    wave(3); 
    glow(3); 
    event[142523]=false; 
  }
  if(142553<p&&event[142553]){ 
    wave(4); 
    glow(2); 
    event[142553]=false; 
  }
  if(142747<p&&event[142747]){ 
    wave(3); 
    glow(3); 
    event[142747]=false; 
  }
  if(142745<p&&event[142745]){ 
    wave(4); 
    glow(2); 
    event[142745]=false; 
  }
  if(142905<p&&event[142905]){ 
    wave(3); 
    glow(3); 
    event[142905]=false; 
  }
  if(142928<p&&event[142928]){ 
    wave(4); 
    glow(2); 
    event[142928]=false; 
  }
  if(143225<p&&event[143225]){ 
    wave(3); 
    glow(3); 
    event[143225]=false; 
  }
  if(143149<p&&event[143149]){ 
    wave(4); 
    glow(2); 
    event[143149]=false; 
  }
  if(143510<p&&event[143510]){ 
    wave(3); 
    glow(3); 
    event[143510]=false; 
  }
  if(143493<p&&event[143493]){ 
    wave(4); 
    glow(2); 
    event[143493]=false; 
  }
  if(143703<p&&event[143703]){ 
    wave(4); 
    glow(2); 
    event[143703]=false; 
  }
  if(143650<p&&event[143650]){ 
    wave(3); 
    glow(3); 
    event[143650]=false; 
  }
  if(143949<p&&event[143949]){ 
    wave(4); 
    glow(2); 
    event[143949]=false; 
  }
  if(143909<p&&event[143909]){ 
    wave(3); 
    glow(3); 
    event[143909]=false; 
  }
  if(144129<p&&event[144129]){ 
    wave(3); 
    glow(3); 
    event[144129]=false; 
  }
  if(144193<p&&event[144193]){ 
    wave(4); 
    glow(2); 
    event[144193]=false; 
  }
  if(144326<p&&event[144326]){ 
    wave(3); 
    glow(3); 
    event[144326]=false; 
  }
  if(144433<p&&event[144433]){ 
    wave(4); 
    glow(2); 
    event[144433]=false; 
  }
  if(145836<p&&event[145836]){ 
    wave(2); 
    glow(4); 
    event[145836]=false; 
  }
  if(145856<p&&event[145856]){ 
    wave(1); 
    glow(1); 
    event[145856]=false; 
  }
  if(145993<p&&event[145993]){ 
    wave(2); 
    glow(4); 
    event[145993]=false; 
  }
  if(146012<p&&event[146012]){ 
    wave(1); 
    glow(1); 
    event[146012]=false; 
  }
  if(146134<p&&event[146134]){ 
    wave(2); 
    glow(4); 
    event[146134]=false; 
  }
  if(146143<p&&event[146143]){ 
    wave(1); 
    glow(1); 
    event[146143]=false; 
  }
  if(147795<p&&event[147795]){ 
    wave(1); 
    glow(1); 
    event[147795]=false; 
  }
  if(147885<p&&event[147885]){ 
    wave(4); 
    glow(2); 
    event[147885]=false; 
  }
  if(147857<p&&event[147857]){ 
    wave(3); 
    glow(3); 
    event[147857]=false; 
  }
  if(147842<p&&event[147842]){ 
    wave(2); 
    glow(4); 
    event[147842]=false; 
  }
  if(148206<p&&event[148206]){ 
    wave(1); 
    glow(1); 
    event[148206]=false; 
  }
  if(148268<p&&event[148268]){ 
    wave(2); 
    glow(4); 
    event[148268]=false; 
  }
  if(148299<p&&event[148299]){ 
    wave(3); 
    glow(3); 
    event[148299]=false; 
  }
  if(148317<p&&event[148317]){ 
    wave(4); 
    glow(2); 
    event[148317]=false; 
  }
  if(148738<p&&event[148738]){ 
    wave(4); 
    glow(2); 
    event[148738]=false; 
  }
  if(148743<p&&event[148743]){ 
    wave(2); 
    glow(4); 
    event[148743]=false; 
  }
  if(148776<p&&event[148776]){ 
    wave(1); 
    glow(1); 
    event[148776]=false; 
  }
  if(148757<p&&event[148757]){ 
    wave(3); 
    glow(3); 
    event[148757]=false; 
  }
  //won6 
  if(163335<p&&event[163335]){ 
    wave(3); 
    glow(3); 
    event[163335]=false; 
  }
  if(163713<p&&event[163713]){ 
    wave(2); 
    glow(4); 
    event[163713]=false; 
  }
  if(164258<p&&event[164258]){ 
    wave(1); 
    glow(1); 
    event[164258]=false; 
  }
  if(164700<p&&event[164700]){ 
    wave(4); 
    glow(2); 
    event[164700]=false; 
  }
  if(165127<p&&event[165127]){ 
    wave(3); 
    glow(3); 
    event[165127]=false; 
  }
  if(165553<p&&event[165553]){ 
    wave(2); 
    glow(4); 
    event[165553]=false; 
  }
  if(166105<p&&event[166105]){ 
    wave(1); 
    glow(1); 
    event[166105]=false; 
  }
  if(166605<p&&event[166605]){ 
    wave(4); 
    glow(2); 
    event[166605]=false; 
  }
  if(167021<p&&event[167021]){ 
    wave(3); 
    glow(3); 
    event[167021]=false; 
  }
  if(167469<p&&event[167469]){ 
    wave(2); 
    glow(4); 
    event[167469]=false; 
  }
  if(167964<p&&event[167964]){ 
    wave(1); 
    glow(1); 
    event[167964]=false; 
  }
  if(168316<p&&event[168316]){ 
    wave(4); 
    glow(2); 
    event[168316]=false; 
  }
  if(168806<p&&event[168806]){ 
    wave(3); 
    glow(3); 
    event[168806]=false; 
  }
  if(169318<p&&event[169318]){ 
    wave(2); 
    glow(4); 
    event[169318]=false; 
  }
  if(169799<p&&event[169799]){ 
    wave(1); 
    glow(1); 
    event[169799]=false; 
  }
  if(170211<p&&event[170211]){ 
    wave(4); 
    glow(2); 
    event[170211]=false; 
  }
  if(170691<p&&event[170691]){ 
    wave(3); 
    glow(3); 
    event[170691]=false; 
  }
  if(171076<p&&event[171076]){ 
    wave(2); 
    glow(4); 
    event[171076]=false; 
  }
  if(171623<p&&event[171623]){ 
    wave(1); 
    glow(1); 
    event[171623]=false; 
  }
  if(172040<p&&event[172040]){ 
    wave(4); 
    glow(2); 
    event[172040]=false; 
  }
  if(172461<p&&event[172461]){ 
    wave(3); 
    glow(3); 
    event[172461]=false; 
  }
  if(172930<p&&event[172930]){ 
    wave(2); 
    glow(4); 
    event[172930]=false; 
  }
  if(173409<p&&event[173409]){ 
    wave(1); 
    glow(1); 
    event[173409]=false; 
  }
  if(173833<p&&event[173833]){ 
    wave(4); 
    glow(2); 
    event[173833]=false; 
  }
  if(174344<p&&event[174344]){ 
    wave(3); 
    glow(3); 
    event[174344]=false; 
  }
  if(174797<p&&event[174797]){ 
    wave(2); 
    glow(4); 
    event[174797]=false; 
  }
  if(175252<p&&event[175252]){ 
    wave(1); 
    glow(1); 
    event[175252]=false; 
  }
  if(175680<p&&event[175680]){ 
    wave(4); 
    glow(2); 
    event[175680]=false; 
  }
  if(176148<p&&event[176148]){ 
    wave(3); 
    glow(3); 
    event[176148]=false; 
  }
  if(176585<p&&event[176585]){ 
    wave(2); 
    glow(4); 
    event[176585]=false; 
  }
  if(177126<p&&event[177126]){ 
    wave(1); 
    glow(1); 
    event[177126]=false; 
  }
  if(177548<p&&event[177548]){ 
    wave(4); 
    glow(2); 
    event[177548]=false; 
  }
  if(178060<p&&event[178060]){ 
    wave(3); 
    glow(3); 
    event[178060]=false; 
  }
  if(178524<p&&event[178524]){ 
    wave(2); 
    glow(4); 
    event[178524]=false; 
  }
  if(178854<p&&event[178854]){ 
    wave(1); 
    glow(1); 
    event[178854]=false; 
  }
  if(179336<p&&event[179336]){ 
    wave(4); 
    glow(2); 
    event[179336]=false; 
  }
  if(179843<p&&event[179843]){ 
    wave(3); 
    glow(3); 
    event[179843]=false; 
  }
  if(180260<p&&event[180260]){ 
    wave(2); 
    glow(4); 
    event[180260]=false; 
  }
  if(180792<p&&event[180792]){ 
    wave(1); 
    glow(1); 
    event[180792]=false; 
  }
  if(181267<p&&event[181267]){ 
    wave(4); 
    glow(2); 
    event[181267]=false; 
  }
  if(181620<p&&event[181620]){ 
    wave(3); 
    glow(3); 
    event[181620]=false; 
  }
  if(182054<p&&event[182054]){ 
    wave(2); 
    glow(4); 
    event[182054]=false; 
  }
  if(182573<p&&event[182573]){ 
    wave(1); 
    glow(1); 
    event[182573]=false; 
  }
  if(182987<p&&event[182987]){ 
    wave(4); 
    glow(2); 
    event[182987]=false; 
  }
  if(183385<p&&event[183385]){ 
    wave(3); 
    glow(3); 
    event[183385]=false; 
  }
  if(183970<p&&event[183970]){ 
    wave(2); 
    glow(4); 
    event[183970]=false; 
  }
  if(184315<p&&event[184315]){ 
    wave(1); 
    glow(1); 
    event[184315]=false; 
  }
  if(184861<p&&event[184861]){ 
    wave(4); 
    glow(2); 
    event[184861]=false; 
  }
  if(185266<p&&event[185266]){ 
    wave(3); 
    glow(3); 
    event[185266]=false; 
  }
  if(185718<p&&event[185718]){ 
    wave(2); 
    glow(4); 
    event[185718]=false; 
  }
  if(186156<p&&event[186156]){ 
    wave(1); 
    glow(1); 
    event[186156]=false; 
  }
  if(186743<p&&event[186743]){ 
    wave(4); 
    glow(2); 
    event[186743]=false; 
  }
  if(187072<p&&event[187072]){ 
    wave(3); 
    glow(3); 
    event[187072]=false; 
  }
  if(187582<p&&event[187582]){ 
    wave(2); 
    glow(4); 
    event[187582]=false; 
  }
  if(188079<p&&event[188079]){ 
    wave(1); 
    glow(1); 
    event[188079]=false; 
  }
  if(188556<p&&event[188556]){ 
    wave(4); 
    glow(2); 
    event[188556]=false; 
  }
  if(188993<p&&event[188993]){ 
    wave(3); 
    glow(3); 
    event[188993]=false; 
  }
  if(189387<p&&event[189387]){ 
    wave(2); 
    glow(4); 
    event[189387]=false; 
  }
  if(189872<p&&event[189872]){ 
    wave(1); 
    glow(1); 
    event[189872]=false; 
  }
  if(190347<p&&event[190347]){ 
    wave(4); 
    glow(2); 
    event[190347]=false; 
  }
  if(190852<p&&event[190852]){ 
    wave(3); 
    glow(3); 
    event[190852]=false; 
  }
  if(191297<p&&event[191297]){ 
    wave(2); 
    glow(4); 
    event[191297]=false; 
  }
  //won6?
  if(192689<p&&event[192689]){ 
    wave(2); 
    glow(4); 
    event[192689]=false; 
  }
  if(192675<p&&event[192675]){ 
    wave(3); 
    glow(3); 
    event[192675]=false; 
  }
  if(193554<p&&event[193554]){ 
    wave(1); 
    glow(1); 
    event[193554]=false; 
  }
  if(193602<p&&event[193602]){ 
    wave(4); 
    glow(2); 
    event[193602]=false; 
  }
  if(194678<p&&event[194678]){ 
    wave(2); 
    glow(4); 
    event[194678]=false; 
  }
  if(194915<p&&event[194915]){ 
    wave(1); 
    glow(1); 
    event[194915]=false; 
  }
  if(195138<p&&event[195138]){ 
    wave(2); 
    glow(4); 
    event[195138]=false; 
  }
  if(195367<p&&event[195367]){ 
    wave(1); 
    glow(1); 
    event[195367]=false; 
  }
  if(195547<p&&event[195547]){ 
    wave(2); 
    glow(4); 
    event[195547]=false; 
  }
  if(195657<p&&event[195657]){ 
    wave(1); 
    glow(1); 
    event[195657]=false; 
  }
  if(196348<p&&event[196348]){ 
    wave(3); 
    glow(3); 
    event[196348]=false; 
  }
  if(196363<p&&event[196363]){ 
    wave(4); 
    glow(2); 
    event[196363]=false; 
  }
  if(196662<p&&event[196662]){ 
    wave(4); 
    glow(2); 
    event[196662]=false; 
  }
  if(196585<p&&event[196585]){ 
    wave(3); 
    glow(3); 
    event[196585]=false; 
  }
  if(197009<p&&event[197009]){ 
    wave(4); 
    glow(2); 
    event[197009]=false; 
  }
  if(197080<p&&event[197080]){ 
    wave(3); 
    glow(3); 
    event[197080]=false; 
  }
  if(197251<p&&event[197251]){ 
    wave(4); 
    glow(2); 
    event[197251]=false; 
  }
  if(197305<p&&event[197305]){ 
    wave(3); 
    glow(3); 
    event[197305]=false; 
  }
  if(197490<p&&event[197490]){ 
    wave(4); 
    glow(2); 
    event[197490]=false; 
  }
  if(197538<p&&event[197538]){ 
    wave(3); 
    glow(3); 
    event[197538]=false; 
  }
  if(198234<p&&event[198234]){ 
    wave(3); 
    glow(3); 
    event[198234]=false; 
  }
  if(198200<p&&event[198200]){ 
    wave(1); 
    glow(1); 
    event[198200]=false; 
  }
  if(198650<p&&event[198650]){ 
    wave(2); 
    glow(4); 
    event[198650]=false; 
  }
  if(198660<p&&event[198660]){ 
    wave(4); 
    glow(2); 
    event[198660]=false; 
  }
  if(199093<p&&event[199093]){ 
    wave(3); 
    glow(3); 
    event[199093]=false; 
  }
  if(199087<p&&event[199087]){ 
    wave(1); 
    glow(1); 
    event[199087]=false; 
  }
  if(199544<p&&event[199544]){ 
    wave(2); 
    glow(4); 
    event[199544]=false; 
  }
  if(199604<p&&event[199604]){ 
    wave(4); 
    glow(2); 
    event[199604]=false; 
  }
  if(200010<p&&event[200010]){ 
    wave(3); 
    glow(3); 
    event[200010]=false; 
  }
  if(200029<p&&event[200029]){ 
    wave(1); 
    glow(1); 
    event[200029]=false; 
  }
  if(200978<p&&event[200978]){ 
    wave(3); 
    glow(3); 
    event[200978]=false; 
  }
  if(200961<p&&event[200961]){ 
    wave(2); 
    glow(4); 
    event[200961]=false; 
  }
  if(202005<p&&event[202005]){ 
    wave(4); 
    glow(2); 
    event[202005]=false; 
  }
  if(202252<p&&event[202252]){ 
    wave(1); 
    glow(1); 
    event[202252]=false; 
  }
  if(202556<p&&event[202556]){ 
    wave(4); 
    glow(2); 
    event[202556]=false; 
  }
  if(202739<p&&event[202739]){ 
    wave(1); 
    glow(1); 
    event[202739]=false; 
  }
  if(202846<p&&event[202846]){ 
    wave(4); 
    glow(2); 
    event[202846]=false; 
  }
  if(202955<p&&event[202955]){ 
    wave(1); 
    glow(1); 
    event[202955]=false; 
  }
  if(203660<p&&event[203660]){ 
    wave(3); 
    glow(3); 
    event[203660]=false; 
  }
  if(203677<p&&event[203677]){ 
    wave(2); 
    glow(4); 
    event[203677]=false; 
  }
  if(203892<p&&event[203892]){ 
    wave(3); 
    glow(3); 
    event[203892]=false; 
  }
  if(203960<p&&event[203960]){ 
    wave(2); 
    glow(4); 
    event[203960]=false; 
  }
  if(204379<p&&event[204379]){ 
    wave(1); 
    glow(1); 
    event[204379]=false; 
  }
  if(204385<p&&event[204385]){ 
    wave(4); 
    glow(2); 
    event[204385]=false; 
  }
  if(204612<p&&event[204612]){ 
    wave(1); 
    glow(1); 
    event[204612]=false; 
  }
  if(204611<p&&event[204611]){ 
    wave(4); 
    glow(2); 
    event[204611]=false; 
  }
  if(204877<p&&event[204877]){ 
    wave(1); 
    glow(1); 
    event[204877]=false; 
  }
  if(204852<p&&event[204852]){ 
    wave(4); 
    glow(2); 
    event[204852]=false; 
  }
  if(205490<p&&event[205490]){ 
    wave(2); 
    glow(4); 
    event[205490]=false; 
  }
  if(205871<p&&event[205871]){ 
    wave(1); 
    glow(1); 
    event[205871]=false; 
  }
  if(206374<p&&event[206374]){ 
    wave(4); 
    glow(2); 
    event[206374]=false; 
  }
  if(206886<p&&event[206886]){ 
    wave(3); 
    glow(3); 
    event[206886]=false; 
  }
  if(207338<p&&event[207338]){ 
    wave(2); 
    glow(4); 
    event[207338]=false; 
  }
  if(207518<p&&event[207518]){ 
    wave(1); 
    glow(1); 
    event[207518]=false; 
  }
  if(209185<p&&event[209185]){ 
    wave(4); 
    glow(2); 
    event[209185]=false; 
  }
  if(209446<p&&event[209446]){ 
    wave(3); 
    glow(3); 
    event[209446]=false; 
  }
  if(209810<p&&event[209810]){ 
    wave(4); 
    glow(2); 
    event[209810]=false; 
  }
  if(209981<p&&event[209981]){ 
    wave(3); 
    glow(3); 
    event[209981]=false; 
  }
  if(210230<p&&event[210230]){ 
    wave(4); 
    glow(2); 
    event[210230]=false; 
  }
  if(210280<p&&event[210280]){ 
    wave(3); 
    glow(3); 
    event[210280]=false; 
  }
  if(210931<p&&event[210931]){ 
    wave(2); 
    glow(4); 
    event[210931]=false; 
  }
  if(210933<p&&event[210933]){ 
    wave(1); 
    glow(1); 
    event[210933]=false; 
  }
  if(211251<p&&event[211251]){ 
    wave(2); 
    glow(4); 
    event[211251]=false; 
  }
  if(211242<p&&event[211242]){ 
    wave(1); 
    glow(1); 
    event[211242]=false; 
  }
  if(211689<p&&event[211689]){ 
    wave(2); 
    glow(4); 
    event[211689]=false; 
  }
  if(211678<p&&event[211678]){ 
    wave(1); 
    glow(1); 
    event[211678]=false; 
  }
  if(211913<p&&event[211913]){ 
    wave(1); 
    glow(1); 
    event[211913]=false; 
  }
  if(211945<p&&event[211945]){ 
    wave(2); 
    glow(4); 
    event[211945]=false; 
  }
  if(212105<p&&event[212105]){ 
    wave(1); 
    glow(1); 
    event[212105]=false; 
  }
  if(212180<p&&event[212180]){ 
    wave(2); 
    glow(4); 
    event[212180]=false; 
  }
  if(212811<p&&event[212811]){ 
    wave(1); 
    glow(1); 
    event[212811]=false; 
  }
  if(212916<p&&event[212916]){ 
    wave(4); 
    glow(2); 
    event[212916]=false; 
  }
  if(213254<p&&event[213254]){ 
    wave(2); 
    glow(4); 
    event[213254]=false; 
  }
  if(213285<p&&event[213285]){ 
    wave(1); 
    glow(1); 
    event[213285]=false; 
  }
  if(213789<p&&event[213789]){ 
    wave(2); 
    glow(4); 
    event[213789]=false; 
  }
  if(213794<p&&event[213794]){ 
    wave(3); 
    glow(3); 
    event[213794]=false; 
  }
  if(214226<p&&event[214226]){ 
    wave(4); 
    glow(2); 
    event[214226]=false; 
  }
  if(214244<p&&event[214244]){ 
    wave(1); 
    glow(1); 
    event[214244]=false; 
  }
  if(214707<p&&event[214707]){ 
    wave(4); 
    glow(2); 
    event[214707]=false; 
  }
  if(214755<p&&event[214755]){ 
    wave(1); 
    glow(1); 
    event[214755]=false; 
  }
  if(215545<p&&event[215545]){ 
    wave(1); 
    glow(1); 
    event[215545]=false; 
  }
  if(215543<p&&event[215543]){ 
    wave(4); 
    glow(2); 
    event[215543]=false; 
  }
  if(216622<p&&event[216622]){ 
    wave(2); 
    glow(4); 
    event[216622]=false; 
  }
  if(216864<p&&event[216864]){ 
    wave(1); 
    glow(1); 
    event[216864]=false; 
  }
  if(217103<p&&event[217103]){ 
    wave(2); 
    glow(4); 
    event[217103]=false; 
  }
  if(217339<p&&event[217339]){ 
    wave(1); 
    glow(1); 
    event[217339]=false; 
  }
  if(217605<p&&event[217605]){ 
    wave(2); 
    glow(4); 
    event[217605]=false; 
  }
  if(217639<p&&event[217639]){ 
    wave(1); 
    glow(1); 
    event[217639]=false; 
  }
  if(218352<p&&event[218352]){ 
    wave(3); 
    glow(3); 
    event[218352]=false; 
  }
  if(218333<p&&event[218333]){ 
    wave(2); 
    glow(4); 
    event[218333]=false; 
  }
  if(218566<p&&event[218566]){ 
    wave(2); 
    glow(4); 
    event[218566]=false; 
  }
  if(218567<p&&event[218567]){ 
    wave(3); 
    glow(3); 
    event[218567]=false; 
  }
  if(219017<p&&event[219017]){ 
    wave(2); 
    glow(4); 
    event[219017]=false; 
  }
  if(219039<p&&event[219039]){ 
    wave(3); 
    glow(3); 
    event[219039]=false; 
  }
  if(219149<p&&event[219149]){ 
    wave(2); 
    glow(4); 
    event[219149]=false; 
  }
  if(219182<p&&event[219182]){ 
    wave(2); 
    glow(4); 
    event[219182]=false; 
  }
  if(219189<p&&event[219189]){ 
    wave(3); 
    glow(3); 
    event[219189]=false; 
  }
  if(219422<p&&event[219422]){ 
    wave(2); 
    glow(4); 
    event[219422]=false; 
  }
  if(220088<p&&event[220088]){ 
    wave(3); 
    glow(3); 
    event[220088]=false; 
  }
  if(220072<p&&event[220072]){ 
    wave(4); 
    glow(2); 
    event[220072]=false; 
  }
  if(220657<p&&event[220657]){ 
    wave(3); 
    glow(3); 
    event[220657]=false; 
  }
  if(220641<p&&event[220641]){ 
    wave(4); 
    glow(2); 
    event[220641]=false; 
  }
  if(221074<p&&event[221074]){ 
    wave(3); 
    glow(3); 
    event[221074]=false; 
  }
  if(221069<p&&event[221069]){ 
    wave(4); 
    glow(2); 
    event[221069]=false; 
  }
  if(221550<p&&event[221550]){ 
    wave(3); 
    glow(3); 
    event[221550]=false; 
  }
  if(221525<p&&event[221525]){ 
    wave(4); 
    glow(2); 
    event[221525]=false; 
  }
  if(221942<p&&event[221942]){ 
    wave(4); 
    glow(2); 
    event[221942]=false; 
  }
  if(222009<p&&event[222009]){ 
    wave(3); 
    glow(3); 
    event[222009]=false; 
  }
  //won7
  if(150529<p&&event[150529]){ 
    glow(); 
    event[150529]=false; 
  }
  if(150958<p&&event[150958]){ 
    glow(); 
    event[150958]=false; 
  }
  if(151366<p&&event[151366]){ 
    glow(); 
    event[151366]=false; 
  }
  if(151901<p&&event[151901]){ 
    glow(); 
    event[151901]=false; 
  }
  if(152339<p&&event[152339]){ 
    glow(); 
    event[152339]=false; 
  }
  if(152777<p&&event[152777]){ 
    glow(); 
    event[152777]=false; 
  }
  if(153279<p&&event[153279]){ 
    glow(); 
    event[153279]=false; 
  }
  if(153696<p&&event[153696]){ 
    glow(); 
    event[153696]=false; 
  }
  if(154163<p&&event[154163]){ 
    glow(); 
    event[154163]=false; 
  }
  if(154620<p&&event[154620]){ 
    glow(); 
    event[154620]=false; 
  }
  if(155093<p&&event[155093]){ 
    glow(); 
    event[155093]=false; 
  }
  if(155604<p&&event[155604]){ 
    glow(); 
    event[155604]=false; 
  }
  if(156070<p&&event[156070]){ 
    glow(); 
    event[156070]=false; 
  }
  if(156453<p&&event[156453]){ 
    glow(); 
    event[156453]=false; 
  }
  if(156972<p&&event[156972]){ 
    glow(); 
    event[156972]=false; 
  }
  if(157410<p&&event[157410]){ 
    glow(); 
    event[157410]=false; 
  }
  if(157850<p&&event[157850]){ 
    glow(); 
    event[157850]=false; 
  }
  if(158335<p&&event[158335]){ 
    glow(); 
    event[158335]=false; 
  }
  if(158758<p&&event[158758]){ 
    glow(); 
    event[158758]=false; 
  }
  if(159215<p&&event[159215]){ 
    glow(); 
    event[159215]=false; 
  }
  if(159635<p&&event[159635]){ 
    glow(); 
    event[159635]=false; 
  }
  if(160136<p&&event[160136]){ 
    glow(); 
    event[160136]=false; 
  }
  if(160618<p&&event[160618]){ 
    glow(); 
    event[160618]=false; 
  }
  if(161145<p&&event[161145]){ 
    glow(); 
    event[161145]=false; 
  }
  if(161532<p&&event[161532]){ 
    glow(); 
    event[161532]=false; 
  }
  if(162033<p&&event[162033]){ 
    glow(); 
    event[162033]=false; 
  }
  if(162377<p&&event[162377]){ 
    glow(); 
    event[162377]=false; 
  }
  if(162889<p&&event[162889]){ 
    glow(); 
    event[162889]=false; 
  }
  if(223005<p&&event[223005]){ 
    glow(); 
    event[223005]=false; 
  }
  if(223818<p&&event[223818]){ 
    glow(); 
    event[223818]=false; 
  }
  if(224780<p&&event[224780]){ 
    glow(); 
    event[224780]=false; 
  }
  if(225649<p&&event[225649]){ 
    glow(); 
    event[225649]=false; 
  }
  if(226100<p&&event[226100]){ 
    glow(); 
    event[226100]=false; 
  }
  if(226479<p&&event[226479]){ 
    glow(); 
    event[226479]=false; 
  }
  if(226957<p&&event[226957]){ 
    glow(); 
    event[226957]=false; 
  }
  if(227385<p&&event[227385]){ 
    glow(); 
    event[227385]=false; 
  }
  if(227929<p&&event[227929]){ 
    glow(); 
    event[227929]=false; 
  }
  if(228346<p&&event[228346]){ 
    glow(); 
    event[228346]=false; 
  }
  if(228600<p&&event[228600]){ 
    glow(); 
    event[228600]=false; 
  }
  if(228840<p&&event[228840]){ 
    glow(); 
    event[228840]=false; 
  }
  if(229871<p&&event[229871]){ 
    wave(3,false,true); 
    glow(3); 
    event[229871]=false; 
  }
  if(230064<p&&event[230064]){ 
    wave(2,false,true); 
    glow(4); 
    event[230064]=false; 
  }
  if(230153<p&&event[230153]){ 
    wave(3,true,false); 
    glow(3); 
    event[230153]=false; 
  }
  if(230214<p&&event[230214]){ 
    wave(2,true,false); 
    glow(4); 
    event[230214]=false; 
  }
  if(230300<p&&event[230300]){ 
    wave(3,false,true); 
    glow(3); 
    event[230300]=false; 
  }
  if(230453<p&&event[230453]){ 
    wave(2,false,true); 
    glow(4); 
    event[230453]=false; 
  }
  if(230525<p&&event[230525]){ 
    wave(3,true,false); 
    glow(3); 
    event[230525]=false; 
  }
  if(230614<p&&event[230614]){ 
    wave(2,true,false); 
    glow(4); 
    event[230614]=false; 
  }
  if(230823<p&&event[230823]){ 
    wave(3,false,true); 
    glow(3); 
    event[230823]=false; 
  }
  if(230768<p&&event[230768]){ 
    wave(2,false,true); 
    glow(4); 
    event[230768]=false; 
  }
  if(231110<p&&event[231110]){ 
    wave(3,true,false); 
    glow(3); 
    event[231110]=false; 
  }
  if(231099<p&&event[231099]){ 
    wave(2,true,false); 
    glow(4); 
    event[231099]=false; 
  }
  if(231348<p&&event[231348]){ 
    wave(2,false,true); 
    glow(4); 
    event[231348]=false; 
  }
  if(231277<p&&event[231277]){ 
    wave(3,false,true); 
    glow(3); 
    event[231277]=false; 
  }
  if(231467<p&&event[231467]){ 
    wave(3,true,false); 
    glow(3); 
    event[231467]=false; 
  }
  if(231567<p&&event[231567]){ 
    wave(2,true,false); 
    glow(4); 
    event[231567]=false; 
  }
  if(231710<p&&event[231710]){ 
    wave(3,false,true); 
    glow(3); 
    event[231710]=false; 
  }
  if(231773<p&&event[231773]){ 
    wave(2,false,true); 
    glow(4); 
    event[231773]=false; 
  }
  if(231938<p&&event[231938]){ 
    wave(3,true,false); 
    glow(3); 
    event[231938]=false; 
  }
  if(232053<p&&event[232053]){ 
    wave(2,true,false); 
    glow(4); 
    event[232053]=false; 
  }
  if(232199<p&&event[232199]){ 
    wave(3,false,true); 
    glow(3); 
    event[232199]=false; 
  }
  if(232263<p&&event[232263]){ 
    wave(2,false,true); 
    glow(4); 
    event[232263]=false; 
  }
  if(232426<p&&event[232426]){ 
    wave(3,true,false); 
    glow(3); 
    event[232426]=false; 
  }
  if(232433<p&&event[232433]){ 
    wave(2,true,false); 
    glow(4); 
    event[232433]=false; 
  }
  if(232650<p&&event[232650]){ 
    wave(2,false,true); 
    glow(4); 
    event[232650]=false; 
  }
  if(232642<p&&event[232642]){ 
    wave(3,false,true); 
    glow(3); 
    event[232642]=false; 
  }
  if(232716<p&&event[232716]){ 
    wave(2,true,false); 
    glow(4); 
    event[232716]=false; 
  }
  if(232842<p&&event[232842]){ 
    wave(3,true,false); 
    glow(3); 
    event[232842]=false; 
  }
  if(234581<p&&event[234581]){ 
    wave(1,true,false); 
    glow(1); 
    event[234581]=false; 
  }
  if(234564<p&&event[234564]){ 
    wave(1,false,true); 
    glow(1); 
    event[234564]=false; 
  }
  if(234655<p&&event[234655]){ 
    wave(4,false,true); 
    glow(2); 
    event[234655]=false; 
  }
  if(234677<p&&event[234677]){ 
    wave(1,true,false); 
    glow(1); 
    event[234677]=false; 
  }
  if(236087<p&&event[236087]){ 
    wave(4,false,true); 
    glow(2); 
    event[236087]=false; 
  }
  if(236102<p&&event[236102]){ 
    wave(1,false,true); 
    glow(1); 
    event[236102]=false; 
  }
  if(236420<p&&event[236420]){ 
    wave(4,true,false); 
    glow(2); 
    event[236420]=false; 
  }
  if(236337<p&&event[236337]){ 
    wave(1,true,false); 
    glow(1); 
    event[236337]=false; 
  }
  if(236373<p&&event[236373]){ 
    wave(4,false,true); 
    glow(2); 
    event[236373]=false; 
  }
  if(236399<p&&event[236399]){ 
    wave(1,false,true); 
    glow(1); 
    event[236399]=false; 
  }
  if(237929<p&&event[237929]){ 
    wave(2,false,true); 
    glow(4); 
    event[237929]=false; 
  }
  if(237945<p&&event[237945]){ 
    wave(3,false,true); 
    glow(3); 
    event[237945]=false; 
  }
  if(238136<p&&event[238136]){ 
    wave(2,true,false); 
    glow(4); 
    event[238136]=false; 
  }
  if(238166<p&&event[238166]){ 
    wave(3,true,false); 
    glow(3); 
    event[238166]=false; 
  }
  if(238367<p&&event[238367]){ 
    wave(2,false,true); 
    glow(4); 
    event[238367]=false; 
  }
  if(238382<p&&event[238382]){ 
    wave(3,false,true); 
    glow(3); 
    event[238382]=false; 
  }
  if(238663<p&&event[238663]){ 
    wave(3,true,false); 
    glow(3); 
    event[238663]=false; 
  }
  if(238688<p&&event[238688]){ 
    wave(2,true,false); 
    glow(4); 
    event[238688]=false; 
  }
  if(238790<p&&event[238790]){ 
    wave(3,false,true); 
    glow(3); 
    event[238790]=false; 
  }
  if(238856<p&&event[238856]){ 
    wave(2,false,true); 
    glow(4); 
    event[238856]=false; 
  }
  if(239112<p&&event[239112]){ 
    wave(3,true,false); 
    glow(3); 
    event[239112]=false; 
  }
  if(239099<p&&event[239099]){ 
    wave(2,true,false); 
    glow(4); 
    event[239099]=false; 
  }
  if(239360<p&&event[239360]){ 
    wave(2,false,true); 
    glow(4); 
    event[239360]=false; 
  }
  if(239377<p&&event[239377]){ 
    wave(3,false,true); 
    glow(3); 
    event[239377]=false; 
  }
  if(239553<p&&event[239553]){ 
    wave(3,true,false); 
    glow(3); 
    event[239553]=false; 
  }
  if(239585<p&&event[239585]){ 
    wave(2,true,false); 
    glow(4); 
    event[239585]=false; 
  }
  if(239828<p&&event[239828]){ 
    wave(3,false,true); 
    glow(3); 
    event[239828]=false; 
  }
  if(239836<p&&event[239836]){ 
    wave(2,false,true); 
    glow(4); 
    event[239836]=false; 
  }
  if(240043<p&&event[240043]){ 
    wave(3,true,false); 
    glow(3); 
    event[240043]=false; 
  }
  if(239995<p&&event[239995]){ 
    wave(2,true,false); 
    glow(4); 
    event[239995]=false; 
  }
  if(240123<p&&event[240123]){ 
    wave(2,false,true); 
    glow(4); 
    event[240123]=false; 
  }
  if(240094<p&&event[240094]){ 
    wave(3,false,true); 
    glow(3); 
    event[240094]=false; 
  }
  if(241446<p&&event[241446]){ 
    wave(4,false,true); 
    glow(2); 
    event[241446]=false; 
  }
  if(241521<p&&event[241521]){ 
    wave(1,false,true); 
    glow(1); 
    event[241521]=false; 
  }
  if(241625<p&&event[241625]){ 
    wave(4,true,false); 
    glow(2); 
    event[241625]=false; 
  }
  if(241655<p&&event[241655]){ 
    wave(1,true,false); 
    glow(1); 
    event[241655]=false; 
  }
  if(241865<p&&event[241865]){ 
    wave(1,false,true); 
    glow(1); 
    event[241865]=false; 
  }
  if(241920<p&&event[241920]){ 
    wave(4,false,true); 
    glow(2); 
    event[241920]=false; 
  }
  if(243323<p&&event[243323]){ 
    wave(1,true,false); 
    glow(1); 
    event[243323]=false; 
  }
  if(243334<p&&event[243334]){ 
    wave(4,false,true); 
    glow(2); 
    event[243334]=false; 
  }
  if(243592<p&&event[243592]){ 
    wave(4,true,false); 
    glow(2); 
    event[243592]=false; 
  }
  if(243546<p&&event[243546]){ 
    wave(1,false,true); 
    glow(1); 
    event[243546]=false; 
  }
  if(243732<p&&event[243732]){ 
    wave(4,false,true); 
    glow(2); 
    event[243732]=false; 
  }
  if(243780<p&&event[243780]){ 
    wave(1,true,false); 
    glow(1); 
    event[243780]=false; 
  }
  if(243967<p&&event[243967]){ 
    wave(1,false,true); 
    glow(1); 
    event[243967]=false; 
  }
  if(243995<p&&event[243995]){ 
    wave(4,true,false); 
    glow(2); 
    event[243995]=false; 
  }
  if(245146<p&&event[245146]){ 
    wave(2,true,false); 
    glow(4); 
    event[245146]=false; 
  }
  if(245229<p&&event[245229]){ 
    wave(3,false,true); 
    glow(3); 
    event[245229]=false; 
  }
  if(245353<p&&event[245353]){ 
    wave(2,false,true); 
    glow(4); 
    event[245353]=false; 
  }
  if(245431<p&&event[245431]){ 
    wave(3,true,false); 
    glow(3); 
    event[245431]=false; 
  }
  if(245542<p&&event[245542]){ 
    wave(2,true,false); 
    glow(4); 
    event[245542]=false; 
  }
  if(245519<p&&event[245519]){ 
    wave(3,false,true); 
    glow(3); 
    event[245519]=false; 
  }
  if(245794<p&&event[245794]){ 
    wave(3,true,false); 
    glow(3); 
    event[245794]=false; 
  }
  if(245790<p&&event[245790]){ 
    wave(2,false,true); 
    glow(4); 
    event[245790]=false; 
  }
  if(245987<p&&event[245987]){ 
    wave(2,true,false); 
    glow(4); 
    event[245987]=false; 
  }
  if(246076<p&&event[246076]){ 
    wave(3,false,true); 
    glow(3); 
    event[246076]=false; 
  }
  if(246260<p&&event[246260]){ 
    wave(2,false,true); 
    glow(4); 
    event[246260]=false; 
  }
  if(246280<p&&event[246280]){ 
    wave(3,true,false); 
    glow(3); 
    event[246280]=false; 
  }
  if(246417<p&&event[246417]){ 
    wave(3,false,true); 
    glow(3); 
    event[246417]=false; 
  }
  if(246542<p&&event[246542]){ 
    wave(2,true,false); 
    glow(4); 
    event[246542]=false; 
  }
  if(246725<p&&event[246725]){ 
    wave(3,true,false); 
    glow(3); 
    event[246725]=false; 
  }
  if(246681<p&&event[246681]){ 
    wave(2,false,true); 
    glow(4); 
    event[246681]=false; 
  }
  if(247002<p&&event[247002]){ 
    wave(3,false,true); 
    glow(3); 
    event[247002]=false; 
  }
  if(247087<p&&event[247087]){ 
    wave(2,true,false); 
    glow(4); 
    event[247087]=false; 
  }
  if(247274<p&&event[247274]){ 
    wave(2,false,true); 
    glow(4); 
    event[247274]=false; 
  }
  if(247209<p&&event[247209]){ 
    wave(3,true,false); 
    glow(3); 
    event[247209]=false; 
  }
  if(247378<p&&event[247378]){ 
    wave(3,false,true); 
    glow(3); 
    event[247378]=false; 
  }
  if(247397<p&&event[247397]){ 
    wave(2,true,false); 
    glow(4); 
    event[247397]=false; 
  }
  if(248841<p&&event[248841]){ 
    wave(1,false,true); 
    glow(1); 
    event[248841]=false; 
  }
  if(248825<p&&event[248825]){ 
    wave(4,false,true); 
    glow(2); 
    event[248825]=false; 
  }
  if(249032<p&&event[249032]){ 
    wave(1,true,false); 
    glow(1); 
    event[249032]=false; 
  }
  if(249014<p&&event[249014]){ 
    wave(4,true,false); 
    glow(2); 
    event[249014]=false; 
  }
  if(249242<p&&event[249242]){ 
    wave(1,false,true); 
    glow(1); 
    event[249242]=false; 
  }
  if(249242<p&&event[249242]){ 
    wave(4,false,true); 
    glow(2); 
    event[249242]=false; 
  }
  if(250596<p&&event[250596]){ 
    wave(4,false,true); 
    glow(2); 
    event[250596]=false; 
  }
  if(250598<p&&event[250598]){ 
    wave(1,false,true); 
    glow(1); 
    event[250598]=false; 
  }
  if(250846<p&&event[250846]){ 
    wave(1,true,false); 
    glow(1); 
    event[250846]=false; 
  }
  if(250797<p&&event[250797]){ 
    wave(4,true,false); 
    glow(2); 
    event[250797]=false; 
  }
  if(251053<p&&event[251053]){ 
    wave(4,false,true); 
    glow(2); 
    event[251053]=false; 
  }
  if(251013<p&&event[251013]){ 
    wave(1,false,true); 
    glow(1); 
    event[251013]=false; 
  }
  if(251210<p&&event[251210]){ 
    wave(1,true,false); 
    glow(1); 
    event[251210]=false; 
  }
  if(251345<p&&event[251345]){ 
    wave(4,true,false); 
    glow(2); 
    event[251345]=false; 
  }
  if(252538<p&&event[252538]){ 
    wave(2,false,true); 
    glow(4); 
    event[252538]=false; 
  }
  if(252445<p&&event[252445]){ 
    wave(3,false,true); 
    glow(3); 
    event[252445]=false; 
  }
  if(252722<p&&event[252722]){ 
    wave(2,true,false); 
    glow(4); 
    event[252722]=false; 
  }
  if(252770<p&&event[252770]){ 
    wave(3,true,false); 
    glow(3); 
    event[252770]=false; 
  }
  if(252924<p&&event[252924]){ 
    wave(3,false,true); 
    glow(3); 
    event[252924]=false; 
  }
  if(252947<p&&event[252947]){ 
    wave(2,false,true); 
    glow(4); 
    event[252947]=false; 
  }
  if(253082<p&&event[253082]){ 
    wave(3,true,false); 
    glow(3); 
    event[253082]=false; 
  }
  if(253228<p&&event[253228]){ 
    wave(2,true,false); 
    glow(4); 
    event[253228]=false; 
  }
  if(253332<p&&event[253332]){ 
    wave(3,false,true); 
    glow(3); 
    event[253332]=false; 
  }
  if(253303<p&&event[253303]){ 
    wave(2,false,true); 
    glow(4); 
    event[253303]=false; 
  }
  if(253618<p&&event[253618]){ 
    wave(2,true,false); 
    glow(4); 
    event[253618]=false; 
  }
  if(253558<p&&event[253558]){ 
    wave(3,true,false); 
    glow(3); 
    event[253558]=false; 
  }
  if(253806<p&&event[253806]){ 
    wave(2,false,true); 
    glow(4); 
    event[253806]=false; 
  }
  if(253880<p&&event[253880]){ 
    wave(3,false,true); 
    glow(3); 
    event[253880]=false; 
  }
  if(254033<p&&event[254033]){ 
    wave(3,true,false); 
    glow(3); 
    event[254033]=false; 
  }
  if(254105<p&&event[254105]){ 
    wave(2,true,false); 
    glow(4); 
    event[254105]=false; 
  }
  if(254245<p&&event[254245]){ 
    wave(3,false,true); 
    glow(3); 
    event[254245]=false; 
  }
  if(254281<p&&event[254281]){ 
    wave(2,false,true); 
    glow(4); 
    event[254281]=false; 
  }
  if(254518<p&&event[254518]){ 
    wave(2,true,false); 
    glow(4); 
    event[254518]=false; 
  }
  if(254513<p&&event[254513]){ 
    wave(3,true,false); 
    glow(3); 
    event[254513]=false; 
  }
  if(254787<p&&event[254787]){ 
    wave(3,false,true); 
    glow(3); 
    event[254787]=false; 
  }
  if(254725<p&&event[254725]){ 
    wave(2,false,true); 
    glow(4); 
    event[254725]=false; 
  }
  if(256163<p&&event[256163]){ 
    wave(4,false,true); 
    glow(2); 
    event[256163]=false; 
  }
  if(256238<p&&event[256238]){ 
    wave(1,false,true); 
    glow(1); 
    event[256238]=false; 
  }
  if(256372<p&&event[256372]){ 
    wave(4,true,false); 
    glow(2); 
    event[256372]=false; 
  }
  if(256363<p&&event[256363]){ 
    wave(1,true,false); 
    glow(1); 
    event[256363]=false; 
  }
  if(256550<p&&event[256550]){ 
    wave(1,false,true); 
    glow(1); 
    event[256550]=false; 
  }
  if(256598<p&&event[256598]){ 
    wave(4,false,true); 
    glow(2); 
    event[256598]=false; 
  }
  if(257701<p&&event[257701]){ 
    wave(4,false,true); 
    glow(2); 
    event[257701]=false; 
  }
  if(257680<p&&event[257680]){ 
    wave(4,true,false); 
    glow(2); 
    event[257680]=false; 
  }
  if(257649<p&&event[257649]){ 
    wave(1,false,true); 
    glow(1); 
    event[257649]=false; 
  }
  if(257727<p&&event[257727]){ 
    wave(1,true,false); 
    glow(1); 
    event[257727]=false; 
  }
  if(258168<p&&event[258168]){ 
    wave(4,false,true); 
    glow(2); 
    event[258168]=false; 
  }
  if(258114<p&&event[258114]){ 
    wave(4,true,false); 
    glow(2); 
    event[258114]=false; 
  }
  if(258132<p&&event[258132]){ 
    wave(1,false,true); 
    glow(1); 
    event[258132]=false; 
  }
  if(258174<p&&event[258174]){ 
    wave(1,true,false); 
    glow(1); 
    event[258174]=false; 
  }
  if(258628<p&&event[258628]){ 
    wave(4,false,true); 
    glow(2); 
    event[258628]=false; 
  }
  if(258593<p&&event[258593]){ 
    wave(4,true,false); 
    glow(2); 
    event[258593]=false; 
  }
  if(258580<p&&event[258580]){ 
    wave(1,true,false); 
    glow(1); 
    event[258580]=false; 
  }
  if(258576<p&&event[258576]){ 
    wave(1,false,true); 
    glow(1); 
    event[258576]=false; 
  }
  if(259053<p&&event[259053]){ 
    wave(4,false,true); 
    glow(2); 
    event[259053]=false; 
  }
  if(259086<p&&event[259086]){ 
    wave(4,true,false); 
    glow(2); 
    event[259086]=false; 
  }
  if(259064<p&&event[259064]){ 
    wave(1,true,false); 
    glow(1); 
    event[259064]=false; 
  }
  if(259125<p&&event[259125]){ 
    wave(1,false,true); 
    glow(1); 
    event[259125]=false; 
  }
  if(262727<p&&event[262727]){ 
    glow(); 
    event[262727]=false; 
  }
  if(263649<p&&event[263649]){ 
    glow(); 
    event[263649]=false; 
  }
  if(264586<p&&event[264586]){ 
    glow(); 
    event[264586]=false; 
  }
  if(265340<p&&event[265340]){ 
    glow(); 
    event[265340]=false; 
  }
  if(266004<p&&event[266004]){ 
    glow(); 
    event[266004]=false; 
  }
  if(266379<p&&event[266379]){ 
    glow(); 
    event[266379]=false; 
  }
  if(268163<p&&event[268163]){ 
    glow(); 
    event[268163]=false; 
  }
  if(268899<p&&event[268899]){ 
    glow(); 
    event[268899]=false; 
  }
  if(270173<p&&event[270173]){ 
    glow(); 
    event[270173]=false; 
  }
  if(271926<p&&event[271926]){ 
    glow(); 
    event[271926]=false; 
  }
  if(272554<p&&event[272554]){ 
    glow(); 
    event[272554]=false; 
  }
  if(273714<p&&event[273714]){ 
    glow(); 
    event[273714]=false; 
  }
  if(274136<p&&event[274136]){ 
    glow(); 
    event[274136]=false; 
  }
  if(274671<p&&event[274671]){ 
    glow(); 
    event[274671]=false; 
  }
  if(275168<p&&event[275168]){ 
    glow(); 
    event[275168]=false; 
  }
  if(275665<p&&event[275665]){ 
    glow(); 
    event[275665]=false; 
  }
  if(276047<p&&event[276047]){ 
    glow(); 
    event[276047]=false; 
  }
  if(276486<p&&event[276486]){ 
    glow(); 
    event[276486]=false; 
  }
  if(276917<p&&event[276917]){ 
    glow(); 
    event[276917]=false; 
  }
  if(277350<p&&event[277350]){ 
    glow(); 
    event[277350]=false; 
  }
  if(277767<p&&event[277767]){ 
    glow(); 
    event[277767]=false; 
  }
  if(278302<p&&event[278302]){ 
    glow(); 
    event[278302]=false; 
  }
  if(278798<p&&event[278798]){ 
    glow(); 
    event[278798]=false; 
  }
  if(279250<p&&event[279250]){ 
    glow(); 
    event[279250]=false; 
  }
  if(279736<p&&event[279736]){ 
    glow(); 
    event[279736]=false; 
  }
  if(280129<p&&event[280129]){ 
    glow(); 
    event[280129]=false; 
  }
  if(280623<p&&event[280623]){ 
    glow(); 
    event[280623]=false; 
  }
  if(281000<p&&event[281000]){ 
    glow(); 
    event[281000]=false; 
  }
  if(281476<p&&event[281476]){ 
    glow(); 
    event[281476]=false; 
  }
  if(282024<p&&event[282024]){ 
    glow(); 
    event[282024]=false; 
  }
  if(282437<p&&event[282437]){ 
    glow(); 
    event[282437]=false; 
  }
  if(282879<p&&event[282879]){ 
    glow(); 
    event[282879]=false; 
  }
  if(283337<p&&event[283337]){ 
    glow(); 
    event[283337]=false; 
  }
  if(283836<p&&event[283836]){ 
    glow(); 
    event[283836]=false; 
  }
  if(284212<p&&event[284212]){ 
    glow(); 
    event[284212]=false; 
  }
  if(284741<p&&event[284741]){ 
    glow(); 
    event[284741]=false; 
  }
  if(285182<p&&event[285182]){ 
    glow(); 
    event[285182]=false; 
  }
  if(285679<p&&event[285679]){ 
    glow(); 
    event[285679]=false; 
  }
  if(286080<p&&event[286080]){ 
    glow(); 
    event[286080]=false; 
  }
  if(286510<p&&event[286510]){ 
    glow(); 
    event[286510]=false; 
  }
  if(287004<p&&event[287004]){ 
    glow(); 
    event[287004]=false; 
  }
  if(287512<p&&event[287512]){ 
    glow(); 
    event[287512]=false; 
  }
  if(288007<p&&event[288007]){ 
    glow(); 
    event[288007]=false; 
  }
}

void levelTwo() { //tempo 92 ie: 1beat/1533ms
  genericLevel(126,159,218,12,98,212,1,1,1);
}

void levelThree() { //tempo 130 ie: 1beat/2167ms
  genericLevel(235,239,122,233,247,36,1,1,1);
}

void levelFour() { //tempo 128 ie: 1beat/2133ms
  genericLevel(239,200,122,255,154,0,1,1,1);
}

void levelFive() { //tempo 180 ie: 1beat/3000ms
  genericLevel(239,138,122,247,64,36,1,1,1);
}

void levelSix() { //tempo 177 ie: 1beat/2950ms
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

void glow(){
  glow(1);
  glow(2);
  glow(3);
  glow(4);
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

void laserleft(){
  pushMatrix();
  scale(.5);
  if(lasers < 10){
    image(las[lasers], 560, 560);
  }
  else{
    image(las[lasers%10], 598,560);
    int a = lasers/10;
    image(las[a], 524,560);
  }
  popMatrix();
}


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
  stream[b-1]=!stream[b-1];
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
      if(d3>=d2&&d3<=d2+20&&r3<=r2+radians(42)&&r3>=r2-radians(42)){
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
