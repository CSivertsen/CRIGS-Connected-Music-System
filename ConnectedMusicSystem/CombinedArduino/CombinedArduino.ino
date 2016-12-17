
#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <Adafruit_NeoPixel.h>
//#include <Servo.h>
#ifdef __AVR__
#include <avr/power.h>
#endif

#define PIXELPIN 3

// If using software SPI (the default case):
#define OLED_MOSI   9
#define OLED_CLK   10
#define OLED_DC    11
#define OLED_CS    12
#define OLED_RESET 13
Adafruit_SSD1306 display(OLED_MOSI, OLED_CLK, OLED_DC, OLED_RESET, OLED_CS);

#if (SSD1306_LCDHEIGHT != 64)
#error("Height incorrect, please fix Adafruit_SSD1306.h!");
#endif

// How many NeoPixels are attached to the Arduino?
#define NUMPIXELS 4

//How many slots are there
#define NUMSLOTS 7

//Servo myservo;
//int servoPos = 0;

Adafruit_NeoPixel pixels = Adafruit_NeoPixel(NUMPIXELS, PIXELPIN, NEO_GRB + NEO_KHZ800);

int LDRpins[] = {A0, A1, A2, A3};
int LDRvalues[4];
int lightThreshold = 100;
boolean ledsIsOn[4];
boolean isRegistered[4];

int volumeLevel = 0;
int toleranceLevel = 0;


boolean slotsAreOpen[NUMSLOTS];
int slotPins[] = {22, 23, 24, 25, 26, 27, 28};

int inByte = 0;         // incoming serial byte

int delayVal = 50; // delay

String inputString = "";
boolean stringComplete = false;
int readCycle = 0;
int turnDown = 0;

String artist = "Rick James";
String title = "Superfreak";


void setup() {

  analogReadResolution(8);
  Serial.begin(9600);

  pixels.begin();
  pixels.show(); // Initialize all pixels to 'off'

  display.begin(SSD1306_SWITCHCAPVCC);
  display.display();
  delay(2000);
  display.clearDisplay();
  //myservo.attach(2);

  for (int i = 0; i < NUMSLOTS; i++) {
    pinMode(slotPins[i], INPUT_PULLUP);
  }

  inputString.reserve(100);

  establishContact();  // send a byte to establish contact until receiver responds

}

void loop() {

  channelSelection();
  //servoControl();
  checkSwitches();
  drawScreen();

  delay(delayVal); // Delay for a period of time (in milliseconds).

}

void checkSwitches() {

  for (int i = 0; i < 1; i++) {
    slotsAreOpen[i] = digitalRead(i + 22);
    //Serial.print(slotPins[i]);
    //Serial.print(" ");
    //Serial.println(slotsAreOpen[i]);
  }

}

void drawScreen(void) {

  //Serial.println("Starting screen");

  display.setTextSize(2);
  display.setTextColor(WHITE);
  display.setCursor(0, 0);
  display.clearDisplay();
  if (!slotsAreOpen[0]) {
    display.println("Slot 1 is open");
    display.println("lol");
  }
  else {
    display.println(artist);
    display.println(title);
  }
  display.display();
  //Serial.println("Ending screen");
}

//void servoControl() {
//
//  Serial.println("Starting servo");
//
//  for (servoPos = 0; servoPos <= 180; servoPos += 1) { // goes from 0 degrees to 180 degrees
//    // in steps of 1 degree
//    myservo.write(servoPos);              // tell servo to go to position in variable 'pos'
//    delay(15);                       // waits 15ms for the servo to reach the position
//  }
//  for (servoPos = 180; servoPos >= 0; servoPos -= 1) { // goes from 180 degrees to 0 degrees
//    myservo.write(servoPos);              // tell servo to go to position in variable 'pos'
//    delay(15);                       // waits 15ms for the servo to reach the position
//  }
//
//  Serial.println("Ending servo");
//
//}

void channelSelection() {

  //Serial.println("Starting channel selection");

  for (int i = 0; i < 4; i++) {
    LDRvalues[i] = analogRead(LDRpins[i]);

    if (LDRvalues[i] < lightThreshold && !ledsIsOn[i] && !isRegistered[i] ) {
      pixels.setPixelColor(i, pixels.Color(0, 50, 0));
      ledsIsOn[i] = true;
      isRegistered[i] = true;
      //Serial.print("Led ");
      //Serial.print(i);
      //Serial.println(" turned on");
    } else if (LDRvalues[i] < lightThreshold && ledsIsOn[i] && !isRegistered[i] ) {
      pixels.setPixelColor(i, pixels.Color(0, 0, 50));
      ledsIsOn[i] = false;
      isRegistered[i] = true;
      //Serial.print("Led ");
      //Serial.print(i);
      //Serial.println(" turned off");
    }

    if (isRegistered[i] && LDRvalues[i] > lightThreshold) {
      isRegistered[i] = false;
    }

  }

  //For debugging
  /*for (int i = 0; i < 9; i++) {
    Serial.print("Sensor ");
    Serial.print(i);
    Serial.print(" = ");
    Serial.println(LDRvalues[i]);
    }*/

  pixels.show(); // This sends the updated pixel color to the hardware.

  //Serial.println("Ending channel selection");
}

void sendData() {
  int channelID = 0;

  // if we get a valid byte
  //screenDebug(String(Serial.available()));
  if (Serial.available() > 0 ) {

    // read first analog input, divide by 4 to make the range 0-255:
    volumeLevel = analogRead(A0) / 4;
    delay(10);
    toleranceLevel = analogRead(A1) / 4;

    //Check how many leds are on
    for (int i = 0; i < 4; i++) {
      if (ledsIsOn[i]) {
        channelID++;
      }
    }

    //for debugging
    volumeLevel = 100;
    toleranceLevel = 100;

    for (int i = 0; i < NUMSLOTS; i++) {
      Serial.write(slotsAreOpen[i]);
    }
    Serial.print('\n');
    Serial.print(channelID);
    Serial.print('\n');
    Serial.print(volumeLevel);
    Serial.print('\n');
    Serial.print(toleranceLevel);
    Serial.print('\n');
    Serial.print("S");
    Serial.print('\n');

    //screenDebug("Sending via serial");

  }

  /*if (stringComplete) {
    // clear the string:
    if (readCycle == 0) {
      artist = inputString;
    } else if ( readCycle == 1 ) {
      title = inputString;
    } else if ( readCycle == 2 ) {
      turnDown = inputString.toInt();
    }
    inputString = "";
    readCycle++;
    stringComplete = false;
    }*/


}

void screenDebug(String debugMessage, int delayVal) {
  display.setTextSize(2);
  display.setTextColor(WHITE);
  display.setCursor(0, 0);
  display.clearDisplay();
  display.println(debugMessage);
  display.display();
  delay(delayVal);

}


void establishContact() {
  while (Serial.available() <= 0) {
    Serial.print("A\n");
    delay(300);
  }
}

void serialEvent() {
  if (Serial.available()) {

    sendData();
    // get the new byte:
    String inString = (String)Serial.readStringUntil('\n');

    if (inString == "A") {
      readCycle = 0;
    } else {
      if (readCycle == 0) {
        artist = inputString;
      } else if ( readCycle == 1 ) {
        title = inputString;
      } else if ( readCycle == 2 ) {
        turnDown = inputString.toInt();
      }
    }

    screenDebug(inString, 200);

    readCycle++;

  }
}

