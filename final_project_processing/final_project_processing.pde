import themidibus.*;
import processing.sound.*;
import processing.serial.*;
Serial port;

PImage bgImg;
int bgPosX;
Enemy[] enemy;
Bullet[] bullet;
Nokia3310[] nokia3310;
SpaceShip spaceShip;
int curSpawnEnmy = 0;  //index of spawn enemy
int curShootBullet = 0;
int enemyNum = 20;
int bulletNum = 40;
int bulletDelay = 3;
int delayCount = 0;
int nokia3310Num = 6;
int gameState = 1;
int curTime;
int startTime;
SoundFile expSound, shootSound;
MidiBus myBus;
int dirX, dirY;
int val1, val2;
int volumeThreshold = 55;
int curVolume = 0;
int bullet1Left = 40;
int bullet1Right = 44;
int bullet2Left = 45;
int bullet2Right = 49;
int bullet3Left = 50;
int bullet3Right = 54;
float soundRectPos = 350;
float curSoundRectPos = 0;
float targetSoundRectPos = 0;
float volumeRectPos = 350;
float curVolumeRectPos = 0;
float targetVolumeRectPos = 0;
int bigWeapon = 3;
int bigWeaponThreshold = 550;
int volumeHolding = 0;

void setup(){
  size(1200, 600);
  background(0);
  frameRate(30);
  enemy = new Enemy[enemyNum];
  bullet = new Bullet[bulletNum];
  nokia3310 = new Nokia3310[nokia3310Num];
  for(int i=0; i<nokia3310Num; i++){
    nokia3310[i] = new Nokia3310(i);
  }
  expSound = new SoundFile(this, "./sounds/explosion.mp3");
  shootSound = new SoundFile(this, "./sounds/shoot.mp3");
  
  bgImg = loadImage(".\\pictures\\background.jpg");
  String portName = Serial.list()[0];
  port = new Serial(this, portName, 9600);
  myBus = new MidiBus(this, 0, -1);
  
  
}

void draw(){
  if(gameState == 1){
    menu();
  }else if(gameState == 2){
    playing();
  }else if(gameState == 3){
    gameOver();
  }else if(gameState == 4){
    win();
  }
  
}

void spawnEnemy(int type){
  enemy[curSpawnEnmy] = new Enemy(type);
  curSpawnEnmy++;  //index of spawn enemy
  if(curSpawnEnmy == enemyNum - 1){
    curSpawnEnmy = 0;
  }
}

void shoot(int x, int y, int type){
  bullet[curShootBullet] = new Bullet(x, y, type);
  curShootBullet++;  //index of shoot bullet
  if(curShootBullet == bulletNum - 1){
    curShootBullet = 0;  
  }
}

void playing(){
  bgPosX -= 2;
  if(bgPosX <= -1200){
    bgPosX = 0;
  }
  image(bgImg, bgPosX, 0);
  if(port.available() >= 2){
    val1 = port.read();
    val2 = port.read();
  }
  if(val1 == 2){
    val1 = -1;
  }
  if(val2 == 2){
    val2 = -1;
  }
  spaceShip.move(val1, val2);
  fill(255, 0, 0);
  textSize(40);
  curTime = 40 - int(millis()/1000) + startTime;
  text(curTime, 1100, 60);
  if(curTime == 0){
    cursor();
    gameState = 4;
  }
  
  fill(150);
  rect(350, 10, 250, 35);
  fill(125, 0, 0);
  rect(395, 10, 50, 35);
  fill(0, 255, 0);
  rect(445, 10, 50, 35);
  fill(255, 0, 255);
  rect(490, 10, 50, 35);
  if(targetSoundRectPos > curSoundRectPos){
    soundRectPos += 4;
    curSoundRectPos = soundRectPos;
  }else if (targetSoundRectPos < curSoundRectPos){
    soundRectPos -= 4;
    curSoundRectPos = soundRectPos;
  }
  fill(255, 0, 0);
  rect(soundRectPos, 10, 5, 35);
  
  fill(150);
  rect(350, 47, 250, 35);
  fill(0, 125, 0);
  rect(495, 47, 4, 35);
  fill(255, 0, 0);
  rect(570, 47, 4, 35);
  if(targetVolumeRectPos > curVolumeRectPos){
    volumeRectPos += 5;
    curVolumeRectPos = volumeRectPos;
  }else{
    volumeRectPos -= 5;
    curVolumeRectPos = volumeRectPos;
  }
  fill(0, 0, 255);
  rect(volumeRectPos, 47, 5, 35);
  
  if(volumeRectPos > bigWeaponThreshold){
    volumeHolding++;
    if(volumeHolding > 20){
      if(bigWeapon > 0){
        bigWeapon();
        bigWeapon--;
      }
      volumeHolding = 0;
      volumeRectPos = 350;
    }
  }
  fill(255, 255, 0);
  textSize(33);
  text(bigWeapon, 610, 75);
  
  for(int i=0; i<nokia3310Num; i++){
    nokia3310[i].display();
  }
  float spawnOrNot = random(0, 1); //control the spawn rate of enemy
  if(spawnOrNot < 0.035){  //if the random num less then threshold, enemy will spawn
    spawnEnemy(int(random(1,4)));
  }
  for(int i=0; i<enemyNum; i++){  //move the enemy
    if(enemy[i] != null){  // in case of enemy not declare yet  
      enemy[i].move();
      enemy[i].display();
    }
  }
  
  for(int i=0; i<bulletNum; i++){  //move the bullet
    if(bullet[i] != null){  // in case of bullet not declare yet 
      bullet[i].move();
      bullet[i].display(); 
    }
  }
  
  // collision detect
  for(int i=0; i<enemyNum; i++){  //detect each enemy
    if(enemy[i] != null){  //prevent null error
      //bullet collision detect
      for(int j=0; j<bulletNum; j++){   
        if(bullet[j] != null && bullet[j].isAlive && enemy[i].isAlive){   //prevent null error and bullet, enemy needs to be alive
          if( bullet[j].collision(enemy[i].posX, enemy[i].posY) == true && bullet[j].type == enemy[i].type){
            enemy[i].explosion();
          }
        }
      }
      //nokia3310 collision detect
      for(int j=0; j<nokia3310Num; j++){
        if(enemy[i].isAlive && nokia3310[j].isAlive){
          if( nokia3310[j].collision(enemy[i].posX, enemy[i].posY) == true){
            enemy[i].explosion();
          }
        }else if(enemy[i].isAlive && nokia3310[j].isAlive == false){
          if( nokia3310[j].collision(enemy[i].posX, enemy[i].posY) == true){
            cursor();
            gameState = 3;
          }
        }
      }
    }
  } 
}

