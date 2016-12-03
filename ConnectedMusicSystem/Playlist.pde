class Playlist implements Interactive {

  ListStep[] steps;

  int PWidth;
  int PHeight;
  int Px;
  int Py;
  int listLength = 10;

  Playlist(int x, int y, int w, int h) {
    
    PWidth = w/2;
    PHeight = h/3*2;
    Px = x;
    Py = y+h/3;

    steps = new ListStep[listLength];

    for (int i = 0; i < listLength; i++) {
      steps[i] = new ListStep(Px, Py, PWidth, PHeight, i);
    }
  }

  public void display() {

    for (int i = 0; i < listLength; i++) {
      steps[i].display();
    }
  }

  void update() {

    for (ListStep step : steps) {
      step.update();
    }
  }

  void releaseEvent() {
    for (ListStep step : steps) {
      step.releaseEvent();
    }
  }
  
  void requestNext() {
    
  }


  class ListStep implements Interactive {

    int listStepID;
    int LSWidth;
    int LSHeight;
    int LSx;
    int LSy;
    int borderWidth = 2;
    boolean mouseOver;
    Song currentSong; 

    ListStep(int x, int y, int w, int h, int ID) {
      
      listStepID = ID;
      LSWidth = w;
      LSHeight = h/listLength;
      LSx = x;
      LSy = y + LSHeight * listStepID;
      
    }
    
    boolean hasSong(){
      if (currentSong != null) {
        return true; 
      } else {
        return false; 
      }
    }
    
    Song getSong() {
      return currentSong;
    }
    
    void setSong( Song s ) {
      currentSong = s; 
    }

    void display() {

      strokeWeight(borderWidth);
      stroke(255);
      if (mouseOver) {
        fill (130, 198, 224);
      } else {
        fill(110, 178, 204);
      }
      rect(LSx, LSy, LSWidth-borderWidth, LSHeight-borderWidth);
    }

    void update() {

      if (mouseX >= LSx && mouseX <= LSx + LSWidth && mouseY >= LSy && mouseY <= LSy + LSHeight) {
        mouseOver = true;
      } else {
        mouseOver = false;
      }
    }

    void releaseEvent() {
      //action
    }
  }
}