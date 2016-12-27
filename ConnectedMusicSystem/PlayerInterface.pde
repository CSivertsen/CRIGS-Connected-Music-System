class PlayerInterface implements Interactive {

  float PWidth;
  float PHeight;
  float Px;
  float Py;
  float borderWidth = 2;
  float padding = 5;
  int stepXOffset;
  boolean mouseOver;
  color defaultColor; 
  color inactiveColor; 
  color hoverColor; 
  MusicDevice parentDevice;

  PlayerInterface(float x, float y, float w, float h, MusicDevice device) {

    PWidth = w/2;
    PHeight = h/6;
    Px = x+w/2;
    Py = y+h/6;

    defaultColor = color(255, 130, 155); 
    inactiveColor = color(202, 183, 187); 
    hoverColor = color(255, 150, 175);

    parentDevice = device;
  }

  public void display() {

    strokeWeight(borderWidth);
    stroke(255);

    fill(0);
    rect(Px, Py, PWidth-borderWidth, PHeight-borderWidth);

    if (mouseOver) {
      fill (hoverColor);
    } else {
      fill(defaultColor);
    }
    rect(Px+stepXOffset, Py, PWidth-borderWidth, PHeight-borderWidth);

    fill(255);
    textSize(12);
    text(parentDevice.myPlayer.currentSong.getTitle(), Px+padding+stepXOffset, Py+padding);
    text(parentDevice.myPlayer.currentSong.getArtist(), Px+padding+stepXOffset, Py+20);
    if (parentDevice.myPlayer.currentSong.isPaused){
      text("-Paused-", Px+padding+stepXOffset, Py+40); 
    }

  }

  void update() {

    if (mouseX >= Px && mouseX <= Px + PWidth && mouseY >= Py && mouseY <= Py + PHeight) {
      mouseOver = true;
    } else {
      mouseOver = false;
    }
  }

  void releaseEvent() {

    if (mouseOver && mouseButton == LEFT) {
      parentDevice.myPlayer.pause(true);
      if (millis() - lastClick > 1500 ) {
        parentDevice.myPlaylist.addSong(new Song(SongIdentificator.identifySong()), 0, true);
      } else if (millis() - lastClick < 1500) {
        parentDevice.myPlaylist.addSong(new Song("0"), 0, true);
      }

      stepXOffset = 0 ;
    }
  }

  void clickEvent() {
    if (mouseOver && mouseButton == LEFT) {
      stepXOffset = 40;
    } else if (mouseOver && mouseButton == RIGHT) {
      if (parentDevice.myPlayer.isPlaying()) {
        parentDevice.myPlayer.pause(true);
      } else if (!parentDevice.myPlayer.isPlaying()) {
        parentDevice.myPlayer.play(true);
      }
    }
  }

  void scrollEvent(float val) {

    /*if (mouseOver) {
      currentGain = parentDevice.myPlayer.getGain();
      currentGain += val;
      parentDevice.myPlayer.setGain(currentGain);    
      println(currentGain);
    }*/
  }
}