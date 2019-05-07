class SpaceShip{
  PImage spaceShipImg;
  int xspeed = 11;
  int yspeed = 12;
  int posX, posY;
  
  SpaceShip(int iniX, int iniY){
    posX = iniX;
    posY = iniY;
    spaceShipImg = loadImage("./pictures/space_ship.png");
    image(spaceShipImg, posX, posY, 80, 80);
  }
  
  void move(int dirX, int dirY){
    int nextPosX = posX + dirX * xspeed;
    int nextPosY = posY + dirY * yspeed * -1 ;
    if(nextPosX+80 < 1200 && nextPosX > 0){
      posX = nextPosX;
    }
    if(nextPosY+80 < 600 && nextPosY > 0){
      posY = nextPosY;
    }
    image(spaceShipImg, posX, posY, 80, 80);
  }
  
  void reset(){
    posX = 100;
    posY = 260;
  }
}
