class BackCatalogue {
  
  //Display
  int bcWidth;
  int bcHeight;
  int bcX;
  int bcY;
  int borderWidth = 2;
  
  BackCatalogue(int x, int y, int w, int h) {
      bcWidth = w;
      bcHeight = h/6;
      bcX = x;
      bcY = y;
    
  }
  
  public void display() {
    
    strokeWeight(borderWidth);
    stroke(255);
    fill(67,147,178);
    rect(bcX, bcY, bcWidth-borderWidth, bcHeight-borderWidth);
    
  }
  
}