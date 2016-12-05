class DisturbanceGUI implements Interactive {

  //For disturbance actuator
  int daWidth;
  int daHeight;
  int daX;
  int daY;

  //For tolerance setter
  int dWidth;
  int dHeight;
  int dX;
  int dY;
  int borderWidth = 2;
  float circleYOffset; 

  boolean mouseOver;

  color defaultColor; 
  color hoverColor; 

  MusicDevice parentDevice;

  DisturbanceGUI(int x, int y, int w, int h, MusicDevice device) {

    daWidth = w;
    daHeight = h/6;
    daX = x;
    daY = y;

    dWidth = w/2;
    dHeight = w/2; 
    dX = x+w/2;
    dY = y+h/6;

    parentDevice = device;

    defaultColor = color(255, 168, 130); 
    hoverColor = color(255, 209, 189);
  }

  void update() {
    int tempTolerance = parentDevice.myDisturbanceController.getTolerance();
    circleYOffset = -map(tempTolerance, 0, 100, 0, dHeight);

    if (mouseX >= dX && mouseX <= dX + dWidth && mouseY >= dY + circleYOffset && mouseY <= dY + dHeight) {
      mouseOver = true;
    } else {
      mouseOver = false;
    }
  }

  void display() {

    strokeWeight(borderWidth);
    stroke(255);

    //Drawing disturbance actuator
    int tempTurnDown = parentDevice.myDisturbanceController.turnDownLevel;
    fill(67, 147, 178);
    rect(daX, daY, daWidth-borderWidth, daHeight-borderWidth);
    
    ellipseMode(CORNER);
    fill(248,75,0);
    for (int y = 10; y < daHeight-10; y += 20){
      for (int x = 10; x < daWidth-10; x += 20){
        ellipse(daX+x, daY+y, tempTurnDown, tempTurnDown);
      }
    }

    //Drawing tolerance setter
    fill(0);
    ellipse(dX, dY, dWidth-borderWidth, dHeight-borderWidth);

    if (mouseOver) {
      fill (hoverColor);
    } else {
      fill(defaultColor);
    }

    ellipse(dX, dY+circleYOffset, dWidth-borderWidth, dHeight-borderWidth);
  }

  void releaseEvent() {
    //Not in use
  }

  void scrollEvent(float val) {

    if (mouseOver) {
      int tempTolerance = parentDevice.myDisturbanceController.getTolerance();
      tempTolerance = constrain(tempTolerance += val, 0, 100);
      parentDevice.myDisturbanceController.setTolerance(tempTolerance);
    }
  }
}