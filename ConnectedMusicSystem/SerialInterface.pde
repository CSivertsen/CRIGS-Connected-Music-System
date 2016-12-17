class SerialInterface {

  int readCycle = 0;      
  boolean firstContact = false;   
  int[] serialInArray = new int[10];
  long[] lastOpen = new long[10];
  boolean[] wasOpen = new boolean[10];

  int oldChannelID;
  int oldVolumeLevel;
  int oldToleranceLevel;
  int inChannelID;
  int inVolumeLevel;
  int inToleranceLevel;

  boolean arduinoReady;

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

    // read a byte from the serial port:
    String inString = myPort.readStringUntil('\n');
    if (inString != null) {
      //println(inString);
      inString = trim(inString);
      // if this is the first byte received, and it's an A,
      // clear the serial buffer and note that you've
      // had first contact from the microcontroller. 
      // Otherwise, add the incoming byte to the array:
      if (firstContact == false) {
        if (inString.equals("A")) { 
          myPort.clear();          // clear the serial port buffer
          firstContact = true;     // you've had first contact from the microcontroller
          myPort.write("A");       // ask for more
          println("Had first contact");
          readCycle = -1;
        }
      } else if (inString.equals("S")) { 
        println("Sending");
        myPort.write(parentDevice.myPlayer.currentSong.getArtist() + '\n');
        myPort.write(parentDevice.myPlayer.currentSong.getTitle() + '\n');
        myPort.write(parentDevice.myDisturbanceController.turnDownLevel + '\n');
        //myPort.write("Artist" + '\n');
        //myPort.write("Title" + '\n');
        //myPort.write("0" + '\n');   
        //Send a capital A to request new sensor readings:
        myPort.write("A" + '\n');
        readCycle = -1;
      } else {

        if (inString.equals("BEGIN")) {
          readCycle = 0;
        }

        if (readCycle < 7) {
          boolean bool = Boolean.parseBoolean(inString);
          if (bool) {
            if (wasOpen[readCycle] == false) {
              lastOpen[readCycle] = millis();
              wasOpen[readCycle] = true;
            }
          } else {
            if (wasOpen[readCycle] == true) {
              if (millis() - lastOpen[readCycle] > 1500) {
                parentDevice.myPlaylist.addSong(new Song(SongIdentificator.identifySong()), readCycle, true);
              } else {
                parentDevice.myPlaylist.addSong(new Song("0"), readCycle, true);
              }
            }
          }
        } else if (readCycle == 7) {
          inChannelID = Integer.parseInt(inString);
        } else if (readCycle == 8) {
          inVolumeLevel = Integer.parseInt(inString);
        } else if (readCycle == 9) {
          inToleranceLevel = Integer.parseInt(inString);
        }

        if (oldChannelID != inChannelID) {
          println("Channel ID was changed");
          parentDevice.mySenderReceiver.resubscribe(inChannelID);
        }

        if (oldVolumeLevel != inVolumeLevel) {
          float gain = map(inVolumeLevel, 0, 255, -80, 20);
          parentDevice.myPlayer.setGain(gain);
          //Set volume to new level
        }

        if (oldToleranceLevel != inToleranceLevel) {
          int tolerance = int(map(inToleranceLevel, 0, 255, 0, 100));
          parentDevice.myDisturbanceController.setTolerance(tolerance);
          //Set tolerance to new level
        }

        oldChannelID = inChannelID;
        oldVolumeLevel = inVolumeLevel;
        oldToleranceLevel = inToleranceLevel;
      }
      // print the values (for debugging purposes only):
      println(readCycle + ": " + inString);
      if (readCycle >= 9) {
        readCycle = 0;
      } else {
        readCycle++;
      }
    }
  }
}