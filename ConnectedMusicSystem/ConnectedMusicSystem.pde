import nl.tue.id.oocsi.*;

int numDevices = 3;
int padding = 500;
MusicDevice[] devices;

Song songs[];

void setup(){
  size(1900,600);
  devices = new MusicDevice[numDevices];
  
  for (int i = 0; i < numDevices; i++){
    devices[i] = new MusicDevice(width/6*2*i+100, height/5);  
  }
  
  songs = new Song[3];
  
  songs[0] = new Song("Toxic", 50, 50);
  songs[1] = new Song("No Colour", 150, 50);
  songs[2] = new Song("Grace", 250, 50);  
  
}

void draw(){
  background(150);

  for (int i = 0; i < numDevices; i++) {
    devices[i].update();
    devices[i].display();
  }
  
  for (Song song : songs) {
    song.display();
  }
  
}

void mouseReleased() {
  for (MusicDevice device : devices) {
    device.releaseEvent();
  }
  
  for (Song song : songs) {
    song.releaseEvent();
  }
}

void mouseClicked() {
  for (Song song : songs) {
    song.clickEvent();
  }
}