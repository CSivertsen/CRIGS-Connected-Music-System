
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
#define ANTENNAPIN 41

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

int delayVal = 50; // delay

int readCycle = 0;
int turnDown = 0;

String artist = "Rick James";
String title = "Superfreak";

int channelID = 0;
int countChannels = 0;

void setup() {

  analogReadResolution(8);
  Serial.begin(9600);

  pixels.begin();

  display.begin(SSD1306_SWITCHCAPVCC);
  display.display();
  delay(2000);
  display.clearDisplay();
  //myservo.attach(2);

  for (int i = 0; i < NUMSLOTS; i++) {
    pinMode(slotPins[i], INPUT_PULLUP);
  }
  pinMode(ANTENNAPIN, INPUT_PULLUP);

  for (int i = 0; i < NUMPIXELS; i++) {
    pixels.setPixelColor(i, pixels.Color(30, 30, 30));
  }
  pixels.show();

  establishContact();  // send a byte to establish contact until receiver responds

}

void loop() {

  channelSelection();
  //servoControl();
  checkSwitches();
  drawScreen();
}

void checkSwitches() {

  for (int i = 0; i < 1; i++) {
    slotsAreOpen[i] = digitalRead(i + 22);
  }

}

void drawScreen(void) {

  display.setTextSize(1.5);
  display.setTextColor(WHITE);
  display.setCursor(0, 0);
  display.clearDisplay();
  display.println(title);
  display.println(artist);
  //For debugging
  if (!slotsAreOpen[0]) {
    display.println("Slot 1 is closed");
  } else {
    display.println("Slot 1 is open");  
  }
  display.display();
}

void channelSelection() {

  if (digitalRead(ANTENNAPIN) == HIGH) {
    countChannels = 0;
    for (int i = 0; i < NUMPIXELS; i++) {
      //screenDebug("AntennaPin high", 200);

      if (!ledsIsOn[i]) {
        pixels.setPixelColor(i, pixels.Color(0, 0, 0));
      } else {
        countChannels++;
      }
    }
   channelID = countChannels;
  } else {
 
    for (int i = 0; i < NUMPIXELS; i++) {
      LDRvalues[i] = analogRead(LDRpins[i]);
      if (LDRvalues[i] < lightThreshold && !ledsIsOn[i] && !isRegistered[i] ) {
        pixels.setPixelColor(i, pixels.Color(50, 0, 0));
        ledsIsOn[i] = true;
        isRegistered[i] = true;
        //Serial.print("Led ");
        //Serial.print(i);
        //Serial.println(" turned on");
      } else if (LDRvalues[i] < lightThreshold && ledsIsOn[i] && !isRegistered[i] ) {
        pixels.setPixelColor(i, pixels.Color(30, 30, 30));
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
  }

  pixels.show(); // This sends the updated pixel color to the hardware.
}

void sendData() {

  // read first analog input, divide by 4 to make the range 0-255:
  volumeLevel = analogRead(A0) / 4;
  delay(10);
  toleranceLevel = analogRead(A1) / 4;

  //for debugging
  volumeLevel = 100;
  toleranceLevel = 100;

  for (int i = 0; i < NUMSLOTS; i++) {
    String str = String(slotsAreOpen[i]);
    Serial.print(str);
    Serial.print('\n');
  }
  Serial.print(channelID);
  Serial.print('\n');
  Serial.print(volumeLevel);
  Serial.print('\n');
  Serial.print(toleranceLevel);
  Serial.print('\n');
  Serial.print("S");
  Serial.print('\n');

}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.print("A\n");
    delay(300);
  }
}

void serialEvent() {
  if (Serial.available()) {

    // get the new byte:
    String inString = (String)Serial.readStringUntil('\n');

    //screenDebug(inString, 200);
    if (inString == "A") {
      //screenDebug("Sending data", 200);
      readCycle = -1;
      sendData();
    } else {
      if (readCycle == 0) {
        //screenDebug("Settting Artist", 200);
        artist = inString;
      } else if ( readCycle == 1 ) {
        ///screenDebug("Settting Title" + inputString, 200);
        title = inString;
      } else if ( readCycle == 2 ) {
        turnDown = inString.toInt();
      }
    }

    readCycle++;
  }
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


