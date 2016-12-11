class Song {

  AudioPlayer file; 
  AudioMetaData meta;
  String songID;
  boolean isPaused = true;

  Song(String ID) { 

    
    songID = ID;

    if (!songID.equals("0")) {
      file = minim.loadFile(songID+".mp3");
      meta = file.getMetaData();
    }
  }

  String getTitle() {
    if (!songID.equals("0")) { 
      return meta.title();
    } else {
      return "";
    }
  }

  String getArtist() {
    if (!songID.equals("0")) {
      return meta.author();
    } else {
      return "";
    }
  }

  void cue(int cue) {
    file.cue(cue);
  }

  void play() {
    if (!songID.equals("0")) {
      file.play();
      isPaused = false;
    }
  }

  void pause() {
    if (isPlaying()) {
      file.pause();
      isPaused = true;
    }
  }

  int getPosition() {
    if (!songID.equals("0")) {
      return file.position();
    } else {
      return 0;
    }
  }

  int getLength() {
    if (!songID.equals("0")) {
      return file.length();
    } else {
      return 0;
    }
  }

  boolean isPlaying() {
    if (!songID.equals("0")) {
      return file.isPlaying();
    } else {
      return false;
    }
  }

  boolean isPaused() {
    return isPaused;
  }

  float getGain() {
    if (!songID.equals("0")) {
      return file.getGain();
    } else {
      return 0;
    }
  }

  void setGain(float gain) {
    if (!songID.equals("0")) {
      file.setGain(gain);
    }
  }
}