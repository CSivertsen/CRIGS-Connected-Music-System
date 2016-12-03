class Song {
  
  int sWidth = 80;
  int sHeight = 20;
  int sX;
  int sY;
  int padding = 3;
  String songTitle;
  boolean isBeingDragged;
  
  Song(String songTitle_, int x, int y) {
    
    sX = x;
    sY = y;
    
    songTitle = songTitle_;
    
  }
  
  String getTitle() {
    return songTitle;
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
    text(songTitle, sX+padding, sY+padding); 
    
  }
  
  void clickEvent(){
    if (mouseX >= sX && mouseX <= sX + sWidth && mouseY >= sY && mouseY <= sY + sHeight) {
      isBeingDragged = true;
    } else {
      isBeingDragged = false;
    }
  }
  
  void releaseEvent(){
    if (isBeingDragged) {
      isBeingDragged = false;
    }
  }
  
}