class MusicDevice implements Interactive {

  VolumeGUI myVolumeGUI;
  PlayerInterface myPlayerInterface;
  PlaylistInterface myPlaylistInterface;
  ChannelChooser myChannelChooser;
  SenderReceiver mySenderReceiver;
  Playlist myPlaylist;
  Player myPlayer;
  DisturbanceController myDisturbanceController;
  DisturbanceGUI myDisturbanceGUI;
  SerialInterface mySerialInterface;

  float deviceWidth = 300;
  float deviceHeight = 450;
  float deviceX;
  float deviceY;
  String deviceLoc;

  boolean hasPhysical;

  MusicDevice(float x, float y, boolean hasPhysical, String location) {
    
    deviceLoc = location;
    deviceX = x;
    deviceY = y;

    myPlayerInterface = new PlayerInterface(deviceX, deviceY, deviceWidth, deviceHeight, this);
    myPlaylistInterface = new PlaylistInterface(deviceX, deviceY, deviceWidth, deviceHeight, this);
    myDisturbanceGUI = new DisturbanceGUI(deviceX, deviceY, deviceWidth, deviceHeight, this);
    myVolumeGUI = new VolumeGUI(deviceX, deviceY, deviceWidth, deviceHeight, this);

    myPlaylist = new Playlist(this);
    myPlayer = new Player(this);
    myChannelChooser = new ChannelChooser(deviceX, deviceY, deviceWidth, deviceHeight);
    mySenderReceiver = new SenderReceiver(myChannelChooser, this); 
    myDisturbanceController = new DisturbanceController(this);

    myChannelChooser.setSenderReceiver(mySenderReceiver);

    if (hasPhysical) {
      mySerialInterface = new SerialInterface(this);
    }
  }

  public void display() {

    noStroke();
    fill(255, 255, 255);
    rect(deviceX, deviceY, deviceWidth, deviceHeight);
    myPlayerInterface.display();
    myPlaylistInterface.display();
    myChannelChooser.display();
    myDisturbanceGUI.display();
    myVolumeGUI.display();
    
    fill(0);
    textSize(22);
    text(deviceLoc, deviceX, deviceY-(deviceY*0.1)); 

  }

  public void update() {
    myPlayerInterface.update();
    myPlaylistInterface.update();
    myVolumeGUI.update();
    myChannelChooser.update();
    myDisturbanceGUI.update();
    mySenderReceiver.update();
    myPlayer.update();
    if (hasPhysical) {
      mySerialInterface.update();
    }
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
    myVolumeGUI.scrollEvent(val);
  }
}