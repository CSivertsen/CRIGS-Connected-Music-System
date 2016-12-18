class PlaylistInterface implements Interactive {

  ListStep[] steps;
  Playlist containedPlaylist;
  float PWidth;
  float PHeight;
  float Px;
  float Py;
  int listLength = 6;
  MusicDevice parentDevice;

  PlaylistInterface(float x, float y, float w, float h, MusicDevice device) {

    PWidth = w/2;
    PHeight = h/3*2;
    Px = x+w/2;
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
  void clickEvent() {
    for (ListStep step : steps) {
      step.clickEvent();
    }
  }

  class ListStep implements Interactive {

    int listStepID;
    float LSWidth;
    float LSHeight;
    float LSx;
    float LSy;
    float borderWidth = 2;
    float padding = 5;
    int stepXOffset;
    boolean mouseOver;

    ListStep(float x, float y, float w, float h, int ID) {

      listStepID = ID;
      LSWidth = w;
      LSHeight = h/listLength;
      LSx = x;
      LSy = y + LSHeight * listStepID;
    }

    void display() {

      strokeWeight(borderWidth);
      stroke(255);
      
      fill(0);
      rect(LSx, LSy, LSWidth-borderWidth, LSHeight-borderWidth);
      
      if (mouseOver) {
        fill (130, 198, 224);
      } else {
        fill(110, 178, 204);
      }
      rect(LSx+stepXOffset, LSy, LSWidth-borderWidth, LSHeight-borderWidth);

      fill(255);
      textSize(12);
      textAlign(LEFT, TOP);
      text(containedPlaylist.getSong(listStepID+1).getTitle(), LSx+padding+stepXOffset, LSy);
      text(containedPlaylist.getSong(listStepID+1).getArtist(), LSx+padding+stepXOffset, LSy+13);
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
      if (mouseOver && millis() - lastClick > 1500 ) {
        containedPlaylist.addSong(new Song(SongIdentificator.identifySong()), listStepID+1, true);
      } else if ( mouseOver && millis() - lastClick < 1500) {
        containedPlaylist.addSong(new Song("0"), listStepID+1, true);
      }
      
      if(mouseOver){
        stepXOffset = 0;
      }
    }

    void clickEvent() {
      if (mouseOver) {
        stepXOffset = 40;
      }
    }
  }
}