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
      //if(frameCount % 100 == 0) {
        parentDevice.myPlaylist.advance();
    //}
    }

    if (!currentSong.songID.equals("0") && !currentSong.isPlaying() && currentSong.getPosition() == 0 && !waitingForPlay) {
      currentSong.setGain(currentGain); 
      play(true);
      println(currentGain);
      println("A song was started and gain was set");
    }
    
    if (!currentSong.isPlaying() && !currentSong.isPaused() && !waitingForPlay){
      
      parentDevice.myPlaylist.advance();
    }
    
  }
  
  void pause(boolean shouldPush){
    //println("pausing");
    //parentDevice.mySenderReceiver.isPaused[parentDevice.mySenderReceiver.channelID].set(true);
    //println("I have just set this: " + parentDevice.mySenderReceiver.isPaused[parentDevice.mySenderReceiver.channelID].get());
    //parentDevice.mySenderReceiver.wasPaused = true;
    if (shouldPush){
      parentDevice.mySenderReceiver.sendAction("pause");
    } 
    currentSong.pause();
  }
  
  void play(boolean shouldPush){
    waitingForPlay = true;
    //parentDevice.mySenderReceiver.wasPaused = false;
    //parentDevice.mySenderReceiver.isPaused[parentDevice.mySenderReceiver.channelID].set(false);
    if (shouldPush) {
      parentDevice.mySenderReceiver.sendAction("play");
    }
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