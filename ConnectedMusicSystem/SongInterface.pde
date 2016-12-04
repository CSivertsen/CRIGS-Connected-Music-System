class SongInterface {
  
  Song containedSong;
  int sWidth = 80;
  int sHeight = 20;
  int sX;
  int sY;
  int padding = 3;
  boolean isBeingDragged;
  
  SongInterface(int x, int y) {
    
    sX = x;
    sY = y;
    
  }
  
  public void display() {
    
    if (isBeingDragged) {
      println("Jeg bliver trukket");
      sX = mouseX;
      sY = mouseY;
    }
   
    textAlign(LEFT, TOP);
    noStroke();
    fill(255,255,255);
    rect(sX, sY, sWidth, sHeight);
    fill(0);
    text(containedSong.getTitle(), sX+padding, sY+padding); 
    
  }
  
  void clickEvent(){
    containedSong = new Song(SongIdentificator.identifySong());
    
    /*if (mouseX >= sX && mouseX <= sX + sWidth && mouseY >= sY && mouseY <= sY + sHeight) {
      isBeingDragged = true;
    } else {
      isBeingDragged = false;
    }*/
  }
  
  void releaseEvent(){
    /*if (isBeingDragged) {
      isBeingDragged = false;
    }*/
  }
  
}