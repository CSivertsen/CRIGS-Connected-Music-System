class VolumeGUI implements Interactive {

  float vW;
  float vH;
  float vX;
  float vY;
  int borderWidth = 2;
  float volumeXOffset; 

  boolean mouseOver;

  color defaultColor; 
  color hoverColor; 
  color ringColor;
  
  float currentGain;
  float gainDisplayed;

  MusicDevice parentDevice;

  VolumeGUI(float x, float y, float w, float h, MusicDevice device) {

    vW = w;
    vH = h/6;
    vX = x;
    vY = y;

    parentDevice = device;

    defaultColor = color(67, 147, 178); 
    hoverColor = color(119,180,204);
    ringColor = color(255, 130, 155, 0.5); 
  }

  void update() {
    volumeXOffset = constrain(-map(currentGain, -15, 14, 0, vW/2), -vW/2, 0);

    if (mouseX >= vX + volumeXOffset && mouseX <= vX + vW + volumeXOffset && mouseY >= vY  && mouseY <= vY + vH) {
      mouseOver = true;
    } else {
      mouseOver = false;
    }
  }

  void display() {
    strokeWeight(borderWidth);
    stroke(255);
    
    fill(0);
    rect(vX, vY, vW-borderWidth, vH-borderWidth);
    
    if (mouseOver) {
      fill (hoverColor);
    } else {
      fill(defaultColor);
    }
    rect(vX+volumeXOffset, vY, vW-borderWidth, vH-borderWidth);
    
    if (parentDevice.myPlayer.currentSong.isPlaying()) {
      noFill();
      strokeWeight(5);
      stroke(ringColor);
      ellipseMode(CENTER);

      gainDisplayed = map(currentGain, -15, 14, 0, 10);
      
      for (int i = 0; i <= gainDisplayed; i++) {
        ellipse(vX+vW*0.75, vY+vH/2, vW*(0.3+(i*0.3)), vW*(0.3+(i*0.3)));
      }
    }
  }

  void scrollEvent(float val) {
    if (mouseOver) {
      currentGain = parentDevice.myPlayer.getGain();
      currentGain = currentGain += val;
      parentDevice.myPlayer.setGain(currentGain);
    }
  }

  void clickEvent() {
  }

  void releaseEvent() {
  }
}