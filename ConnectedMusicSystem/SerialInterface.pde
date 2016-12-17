class SerialInterface {

  int readCycle = 0;      
  boolean firstContact = false;   
  int[] serialInArray = new int[10];
  long[] lastOpen = new long[10];
  boolean[] wasOpen = new boolean[10];

  int oldChannelID;
  int oldVolumeLevel;
  int oldToleranceLevel;

  MusicDevice parentDevice;

  SerialInterface(MusicDevice device) {
    parentDevice = device;
  }

  void update() {
    write();
  }

  void write() {
    boolean isDisturbing;

    if (parentDevice.myDisturbanceController.turnDownLevel > 0) {
      isDisturbing = true;
    } else {
      isDisturbing = false;
    }

    char[] artist = parentDevice.myPlayer.currentSong.getArtist().toCharArray();
    char[] title = parentDevice.myPlayer.currentSong.getTitle().toCharArray();

    for (int i = 0; i < artist.length; i++) {
      serial.write(artist[i]);
    }

    for (int i = 0; i < title.length; i++) {
      serial.write(title[i]);
    }

    serial.write(parseByte(isDisturbing));
  }

  void serialEvent(Serial myPort) {
    if (myPort.available() > 0) {
      // read a byte from the serial port:
      String inString = myPort.readStringUntil(10);
      println(inString);
      // if this is the first byte received, and it's an A,
      // clear the serial buffer and note that you've
      // had first contact from the microcontroller. 
      // Otherwise, add the incoming byte to the array:
      if (firstContact == false) {
        if (inString == "A") { 
          myPort.clear();          // clear the serial port buffer
          firstContact = true;     // you've had first contact from the microcontroller
          myPort.write('A');       // ask for more
          println("Had first contact");
        }
      } else if (inString == "S") { 

        //myPort.write(parentDevice.myPlayer.currentSong.getArtist() + '\n');
        //myPort.write(parentDevice.myPlayer.currentSong.getTitle() + '\n');
        //myPort.write(parentDevice.myDisturbanceController.turnDownLevel + '\n');
        myPort.write("Artist" + '\n');
        myPort.write("Title" + '\n');
        myPort.write("0" + '\n');   
        //Send a capital A to request new sensor readings:
        myPort.write("A" + '\n');
      } else {
        /*
      // Add the latest byte from the serial port to array:
         
         if (readCycle == 0) {
         Integer.parseInt(inString);
         }
         
         // If we have 10 bytes:
         if (serialCount > 2 ) {
         for (int i = 0; i < 7; i++) {
         if (serialInArray[i] == 1) {
         if (wasOpen[i] == false) {
         lastOpen[i] = millis();
         wasOpen[i] = true;
         }
         } else if (serialInArray[i] == 0) {
         if (wasOpen[i] == true) {
         if (millis() - lastOpen[i] > 1500) {
         //Add song via songIdentificator
         } else {
         //Add song zero
         }
         }
         }
         
         int channelID = serialInArray[7];
         int volumeLevel = serialInArray[8];
         int toleranceLevel = serialInArray[9];
         
         if (oldChannelID != channelID) {
         parentDevice.mySenderReceiver.resubscribe(channelID);
         }
         
         if (oldVolumeLevel != volumeLevel) {
         float gain = map(volumeLevel, 0, 255, -80, 20);
         parentDevice.myPlayer.setGain(gain);
         //Set volume to new level
         }
         
         if (oldToleranceLevel != toleranceLevel) {
         int tolerance = int(map(toleranceLevel, 0, 255, 0, 100));
         parentDevice.myDisturbanceController.setTolerance(tolerance);
         //Set tolerance to new level
         }
         
         oldChannelID = channelID;
         oldVolumeLevel = volumeLevel;
         oldToleranceLevel = toleranceLevel;
         }
         */

        // print the values (for debugging purposes only):


        //readCycle++;
      }
    }
  }
}