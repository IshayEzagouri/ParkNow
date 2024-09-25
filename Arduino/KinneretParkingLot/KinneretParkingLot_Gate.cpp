#include "KinneretParkingLot_Gate.h"

Gate::Gate(const IPAddress& myIP) : MyLotNode(myIP) {}

void Gate::onMessageCallback(WebsocketsMessage message) {
	String msg = message.data();
	String log = "Message received: " + message.data();
	Serial.println(log);
	if (msg == "PREPARE_ANOTHER_SHOT") {
		this->flag_gateOpen = false;
		this->block_usonic = false;
	}
	if (msg == "OPEN_GATE") {
		this->flag_gateOpen = true;
		this->block_usonic = false;
	}
}

void Gate::readDistance(int myTrig, int myEcho) {
  uint16_t duration;

  // Trigger the HC-SR04 to send an ultrasonic pulse:
  digitalWrite(myTrig, LOW);
  delayMicroseconds(2);
  digitalWrite(myTrig, HIGH);
  delayMicroseconds(10);
  digitalWrite(myTrig, LOW);

  // Read the echo time:
  duration = pulseIn(myEcho, HIGH); //Returns the length of the pulse in microseconds or 0 if no complete pulse was received within the timeout

  // Calculate the distance in centimeters
  this->distance = duration * 0.034 / 2;	// Sound speed is about 34mps
  Serial.print("Distance: ");
  Serial.print(this->distance);
  Serial.println(" cm");
}

void Gate::checkDistance(String myString, int myThreshold, int myTrig, int myEcho) {  
	if (!this->block_usonic) {
		this->readDistance(myTrig, myEcho);
  
		if (this->distance > 0 && this->distance < myThreshold) {
			Serial.print("Object detected on ");
			Serial.println(myString);
			if (!this->flag_gateOpen) {
				wsClient.send("OBJECT_DETECTED");	// Trigger the camera
				this->block_usonic = true;	// Stop measuring proximity
			}
		}
		else if (this->distance == 0) {
			if (!this->flag_gateOpen) {
				wsClient.send("0_DISTANCE");
			}
		}
		else {	// No object detected by the sensor
			if (this->flag_gateOpen) {	// If Gate is open, close it:
				this->flag_gateOpen = false;
				this->flag_gateClose = true;
			}
		}
	}
	else Serial.println("Proximity measurement blocked");
}

