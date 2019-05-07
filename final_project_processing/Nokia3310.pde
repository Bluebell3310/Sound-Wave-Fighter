class Nokia3310{
  PImage nokia3310Img;
  boolean isAlive;
  int posX, posY;
  
  Nokia3310(int num){
    posX = -30;
    posY = num * 100;
    isAlive = true;
    nokia3310Img = loadImage("./pictures/nokia3310.png");
  }
  
  void display(){
    if(isAlive){
      image(nokia3310Img, posX, posY);
    }
  }
  
  boolean collision(int enemyX, int enemyY){
    if((enemyX > 0) && (enemyX < posX + 65) && (enemyY > posY) && (enemyY < posY + 100)){
      isAlive = false;
      return true;
    }else{
      return false;
    }
  }
}
