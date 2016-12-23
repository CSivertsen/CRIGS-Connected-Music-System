import ddf.minim.*;
import nl.tue.id.oocsi.*;
import nl.tue.id.oocsi.client.behavior.*;
import processing.serial.*;

int numVirtualDevices = 2;
int padding = 700;
float x;
float y;

MusicDevice[] devices;
//Move minim til MusicDevice;
Minim minim;
Serial serial;
PImage logo;
PFont heading; 

long lastClick; 

void setup(){
  fullScreen(2);
  float x = width*0.1;
  float y = height*0.4;
  
  heading = createFont("Montserrat", 80);
  
  logo = loadImage("CRIGSlogo.png");

  devices = new MusicDevice[numVirtualDevices+1];
  
  //Initiating first device with serialInterface
  devices[0] = new MusicDevice(x, y, true);
  
  //Initiating virtual devices
  for (int i = 1; i < devices.length; i++){
    devices[i] = new MusicDevice(width/6*2*i+x, y, false);  
  }
 
    minim = new Minim(this); //<>//
    
    String portName = Serial.list()[0];
    serial = new Serial(this, portName, 9600);
         
}

void draw(){
  background(247, 243, 243);
  
  image(logo, width*0.05, height*0.05);
  textSize(80);
  textFont(heading);
  fill(0);
  text("Music System", x + width*0.4, y + height*0.1); 

  for (int i = 0; i < devices.length; i++) {
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

void serialEvent(Serial event){
  devices[0].mySerialInterface.serialEvent(event);
}

/*
void handleOOCSIEvent(OOCSIEvent message){
    for (MusicDevice device : devices) {
    device.mySenderReceiver.handleOOCSIEvent(message);
  }
  
  println("oocsi event in root");
}*/