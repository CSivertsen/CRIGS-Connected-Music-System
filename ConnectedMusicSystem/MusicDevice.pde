class MusicDevice implements Connectable, Interactive {
  
  Player myPlayer;
  BackCatalogue myBackCatalogue;
  Playlist myPlaylist;
  ChannelChooser myChannelChooser;
  SenderReceiver mySenderReceiver;
  int deviceWidth = 300;
  int deviceHeight = 450;
  int deviceX;
  int deviceY;
  
  MusicDevice(int x, int y) {
      
     deviceX = x;
     deviceY = y;
      
     myPlayer = new Player(deviceX,deviceY,deviceWidth, deviceHeight);
     myBackCatalogue = new BackCatalogue(deviceX, deviceY, deviceWidth, deviceHeight);
     myPlaylist = new Playlist(deviceX, deviceY, deviceWidth, deviceHeight);
     myChannelChooser = new ChannelChooser(deviceX, deviceY, deviceWidth, deviceHeight);
     mySenderReceiver = new SenderReceiver(myChannelChooser); 
     
     myChannelChooser.setSenderReceiver(mySenderReceiver);
  }
  
  public void display() {
    
    noStroke();
    fill(255,255,255);
    rect(deviceX, deviceY, deviceWidth, deviceHeight);
    myPlayer.display();
    myBackCatalogue.display();
    myPlaylist.display();
    myChannelChooser.display();
  
  }
  
  public void update() {
    
    myPlayer.update();
    myPlaylist.update();
    myChannelChooser.update();
    
    
      
  }
  
  public void releaseEvent() {
    myPlayer.releaseEvent();
    myPlaylist.releaseEvent();
    myChannelChooser.releaseEvent();
    
  }

}