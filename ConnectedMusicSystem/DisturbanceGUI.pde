class DisturbanceGUI implements Interactive {

  //For disturbance actuator
  float daWidth;
  float daHeight;
  float daX;
  float daY;

  //For tolerance setter
  float dWidth;
  float dHeight;
  float dX;
  float dY;
  int borderWidth = 2;
  float circleYOffset; 

  boolean mouseOver;

  color defaultColor; 
  color hoverColor; 

  MusicDevice parentDevice;

  DisturbanceGUI(float x, float y, float w, float h, MusicDevice device) {

    daWidth = w/2;
    daHeight = h/2;
    daX = x;
    daY = y+h/2;

    dWidth = w/2;
    dHeight = w/2; 
    dX = x;
    dY = y+h/6;

    parentDevice = device;

    defaultColor = color(255, 168, 130); 
    hoverColor = color(255, 209, 189);
  }

  void update() {
    int tempTolerance = parentDevice.myDisturbanceController.getTolerance();
    circleYOffset = map(tempTolerance, 0, 100, 0, dHeight);

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
    fill(255);
    //fill(67, 147, 178);
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