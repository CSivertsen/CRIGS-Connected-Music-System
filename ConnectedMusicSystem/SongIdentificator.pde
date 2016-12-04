public static class SongIdentificator {
  
  static String[] IDs = {"01", "02", "03"};

  static String identifySong() {
    //Returns dummy song for testing purposes
    int randomChoice = round((float)Math.random()*2);
    println("Chosen ID: " + randomChoice);
    String identifiedID = IDs[randomChoice];
    return identifiedID;
  }
}