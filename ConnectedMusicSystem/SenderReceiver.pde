public class SenderReceiver { //<>//

  OOCSI oocsi;
  OOCSIString[][] sharedIDPlaylists;
  OOCSIInt[] sharedSongPos = null;
  OOCSISync os;
  //OOCSIBoolean[] isPaused = null;

  boolean playRequested = false;
  boolean pulse = false;
  boolean isFirstSync = true;
  //boolean wasPaused = false;

  int numID;
  String fullID;
  String channelName = "CMSChannel0";
  String channelPrefix = "CMSChannel";
  String syncChannel = "CMSHouseSync";
  int channelID;
  int numChannels = 5;

  MusicDevice parentDevice;

  public SenderReceiver(ChannelChooser channelChooser, MusicDevice device) {

    parentDevice = device;
    numID = int(random(500, 999999));

    fullID = "CMS" + numID;
    oocsi = new OOCSI(this, fullID, "localhost");    
    //oocsi = new OOCSI(this, fullID, "13.94.200.130");

    os = Constellation.createSync(oocsi, syncChannel, 1000, "pulse");
    os.setResolution(40);

    sharedSongPos = new OOCSIInt[numChannels];
    //isPaused = new OOCSIBoolean[numChannels];

    sharedIDPlaylists = new OOCSIString[numChannels][];    
    for (int i = 0; i < numChannels; i++) {
      sharedIDPlaylists[i] = new OOCSIString[parentDevice.myPlaylist.listLength];
      if (i == 0) {
        sharedSongPos[i] = Constellation.createInteger(oocsi, channelPrefix+numID+"_cue", "sharedSongPos", 0, -1);
        oocsi.subscribe(channelPrefix+numID);
        //isPaused[i] = Constellation.createBoolean(oocsi, channelPrefix+numID+"_pause", "sharedPause");
        for (int j = 0; j < sharedIDPlaylists[i].length; j++) {
          sharedIDPlaylists[i][j] = Constellation.createString(oocsi, channelPrefix+numID, "ID"+i+j, "0", -1);
        }
      } else {
        for (int j = 0; j < sharedIDPlaylists[i].length; j++) {
          sharedIDPlaylists[i][j] = Constellation.createString(oocsi, channelPrefix+(i+1), "ID"+i+j, "0", -1);
        }
        sharedSongPos[i] = Constellation.createInteger(oocsi, channelPrefix+i+"_cue", "sharedSongPos", 0, -1);
        oocsi.subscribe(channelPrefix+i);
        //isPaused[i] = Constellation.createBoolean(oocsi, channelPrefix+i+"_pause", "sharedPause", false, -1);
      }
    }

    resubscribe(channelChooser.getChannel());
  }

  public void resubscribe(int _channelID) {

    channelID = _channelID;  
    println("Subscribing");
    if (channelID == 0) {
      channelName = channelPrefix + numID;
    } else {
      channelName = channelPrefix + channelID;
    } 

    isFirstSync = true;
  }

  public void update() {
    //if (frameCount % 30 == 0) {
    syncPlaylists();
    //}
    syncCue();
  }

  public void requestPlay() {
    playRequested = true;
  }

  public void advance() {
    //println("Advancing shared playlist");
     for (int i = 0 ; i < sharedIDPlaylists[channelID].length-1; i++) {
     sharedIDPlaylists[channelID][i].set(sharedIDPlaylists[channelID][i+1].get());
     } 
     sharedIDPlaylists[channelID][sharedIDPlaylists[channelID].length-1].set("0");
  }  

  public void pulse() {
    //println("pulse");
    pulse = true;
  }

  public void addToPlaylist(String ID, int i) {
    sharedIDPlaylists[channelID][i].set(ID);
    println("Setting sharedPlaylist "+ i + " to " + ID);
  }

  public void syncCue() {
    //println("Play requested? " + playRequested);
    int currentSongPos = parentDevice.myPlayer.getPosition();

    if (currentSongPos > sharedSongPos[channelID].get()) { 
      //println("Updating cue");
      //sharedSongPos[channelID].set(parentDevice.myPlayer.getPosition());
      sharedSongPos[channelID].set(currentSongPos);
    }

    //For debugging
    //if (os.isSynced()) {
    //  fill(255);
    //}

    if (pulse) {
      pulse = false;
      //For debugging
      //fill(255, 0, 0);

      if (playRequested && os.isSynced()) {
        println("Confirming play at cue " + sharedSongPos[channelID].get() + " from " + channelID);
        parentDevice.myPlayer.confirmPlay(sharedSongPos[channelID].get());
        playRequested = false;
      }
    }

    //For debugging
    //int frames = os.getProgress();
    //if (frames == 0) {
    //  fill(0);
    //}
    //ellipse(sin(map(frames, 0, os.getResolution(), 0, TWO_PI) * 2) * 70 + parentDevice.deviceX-parentDevice.deviceWidth/2, cos(map(frames, 0, os.getResolution(), 0, TWO_PI)) * 70 + 100, 10, 10);
  }

  public void syncPlaylists() {
    if (oocsi.isConnected()) {
      for (int i = 0; i < parentDevice.myPlaylist.songs.length; i++) {
        String sharedSongID = sharedIDPlaylists[channelID][i].get();
        String localSongID = parentDevice.myPlaylist.songs[i].songID;
        //println("Fetched sharedSongID " + sharedSongID + " at index " + i);
        //println("Fetched localSongID " + localSongID + " at index " + i);

        //if (!localSongID.equals(sharedSongID) && sharedSongID.equals("-1")) {
        //  println("SharedPlaylist index " + i + " is unitialized - pushing id " + localSongID + " from local playlist");
        //  sharedIDPlaylists[channelID][i].set(localSongID);
        //} else if (!localSongID.equals(sharedSongID)) {
        if (!localSongID.equals(sharedSongID)) {

          if (sharedSongID.equals("0") && isFirstSync) {
            addToPlaylist(localSongID, i);
          } else { 
            println("Updating localSongID from shared playlist: " + sharedSongID + " at index " + i);
            parentDevice.myPlaylist.addSong(new Song(sharedSongID), i, false);
          }
        }
      }
      isFirstSync = false;
      /*print(isPaused[channelID].get());
       println(wasPaused);
       if (isPaused[channelID].get() != wasPaused){
       if (isPaused[channelID].get()) {
       parentDevice.myPlayer.pause();
       } else {
       parentDevice.myPlayer.play();
       println("Sender Receiver enforces play");
       }
       }*/
    }
  }

  void sendAction(String action) {
    oocsi.channel(channelName).data("action", action).send();
  }  

  void handleOOCSIEvent(OOCSIEvent message) {
    // print out all values in message
    if(message.getChannel().equals(channelName) ) {
      //println("Received message in channel");
      String action = message.getString("action", "");
      if (action.equals("play")) {
        parentDevice.myPlayer.play(false);
      } else if (action.equals("pause")) {
        parentDevice.myPlayer.pause(false);
      } /*else if (action.equals("advance")){
        parentDevice.myPlaylist.advance(false);
      }*/
    }
  }
}