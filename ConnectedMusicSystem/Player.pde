class Player{
  
  Minim minim;
  Song currentSong;
  
  Player(){
  
  minim = new Minim(this); 
}
  
  void playSong(){
    currentSong.play();
  }
  
  void stopPlaying(){}

}