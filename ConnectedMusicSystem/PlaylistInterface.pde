class PlaylistInterface implements Interactive {

  ListStep[] steps;
  Playlist containedPlaylist;
  int PWidth;
  int PHeight;
  int Px;
  int Py;
  int listLength = 10;
  MusicDevice parentDevice;

  PlaylistInterface(int x, int y, int w, int h, MusicDevice device) {
    
    PWidth = w/2;
    PHeight = h/3*2;
    Px = x;
    Py = y+h/3;
    
    parentDevice = device;
    
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
    
    containedPlaylist = parentDevice.myPlaylist;

    for (ListStep step : steps) {
      step.update();
    }
  }

  void releaseEvent() {
    for (ListStep step : steps) {
      step.releaseEvent();
    }
  }

  class ListStep implements Interactive {

    int listStepID;
    int LSWidth;
    int LSHeight;
    int LSx;
    int LSy;
    int borderWidth = 2;
    int padding = 5;
    boolean mouseOver;

    ListStep(int x, int y, int w, int h, int ID) {
      
      listStepID = ID;
      LSWidth = w;
      LSHeight = h/listLength;
      LSx = x;
      LSy = y + LSHeight * listStepID;
      
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
      
      fill(255);
      textAlign(LEFT,TOP);
      text(containedPlaylist.getSong(listStepID+1).getTitle(), LSx+padding, LSy);
      text(containedPlaylist.getSong(listStepID+1).getArtist(), LSx+padding, LSy+13);
      
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
      if(mouseOver && millis() - lastClick > 1500 ){
        containedPlaylist.addSong(new Song(SongIdentificator.identifySong()),listStepID+1);
      } else if ( mouseOver && millis() - lastClick < 1500) {
        containedPlaylist.addSong(new Song("0"),listStepID+1);
      } 
    }

  }
}