class Playlist {
  
  Song[] songs;
  int listLength = 11;
  MusicDevice parentDevice;
  long lastEdited; 

  Playlist(MusicDevice device) {

    songs = new Song[listLength];

    for (int i = 0; i < songs.length; i++) {
      songs[i] = new Song("0");
    }
    
    parentDevice = device;
  }
  
  Song getSong(int index) {
    return songs[index];
  }
  
  void addSong(Song song, int index, boolean shouldPush) {
    songs[index] = song;
    if(parentDevice.mySenderReceiver.oocsi.isConnected() && shouldPush){
      parentDevice.mySenderReceiver.addToPlaylist(song.songID, index);
    }
  }

  void removeSong(int index) {
    songs[index] = new Song("0");
    if(parentDevice.mySenderReceiver.oocsi.isConnected()){
      parentDevice.mySenderReceiver.addToPlaylist("0", index);
    }
  }

  void swapSong(int index1, int index2) {
    Song tempSong = songs[index1];
    songs[index1] = songs[index2];
    songs[index2] = tempSong;
  }
  
  void advance(){
    /*if (shouldPush){
      parentDevice.mySenderReceiver.sendAction("advance");
    }*/
    parentDevice.mySenderReceiver.advance();
    
    /*for(int i = 0; i < listLength-1; i++){
      songs[i] = songs[i+1];    
    } 
    songs[songs.length-1] = new Song("0");*/
  }
  
  /*void update(){
    for( int i = 0; i < parentDevice.mySenderReceiver.sharedIDPlaylist.length; i++ ) {
      parentDevice.mySenderReceiver.setSong(i);
    }
  }*/

  /*void merge(Playlist incomingPlaylist) {
    for (int i = 0; i < this.songs.length; i++) {
      if (incomingPlaylist.songs[i] != null) {
        this.songs[i] = incomingPlaylist.songs[i];
      }
    }
  }*/
}