class Playlist {

  Song[] songs;
  int listLength = 25;

  Playlist() {

    songs = new Song[listLength];

    for (int i = 0; i < songs.length; i++) {
      songs[i] = new Song("0");
    }
  }

  Song getSong(int index) {
    return songs[index];
  }

  void addSong(Song song, int index) {
    songs[index] = song;
  }

  void removeSong(int index) {
    songs[index] = new Song("0");
  }

  void swapSong(int index1, int index2) {
    Song tempSong = songs[index1];
    songs[index1] = songs[index2];
    songs[index2] = tempSong;
  }
  
  void advance(){
    for(int i = 0; i < listLength-1; i++){
      songs[i] = songs[i+1];    
    } 
    songs[songs.length-1] = new Song("0");
  }

  void merge(Playlist incomingPlaylist) {
    for (int i = 0; i < this.songs.length; i++) {
      if (incomingPlaylist.songs[i] != null) {
        this.songs[i] = incomingPlaylist.songs[i];
      }
    }
  }
}