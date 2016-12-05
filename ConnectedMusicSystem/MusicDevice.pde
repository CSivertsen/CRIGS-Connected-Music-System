class MusicDevice implements Connectable, Interactive {

  PlayerInterface myPlayerInterface;
  PlaylistInterface myPlaylistInterface;
  ChannelChooser myChannelChooser;
  SenderReceiver mySenderReceiver;
  Playlist myPlaylist;
  DisturbanceController myDisturbanceController;
  DisturbanceGUI myDisturbanceGUI;
  
  int deviceWidth = 300;
  int deviceHeight = 450;
  int deviceX;
  int deviceY;

  MusicDevice(int x, int y) {

    deviceX = x;
    deviceY = y;

    myPlayerInterface = new PlayerInterface(deviceX, deviceY, deviceWidth, deviceHeight, this);
    myPlaylistInterface = new PlaylistInterface(deviceX, deviceY, deviceWidth, deviceHeight, this);
    myDisturbanceGUI = new DisturbanceGUI(deviceX, deviceY, deviceWidth, deviceHeight, this);
    
    myChannelChooser = new ChannelChooser(deviceX, deviceY, deviceWidth, deviceHeight);
    mySenderReceiver = new SenderReceiver(myChannelChooser); 
    myDisturbanceController = new DisturbanceController(this);

    myPlaylist = new Playlist();

    myChannelChooser.setSenderReceiver(mySenderReceiver);
  }

  public void display() {

    noStroke();
    fill(255, 255, 255);
    rect(deviceX, deviceY, deviceWidth, deviceHeight);
    myPlayerInterface.display();
    myPlaylistInterface.display();
    myChannelChooser.display();
    myDisturbanceGUI.display();
  }

  public void update() {
    myPlayerInterface.update();
    myPlaylistInterface.update();
    myChannelChooser.update();
    myDisturbanceGUI.update();
  }

  public void releaseEvent() {
    myPlayerInterface.releaseEvent();
    myPlaylistInterface.releaseEvent();
    myChannelChooser.releaseEvent();
  }
  
  public void clickEvent() {
    myPlaylistInterface.clickEvent();
    myPlayerInterface.clickEvent();
  }

  public void scrollEvent(float val) {
    myPlayerInterface.scrollEvent(val);
    myDisturbanceGUI.scrollEvent(val);
  }
}