import ddf.minim.*;
import nl.tue.id.oocsi.*;

int numDevices = 3;
int padding = 500;
MusicDevice[] devices;
Minim minim;

long lastClick; 

//SongInterface SongInterfaces[];

void setup(){
  size(1900,600);
  devices = new MusicDevice[numDevices];
  
  for (int i = 0; i < numDevices; i++){
    devices[i] = new MusicDevice(width/6*2*i+100, height/5);  
  }
  
  /*SongInterfaces = new SongInterface[3];
  
  SongInterfaces[0] = new SongInterface("Toxic", 50, 50);
  SongInterfaces[1] = new SongInterface("No Colour", 150, 50);
  SongInterfaces[2] = new SongInterface("Grace", 250, 50);*/  
  
   minim = new Minim(this);
  
}

void draw(){
  background(150);

  for (int i = 0; i < numDevices; i++) {
    devices[i].update();
    devices[i].display();
  }
  
  /*for (SongInterface SongInterface : SongInterfaces) {
    SongInterface.display();
  }*/
  
}

void mouseReleased() {
  for (MusicDevice device : devices) {
    device.releaseEvent();
  }
  
  /*for (SongInterface SongInterface : SongInterfaces) {
    SongInterface.releaseEvent();
  }*/
}

void mouseClicked() {
  /*for (SongInterface SongInterface : SongInterfaces) {
    SongInterface.clickEvent();
  }*/
  lastClick = millis();
  
}