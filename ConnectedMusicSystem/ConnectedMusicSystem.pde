import ddf.minim.*;
import nl.tue.id.oocsi.*;
import nl.tue.id.oocsi.client.behavior.*;

int numDevices = 1;
int padding = 500;
MusicDevice[] devices;
//Move minim til MusicDevice;
Minim minim;

long lastClick; 

void setup(){
  size(1900,600);
  devices = new MusicDevice[numDevices];
  
  for (int i = 0; i < numDevices; i++){
    devices[i] = new MusicDevice(width/6*2*i+100, height/5);  
  }
 
   minim = new Minim(this);
     
}

void draw(){
  background(150);

  for (int i = 0; i < numDevices; i++) {
    devices[i].update(); //<>//
    devices[i].display();
  }
  
}

void mouseReleased() {
  for (MusicDevice device : devices) {
    device.releaseEvent();
  }
}

void mousePressed() {
  lastClick = millis();
  for (MusicDevice device : devices) {
    device.clickEvent();
  }
}

void mouseWheel(MouseEvent event) {
  float val = event.getCount();
  for (MusicDevice device : devices) {
    device.scrollEvent(val);
  }  
}