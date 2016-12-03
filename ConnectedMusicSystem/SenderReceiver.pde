class SenderReceiver {
  
  OOCSI oocsi;
  int numID;
  String fullID;
  String channelName;
  String channelPrefix = "CMSChannel";

  SenderReceiver(ChannelChooser channelChooser) {
    
    numID = int(random(0,999999));
    fullID = "CMS" + numID;
    oocsi = new OOCSI(this, fullID, "13.94.200.130");
    
    channelName = channelPrefix + channelChooser.getChannel();
    oocsi.subscribe(channelName);
  }
  
  void resubscribe(int channelID) {
    channelName = channelPrefix + channelID;
    oocsi.subscribe(channelName);
  }
  
  void handleOOCSIEvent(OOCSIEvent message) {
    // print out all values in message
    println(message.keys());
}
  
}