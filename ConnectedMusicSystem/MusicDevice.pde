class MusicDevice implements Connectable, Interactive {

  PlayerInterface myPlayerInterface;
  BackCatalogue myBackCatalogue;
  PlaylistInterface myPlaylistInterface;
  ChannelChooser myChannelChooser;
  SenderReceiver mySenderReceiver;
  Playlist myPlaylist;
  DisturbanceController myDisturbanceController;
  int deviceWidth = 300;
  int deviceHeight = 450;
  int deviceX;
  int deviceY;

  MusicDevice(int x, int y) {

    deviceX = x;
    deviceY = y;

    myPlayerInterface = new PlayerInterface(deviceX, deviceY, deviceWidth, deviceHeight, this);
    myBackCatalogue = new BackCatalogue(deviceX, deviceY, deviceWidth, deviceHeight);
    myPlaylistInterface = new PlaylistInterface(deviceX, deviceY, deviceWidth, deviceHeight, this);
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
    myBackCatalogue.display();
    myPlaylistInterface.display();
    myChannelChooser.display();
  }

  public void update() {
    myPlayerInterface.update();
    myPlaylistInterface.update();
    myChannelChooser.update();
  }

  public void releaseEvent() {
    myPlayerInterface.releaseEvent();
    myPlaylistInterface.releaseEvent();
    myChannelChooser.releaseEvent();
  }

  public void scrollEvent(float val) {
    myPlayerInterface.scrollEvent(val);
  }
}