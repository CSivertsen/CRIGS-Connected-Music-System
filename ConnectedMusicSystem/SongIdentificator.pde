public static class SongIdentificator {
  
  static String[] IDs = {"01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"};

  static String identifySong() {
    //Returns dummy song for testing purposes
    int randomChoice = round((float)Math.random()*19);
    println("Chosen ID: " + randomChoice);
    String identifiedID = IDs[randomChoice];
    return identifiedID;
  }
}