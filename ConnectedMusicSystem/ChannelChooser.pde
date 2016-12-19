class ChannelChooser implements Interactive {

  float CCWidth;
  float CCHeight;
  float CCx;
  float CCy;
  color defaultColor;
  color hoverColor;
  color activeHoverColor;
  color activeColor; 
  color unactiveColor; 
  int channelID; 
  int oldChannelID;
  boolean isEditable;
  boolean wasConfirmed; 
  SenderReceiver mySenderReceiver; 

  FlipSwitch[] switches;
  int numSwitches = 4;

  SharingToggle sharingToggle;

  ChannelChooser(float x, float y, float w, float h) {

    CCWidth = w/3;
    CCHeight = h/2;
    CCx = x-CCWidth;
    CCy = y+h/6;

    defaultColor = color(255, 247, 107);
    hoverColor = color(255, 255, 127);
    activeColor = color(255, 210, 107);
    activeHoverColor = color(255,216,127);
    unactiveColor = color(150); 

    switches = new FlipSwitch[numSwitches];

    for (int i = 0; i < numSwitches; i++) {
      switches[i] = new FlipSwitch(CCx, CCy, CCWidth, CCHeight, i);
    }

    sharingToggle = new SharingToggle(CCx, CCy, CCWidth, CCHeight);
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

    sharingToggle.display();
  }

  void update() {
    int tempID = 0;

    for (FlipSwitch flipSwitch : switches) {
      flipSwitch.update();
      if (flipSwitch.isOn()) {
        //tempID += pow(2, flipSwitch.getID());
        tempID++;
      }
    }

    channelID = tempID;

    //println(wasConfirmed + " " + oldChannelID + " " + channelID);
    if (oldChannelID != channelID && wasConfirmed) {
      //println("ChannelChooser calls resubscribe");
      mySenderReceiver.resubscribe(channelID);
      wasConfirmed = false;
    }

    sharingToggle.update();
  }

  void releaseEvent() {
    for (FlipSwitch flipSwitch : switches) {
      flipSwitch.releaseEvent();
    }

    sharingToggle.releaseEvent();
  }

  class SharingToggle implements Interactive {

    float stX;
    float stY;
    float stW;
    float stH;
    int borderWidth = 2;
    boolean isOn;
    boolean mouseOver;

    SharingToggle(float x, float y, float w, float h) {

      stW = w/2;
      stH = w/2;
      stX = x-(stW-borderWidth);
      stY = y;
    }

    void update() {

      if (mouseX >= stX && mouseX <= stX + stW && mouseY >= stY && mouseY <= stY + stH) {
        mouseOver = true;
      } else {
        mouseOver = false;
      }
    }

    void releaseEvent() {
      
      if (mouseOver && isOn == false) {
        isOn = true;
        isEditable = true;
        mySenderReceiver.resubscribe(0);
        oldChannelID = 0;
      } else if (mouseOver && isOn == true) {
        isOn = false;
        isEditable = false;
        wasConfirmed = true;
      }
       
      
    }

    void display() {

      ellipseMode(CORNER);
      strokeWeight(borderWidth);
      stroke(255);
      
      if (mouseOver) {
        if (isOn) {
          fill(activeHoverColor);
        } else if (!isOn){
          fill(hoverColor);
        }
      } else if (isOn) {
        fill(activeColor);
      } else {
        fill(defaultColor);
      }
          
      ellipse(stX, stY, stW-borderWidth, stH-borderWidth);
    }
  }


  class FlipSwitch implements Interactive {

    int switchID;
    float FSWidth;
    float FSHeight;
    float FSx;
    float FSy;
    int borderWidth = 2;
    boolean mouseOver;
    boolean isOn;

    FlipSwitch(float x, float y, float w, float h, int ID) {
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
      
      if (!isEditable){
        if (!isOn){
          fill(unactiveColor);
        } else {
          fill(activeColor);
        }
      } else if (mouseOver){
        if (isOn){
          fill(activeHoverColor);
        } else {
          fill(hoverColor);
        }
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
      if (isEditable) {
        if (mouseOver && isOn == false) {
          isOn = true;
        } else if (mouseOver && isOn == true) {
          isOn = false;
        }
      }
    }
  }
}