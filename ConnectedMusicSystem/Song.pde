class Song {


  AudioPlayer file; 
  AudioMetaData meta;
  String songID;

  Song(String ID) { 
    songID = ID;

    if (songID != "0") {
      file = minim.loadFile(ID+".mp3");
      meta = file.getMetaData();
    }
  }

  String getTitle() {
    if (songID != "0") { 
      return meta.title();
    } else {
      return "";
    }
  }

  String getArtist() {
    if (songID != "0") {
      return meta.author();
    } else {
      return "";
    }
  }

  void play() {
    if (songID != "0") {
      file.play();
    }
  }

  void pause() {
    if (isPlaying()) {
      file.pause();
    }
  }

  int getPosition() {
    if (songID != "0") {
      return file.position();
    } else {
      return 0;
    }
  }

  int getLength() {
    if (songID != "0") {
      return file.length();
    } else {
      return 0;
    }
  }
  
  boolean isPlaying() {
    if (songID != "0") {
      return file.isPlaying();
    } else {
      return false;
    }
  }
  
  float getGain() {
    if (songID != "0") {
      return file.getGain();
    } else {
      return 0;
    }
  }
  
  void setGain(float gain){
    if (songID != "0"){
      file.setGain(gain);
    }
  }
}