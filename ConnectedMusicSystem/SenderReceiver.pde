class SenderReceiver {

  OOCSI oocsi;
  OOCSIString[] sharedIDPlaylist = null;
  OOCSIInt sharedSongPos = null;
  OOCSISync os;
  
  boolean playRequested = false;
  boolean pulse = false;

  int numID;
  String fullID;
  String channelName = "CMSChannel0";
  String channelPrefix = "CMSChannel";

  MusicDevice parentDevice;

  SenderReceiver(ChannelChooser channelChooser, MusicDevice device) {
    parentDevice = device;
    numID = int(random(500, 999999));
    fullID = "CMS" + numID;
    oocsi = new OOCSI(this, fullID, "13.94.200.130");

    resubscribe(channelChooser.getChannel());
  }

  void resubscribe(int channelID) { //<>//
    
    println("Subscribing");
    if (channelID == 0) {
      channelName = channelPrefix + numID;
    } else {
      channelName = channelPrefix + channelID;
    } 
    oocsi.subscribe(channelName);
    os = Constellation.createSync(oocsi, channelName+"_sync", 2000, "pulse");
    sharedSongPos = Constellation.createInteger(oocsi, channelName, "sharedSongPos");

    sharedIDPlaylist = new OOCSIString[parentDevice.myPlaylist.listLength];
    for (int i = 0; i < sharedIDPlaylist.length; i++) {
      sharedIDPlaylist[i] = Constellation.createString(oocsi, channelName, "ID"+i);
    }

    if (sharedIDPlaylist[0].get().equals("")) { 
      println("Playlist is empty");
      for (int i = 0; i < sharedIDPlaylist.length; i++) {
        sharedIDPlaylist[i].set(parentDevice.myPlaylist.getSong(i).songID);
        println("Putting this ID from own playlist " + parentDevice.myPlaylist.getSong(i).songID + " into this sharedPlaylist at index " + i);
      }
    } else {
      println("Getting the existing playlist");
      getSharedPlaylist();
    }


  }

  void update() {
    if (oocsi.isConnected()) {
      for (int i = 0; i < parentDevice.myPlaylist.songs.length; i++) {
        String songID = sharedIDPlaylist[i].get();
        //println("Fetched song ID " + songID + " at index " + i);
        if (parentDevice.myPlaylist.songs[i].songID != songID && !songID.equals("")) {
          println("Updating SongID from shared playlist: " + songID + " at index " + i);
          parentDevice.myPlaylist.addSong(new Song(songID), i, false);
        }
      }
    }
    
    int currentSongPos = parentDevice.myPlayer.getPosition();
    
    if (currentSongPos > sharedSongPos.get()){ 
      println("Updating cue");
      sharedSongPos.set(parentDevice.myPlayer.getPosition());
    }

    /*if (pulse && parentDevice.myPlayer.isPaused() ) {
      pulse = false;
      if (os.isSynced()) {
        parentDevice.myPlayer.play();
      }
    }*/
    
    if(os.isSynced()){
      fill(255);
    }
    //For debugging
    int frames = os.getProgress();
    if(frames == 0){
      fill(0);
    }
    ellipse(sin(map(frames, 0, os.getResolution(), 0, TWO_PI) * 2) * 70 + parentDevice.deviceX-parentDevice.deviceWidth/2, cos(map(frames, 0, os.getResolution(), 0, TWO_PI)) * 70 + 100, 10, 10);
    
    if(pulse){
      pulse = false;
      println("pulse");
      //For debugging
      fill(255);
      ellipse(10, 10, 50, 50);
      
      if (playRequested && os.isSynced()) {
          println("Confirming play at cue " + sharedSongPos.get());
          parentDevice.myPlayer.confirmPlay(sharedSongPos.get());
      }
    }
  }
  
  void requestPlay(){
    playRequested = true;
  }

  void pulse() {
    println("pulse");
    pulse = true;
  }

  void handleOOCSIEvent(OOCSIEvent message) {
    // print out all values in message
    //println(message.keys());
  }

  void addToPlaylist(String ID, int i) {
    sharedIDPlaylist[i].set(ID);
  }

  /*void removeFromPlaylist() {
   }*/

  void getSharedPlaylist() {
    for (int i = 0; i < parentDevice.myPlaylist.songs.length; i++) { 
      if(i == 0){
        
      }
      String tempID = sharedIDPlaylist[i].get();
      parentDevice.myPlaylist.addSong(new Song(tempID), i, false);
    }
  }
}