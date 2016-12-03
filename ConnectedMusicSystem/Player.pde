class Player implements Interactive {

  int PWidth;
  int PHeight;
  int Px;
  int Py;
  int borderWidth = 2;
  boolean mouseOver;
  boolean songIsPlaying;
  Song currentSong; 
  color defaultColor; 
  color inactiveColor; 
  color hoverColor; 


  Player(int x, int y, int w, int h) {
    
    PWidth = w/2;
    PHeight = h/6;
    Px = x;
    Py = y+h/6;

    defaultColor = color(255, 130, 155); 
    inactiveColor = color(202, 183, 187); 
    hoverColor = color(255, 150, 175);
    
    //For testing
    currentSong = new Song("Test", Px, Py);

  }
  
  void playSong() {
    if (currentSong != null) {
      songIsPlaying = true;
    }  
  }
  
  void stopSong() {
    songIsPlaying = false;
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
    
    if (songIsPlaying) {
      text(currentSong.getTitle(), Px, Py);
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
    
    //If being dragged then set this is a currentSong
    
    if (songIsPlaying) {
      stopSong();
    } else {
      playSong();
    }
  }
}