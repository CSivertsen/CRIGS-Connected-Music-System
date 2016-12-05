class PlayerInterface implements Interactive {

  int PWidth;
  int PHeight;
  int Px;
  int Py;
  int borderWidth = 2;
  int padding = 5;
  int stepXOffset;
  boolean mouseOver;
  Song currentSong; 
  color defaultColor; 
  color inactiveColor; 
  color hoverColor; 
  MusicDevice parentDevice;
  float currentGain;
  float gainDisplayed;
  


  PlayerInterface(int x, int y, int w, int h, MusicDevice device) {

    PWidth = w/2;
    PHeight = h/6;
    Px = x;
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
    text(currentSong.getTitle(), Px+padding+stepXOffset, Py+padding);
    text(currentSong.getArtist(), Px+padding+stepXOffset, Py+20);

    if (currentSong.isPlaying()) {
      noFill();
      strokeWeight(5);
      stroke(defaultColor);
      ellipseMode(CENTER);

      gainDisplayed = map(currentGain, -80, 14, 0, 10);

      for (int i = 0; i <= gainDisplayed; i++) {
        ellipse(Px+PWidth/2, Py+PHeight/2, PWidth*(1.5+(i*0.5)), PWidth*(1.5+(i*0.5)));
      }
    }
  }

  void update() {

    if (mouseX >= Px && mouseX <= Px + PWidth && mouseY >= Py && mouseY <= Py + PHeight) {
      mouseOver = true;
    } else {
      mouseOver = false;
    }

    //THIS SHOULD BE DONE IN THE PLAYER OR PLAYLIST NOT IN THE GUI
    currentSong = parentDevice.myPlaylist.getSong(0);
    if (currentSong.songID != "0" && !currentSong.isPlaying() && currentSong.getPosition() == 0) {
      currentSong.setGain(currentGain); 
      currentSong.play();
      println(currentGain);
      println("A song was started and gain was set");
    }

    if (currentSong.songID == "0") {
      parentDevice.myPlaylist.advance();
    }
  }

  void releaseEvent() {

    if (mouseOver && mouseButton == LEFT) {
      currentSong.pause();
      if (millis() - lastClick > 1500 ) {
        parentDevice.myPlaylist.addSong(new Song(SongIdentificator.identifySong()), 0);
      } else if (millis() - lastClick < 1500) {
        parentDevice.myPlaylist.addSong(new Song("0"), 0);
      }
      
      stepXOffset = 0 ;
    }
  }

  void clickEvent() {
    if (mouseOver && mouseButton == LEFT) {
      stepXOffset = -20;
    } else if (mouseOver && mouseButton == RIGHT) {
      if (currentSong.isPlaying()){
        currentSong.pause();
      } else if (!currentSong.isPlaying()){
        currentSong.play();
      }
    }
    
  }

  void scrollEvent(float val) {

    if (mouseOver) {
      currentGain = currentSong.getGain();
      currentGain += val;
      currentSong.setGain(currentGain);    
      println(currentGain);
    }
  }
}