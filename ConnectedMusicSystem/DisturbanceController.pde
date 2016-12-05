class DisturbanceController {

  int toleranceLevel = 10;
  MusicDevice parentDevice;
  
  //Set to 10 for testing purposes
  //int turnDownLevel = 10;
  int turnDownLevel;
  
  DisturbanceController(MusicDevice device) {
    parentDevice = device;  
  } 

  void setAmbientSound(float incomingLevel, String deviceID) {
    if (incomingLevel > toleranceLevel) {
      float relativeLevel = incomingLevel - toleranceLevel; 
      sendTurnDown(relativeLevel, deviceID);
    }
  }

  void setTolerance(int level) {
    toleranceLevel = level;
  }

  int getTolerance() {
    return toleranceLevel;
  }

  void sendTurnDown(float relativeLevel, String deviceID) {
    //send this to other device
  }
  
  void receiveTurnDown (int level) {
    turnDownLevel = level;
  }
}