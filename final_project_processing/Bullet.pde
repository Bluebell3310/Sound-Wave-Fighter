class Bullet{
  PImage bulletImg;
  int posX, posY;
  boolean isAlive;
  int speed = 20;
  int type;
  
  Bullet(int playerX, int playerY, int type){
    this.type = type;
    if(type == 1){
      bulletImg = loadImage(".\\pictures\\bullet1.gif");
    }else if(type == 2){
      bulletImg = loadImage(".\\pictures\\bullet2.png");
    }else if(type == 3){
      bulletImg = loadImage(".\\pictures\\bullet3.png");
    }
    
    isAlive = true;
    posX = playerX + 65;
    posY = playerY + 30;
  }
  
  void display(){
    if(isAlive){
      image(bulletImg, posX, posY, 25, 25);
    }
  }
  
  void move(){
    posX += speed;
  }
  
  boolean collision(int enemyX, int enemyY){
    if((posX > enemyX) && (posX < enemyX + 70) && (posY > enemyY) && (posY < enemyY + 70) && isAlive){
      isAlive = false;
      return true;
    }else{
      return false;
    }
  }
}
