public class SenderReceiver { //<>//

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

  public SenderReceiver(ChannelChooser channelChooser, MusicDevice device) {
    parentDevice = device;
    numID = int(random(500, 999999));
    fullID = "CMS" + numID;
    oocsi = new OOCSI(this, fullID, "localhost");    
    //oocsi = new OOCSI(this, fullID, "13.94.200.130");

    resubscribe(channelChooser.getChannel());
  }

  public void resubscribe(int channelID) {

    println("Subscribing");
    if (channelID == 0) {
      channelName = channelPrefix + numID;
    } else {
      channelName = channelPrefix + channelID;
    } 
    //oocsi.subscribe(channelName);
    os = Constellation.createSync(oocsi, channelName+"_sync", 2000, "pulse");
    sharedSongPos = Constellation.createInteger(oocsi, channelName, "sharedSongPos");

    sharedIDPlaylist = new OOCSIString[parentDevice.myPlaylist.listLength];
    for (int i = 0; i < sharedIDPlaylist.length; i++) {
      sharedIDPlaylist[i] = Constellation.createString(oocsi, channelName, "ID"+i);
    }
  }

  public void update() {
    syncPlaylists();
    syncCue();
  }

  public void requestPlay() {
    playRequested = true;
  }

  public void advance() {
    /*println("Advancing shared playlist");
     for (int i = 0; i < sharedIDPlaylist.length-1; i++) {
     sharedIDPlaylist[i] = sharedIDPlaylist[i+1];
     } 
     sharedIDPlaylist[sharedIDPlaylist.length-1].set("0");*/
  }  

  public void pulse() {
    println("pulse");
    pulse = true;
  }

  public void handleOOCSIEvent(OOCSIEvent message) {
    // print out all values in message
    //println(message.keys());
  }

  public void addToPlaylist(String ID, int i) {
    sharedIDPlaylist[i].set(ID);
  }

  public void syncCue() {
    //println("Play requested? " + playRequested);
    
    int currentSongPos = parentDevice.myPlayer.getPosition();

    if (currentSongPos > sharedSongPos.get()) { 
      println("Updating cue");
      sharedSongPos.set(parentDevice.myPlayer.getPosition());
    }

    //For debugging
    if (os.isSynced()) {
      fill(255);
    }

    if (pulse) {
      pulse = false;
      println("pulse");
      //For debugging
      fill(255, 0, 0);

      if (playRequested && os.isSynced()) {
        println("Confirming play at cue " + sharedSongPos.get());
        parentDevice.myPlayer.confirmPlay(sharedSongPos.get());
      }
    }

    //For debugging
    int frames = os.getProgress();
    if (frames == 0) {
      fill(0);
    }
    ellipse(sin(map(frames, 0, os.getResolution(), 0, TWO_PI) * 2) * 70 + parentDevice.deviceX-parentDevice.deviceWidth/2, cos(map(frames, 0, os.getResolution(), 0, TWO_PI)) * 70 + 100, 10, 10);
  }

  public void syncPlaylists() {
    if (oocsi.isConnected()) {
      for (int i = 0; i < parentDevice.myPlaylist.songs.length; i++) {
        String sharedSongID = sharedIDPlaylist[i].get();
        String localSongID = parentDevice.myPlaylist.songs[i].songID;
        println("Fetched sharedSongID " + sharedSongID + " at index " + i);
        println("Fetched localSongID " + localSongID + " at index " + i);

        if (!localSongID.equals(sharedSongID) && sharedSongID.equals("")) {
          //println("SharedPlaylist index " + i + " is unitialized - pushing id " + localSongID + " from local playlist");
          sharedIDPlaylist[i].set(localSongID);
        } else if (!localSongID.equals(sharedSongID)) {
          println("Updating SongID from shared playlist: " + sharedSongID + " at index " + i);
          parentDevice.myPlaylist.addSong(new Song(sharedSongID), i, false);
        }
      }
    }
  }
}