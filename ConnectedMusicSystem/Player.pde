class Player {

  MusicDevice parentDevice;

  Song currentSong; 
  float currentGain;
  boolean waitingForPlay = false;

  Player(MusicDevice device) {
    
    parentDevice = device;
    currentSong = parentDevice.myPlaylist.songs[0];
  }

  void update() {
    
    Song playlist0 = parentDevice.myPlaylist.songs[0];
    
    if(!currentSong.equals(playlist0)){
      currentSong.pause();
      currentSong = playlist0;
      
    } 

    if (currentSong.songID.equals("0")) {
      parentDevice.myPlaylist.advance();
    }

    if (!currentSong.songID.equals("0") && !currentSong.isPlaying() && currentSong.getPosition() == 0 && !waitingForPlay) {
      currentSong.setGain(currentGain); 
      play();
      println(currentGain);
      println("A song was started and gain was set");
    }
    
    if (!currentSong.isPlaying() && !currentSong.isPaused() && !waitingForPlay){
      
      parentDevice.myPlaylist.advance();
    }
    
  }
  
  void pause(){
    currentSong.pause();
  }
  
  void play(){
    waitingForPlay = true;
    parentDevice.mySenderReceiver.requestPlay();
  }
  
  void confirmPlay(int cue){
    waitingForPlay = false;
    currentSong.cue(cue);
    currentSong.play();  
  }
  
  boolean isPlaying(){
  return currentSong.isPlaying();
  }
  
  boolean isPaused(){
    return currentSong.isPaused();
  }
  
  float getGain(){
  return currentSong.getGain();
  }
  
  int getPosition(){
  return currentSong.getPosition();
  }
  
  void setGain(float gain){
  currentSong.setGain(gain);
  }
  
}