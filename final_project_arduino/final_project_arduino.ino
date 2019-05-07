void setup() {
  Serial.begin(9600);
}

void loop() {
  int a0 = analogRead(A0);
  int a1 = analogRead(A1);
  int dirX = 0;
  int dirY = 0;
  if(a0 > 540){
    dirX = 1;
  }else if(a0 < 490){
    dirX = 2;
  }else{
    dirX = 0;
  }
  
  if(a1 > 545){
    dirY = 1;
  }  else if(a1 < 495){
    dirY = 2;
  }else{
    dirY = 0;
  }
  Serial.write(dirX);
  Serial.write(dirY);
  delay(40);
}
