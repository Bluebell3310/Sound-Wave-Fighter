class Enemy{

  PImage enemyImg;
  boolean isAlive;  //Represent if the enemy alive
  int posX, posY; //position of the enemy
  int speed = 6;
  int type;
  
  Enemy(int type){
    isAlive = true;
    this.type = type;
    if(type == 1){
      enemyImg = loadImage(".\\pictures\\enemy1.png");
    }else if(type == 2){
      enemyImg = loadImage(".\\pictures\\enemy2.png");
    }else if(type == 3){
      enemyImg = loadImage(".\\pictures\\enemy3.png");
    }
    
    posX = 1200;
    posY = int(random(0, 6)) * 100 + 15;
  }
  
  void display(){
    if(isAlive){
      image(enemyImg, posX, posY, 70, 70);
    }
  }
  
  void move(){
    posX -= speed;
  }
  
  void explosion(){
    isAlive = false;
    expSound.play();
  }
  
  void deadByBigWeapon(){
    isAlive = false;
  }
}
