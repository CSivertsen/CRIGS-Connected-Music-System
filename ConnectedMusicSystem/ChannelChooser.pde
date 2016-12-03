class ChannelChooser implements Interactive {

  int CCWidth;
  int CCHeight;
  int CCx;
  int CCy;
  color defaultColor;
  color hoverColor;
  color activeColor; 
  int channelID; 
  SenderReceiver mySenderReceiver; 
  
  FlipSwitch[] switches;
  int numSwitches = 5;

  ChannelChooser(int x, int y, int w, int h) {
    
    CCWidth = w/3;
    CCHeight = h/2;
    CCx = x+w-CCWidth;
    CCy = y+h-CCHeight;
    
    defaultColor = color(255, 247, 107);
    hoverColor = color(255, 255, 127);
    activeColor = color(255, 210, 107);

    switches = new FlipSwitch[numSwitches];

    for (int i = 0; i < numSwitches; i++) {
      switches[i] = new FlipSwitch(CCx, CCy, CCWidth, CCHeight, i);
    }
  }
  
  void setSenderReceiver(SenderReceiver sr) {
      mySenderReceiver = sr;
  }
    
  
  int getChannel() {
    return channelID;
  }

  public void display() {

    for (int i = 0; i < numSwitches; i++) {
      switches[i].display();
    }
  }

  void update() {
    int tempID = 0;
    
    for (FlipSwitch flipSwitch : switches) {
      flipSwitch.update();
      if (flipSwitch.isOn()){
        tempID += pow(2,flipSwitch.getID());
      }
    }
    
    int oldChannelID = channelID; 
    channelID = tempID;
    if (oldChannelID != channelID) {
      mySenderReceiver.resubscribe(channelID);
    }

  }
  
    void releaseEvent() {
      for (FlipSwitch flipSwitch : switches) {
      flipSwitch.releaseEvent();
      }
  }


  class FlipSwitch {

    int switchID;
    int FSWidth;
    int FSHeight;
    int FSx;
    int FSy;
    int borderWidth = 2;
    boolean mouseOver;
    boolean isOn;

    FlipSwitch(int x, int y, int w, int h, int ID) {
      switchID = ID;
      
      FSWidth = w;
      FSHeight = h/numSwitches;
      FSx = x;
      FSy = y + FSHeight * switchID;
    }
    
    int getID() {
      return switchID;
    }
    
    boolean isOn() {
     return isOn;
    }

    void display() {

      strokeWeight(borderWidth);
      stroke(255);
      if (mouseOver) {
        fill(hoverColor);
      } else if (isOn) {
        fill(activeColor);
      } else {
        fill(defaultColor);
      }
      rect(FSx, FSy, FSWidth-borderWidth, FSHeight-borderWidth);
    }

    void update() {

      if (mouseX >= FSx && mouseX <= FSx + FSWidth && mouseY >= FSy && mouseY <= FSy + FSHeight) {
        mouseOver = true;
      } else {
        mouseOver = false;
      }
    }

    void releaseEvent() {
      if (mouseX >= FSx && mouseX <= FSx + FSWidth && mouseY >= FSy && mouseY <= FSy + FSHeight && isOn == false) {
        isOn = true;
      } else if (mouseX >= FSx && mouseX <= FSx + FSWidth && mouseY >= FSy && mouseY <= FSy + FSHeight && isOn == true) {
        isOn = false;
      }
      
      
    }
  }
}