void bigWeapon(){
  expSound.play();
  for(int i=0; i<enemyNum; i++){
    if(enemy[i] != null){
      enemy[i].deadByBigWeapon();
    }
  }
}

void menu(){
  background(0);
  fill(255);
  textSize(50);
  text("Sound Wave Fighter" , 365, 250);
  if( (mouseX > 500) && (mouseX < 500+200) && (mouseY > 400) && (mouseY < 400+70) ){
    fill(255, 255, 0);
    rect(500, 400, 200, 70);
    if(mousePressed == true){
      gameState = 2;
      reset();
      startTime = int(millis()/1000);
      setCursor();
    }
  }else{
    fill(255);
    rect(500, 400, 200, 70);
  }
  textSize(23);
  fill(0);
  text("Start Again", 540, 440);
}

void gameOver(){
  background(0);
  fill(255);
  textSize(50);
  text("You Lose..." , 450, 300);
  if( (mouseX > 480) && (mouseX < 480+200) && (mouseY > 350) && (mouseY < 350+70) ){
    fill(255, 255, 0);
    rect(480, 350, 200, 70);
    if(mousePressed == true){
      reset();
      gameState = 2;
      startTime = int(millis()/1000);
      setCursor();
    }
  }else{
    fill(255);
    rect(480, 350, 200, 70);
  }
  textSize(23);
  fill(0);
  text("Start Again", 520, 390);

}

void win(){
  background(0);
  fill(255);
  textSize(40);
  text("Congratulations! You are the best singer ever!" , 160, 300);
}

void reset(){
  for(int i=0; i<enemyNum; i++){
    enemy[i] = null;
  }
  for(int i=0; i<bulletNum; i++){
    bullet[i] = null;
  }
  for(int i=0; i<nokia3310Num; i++){
    nokia3310[i].isAlive = true;
  }
  port.clear();
  if(spaceShip != null){
    spaceShip.reset();
  }
  bigWeapon = 3;
}

void setCursor(){
  noCursor();
  spaceShip = new SpaceShip(100, 260);
}

void controllerChange(int channel, int number, int value){
  if(number == 1){
    targetSoundRectPos = map(value, 40, 60, 400, 600);
    shootTypeJud(value);
  }else if(number == 2){
    targetVolumeRectPos = map(value, 27, 90, 400, 600);
    curVolume = value;
  }
}

void shootTypeJud(int value){
  if(curVolume > volumeThreshold){
    if(value >= bullet1Left && value <= bullet1Right){
      delayCount++;
      if(delayCount >= bulletDelay){
        shoot(spaceShip.posX, spaceShip.posY, 1);
        delayCount = 0;
      }
    }else if(value >= bullet2Left  && value <= bullet2Right){
      delayCount++;
      if(delayCount >= bulletDelay){
        shoot(spaceShip.posX, spaceShip.posY, 2);
        delayCount = 0;
      }
    }else if(value >= bullet3Left && value <= bullet3Right){
      delayCount++;
      if(delayCount >= bulletDelay){
        shoot(spaceShip.posX, spaceShip.posY, 3);
        delayCount = 0;
      }
    }
  }
}
