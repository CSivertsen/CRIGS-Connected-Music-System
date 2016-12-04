class PlayerInterface implements Interactive {

  int PWidth;
  int PHeight;
  int Px;
  int Py;
  int borderWidth = 2;
  boolean mouseOver;
  boolean SongIsPlaying;
  Song currentSong; 
  color defaultColor; 
  color inactiveColor; 
  color hoverColor; 
  MusicDevice parentDevice;


  PlayerInterface(int x, int y, int w, int h, MusicDevice device) {
    
    PWidth = w/2;
    PHeight = h/6;
    Px = x;
    Py = y+h/6;

    defaultColor = color(255, 130, 155); 
    inactiveColor = color(202, 183, 187); 
    hoverColor = color(255, 150, 175);
    
    parentDevice = device;
    
    //For testing

  }
  
  void playSong() {
    if (currentSong != null) {
      SongIsPlaying = true;
    }  
  }
  
  void stopSong() {
    SongIsPlaying = false;
  }

  Song getSong() {
    return currentSong;
  }

  void setSong(Song s) {
    currentSong = s;
  }

  public void display() {

    strokeWeight(borderWidth);
    stroke(255);
    if (mouseOver) {
      fill (hoverColor);
    } else {
      fill(defaultColor);
    }
    rect(Px, Py, PWidth-borderWidth, PHeight-borderWidth);
    
    fill(255);
    text(currentSong.getTitle(), Px, Py);
    text(currentSong.getArtist(), Px, Py+15);
  }

  void update() {

    if (mouseX >= Px && mouseX <= Px + PWidth && mouseY >= Py && mouseY <= Py + PHeight) {
      mouseOver = true;
    } else {
      mouseOver = false;
    }
    
    currentSong = parentDevice.myPlaylist.getSong(0);
    if (currentSong.songID != "0" && !currentSong.isPlaying){
      currentSong.play();
    }
  }

  void releaseEvent() {
    
    //If being dragged then set this is a currentSong
    
    if (SongIsPlaying) {
      stopSong();
    } else {
      playSong();
    }
    
    if(mouseOver && millis() - lastClick > 1500 ){
        parentDevice.myPlaylist.addSong(new Song(SongIdentificator.identifySong()),0);
    } else if ( mouseOver && millis() - lastClick < 1500) {
        parentDevice.myPlaylist.addSong(new Song("0"),0);
    } 
  }
}