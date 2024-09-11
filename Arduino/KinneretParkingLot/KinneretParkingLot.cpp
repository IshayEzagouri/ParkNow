#include "KinneretParkingLot.h"

MyLotNode::MyLotNode(const IPAddress& myIP) 
	: local_IP(myIP) {
		timer = millis();
		defineWSClient();
	}
    // Syntax memo:
	// the constructor accepts an IPAddress object by reference, which avoids copying the object. 
	// ': local_IP(myIP)' is a member initializer list, used to initialize member variables of a class before the constructor body runs


void MyLotNode::handle() { 
//void handle(unsigned long currTime, unsigned long startTime) { 
	wsClient.poll(); 
	// Perform rollcall:
	if (millis() - this->timer >= this->rollcallInterval) {
		this->rollcall();  
		this->timer = millis();
	}
}

void MyLotNode::networkSetup() {
	Serial.println("WIFI Setup started");

	// Configure static IP for the current Sensor Node:
	if (!WiFi.config(local_IP, this->gateway, this->subnet)) Serial.println("STA Failed to configure");

	wifiMulti.addAP(this->SSID, this->PSWD); // Preferred over 'WiFi.begin(this->SSID, this->PSWD)' due to support for using static IP 

	while(wifiMulti.run() != WL_CONNECTED) {
		Serial.println("Attempting to connect to network...");
		delay(100);
	}
	Serial.println("Connected to network");
	Serial.print("Local AP IP: ");
	Serial.println(WiFi.localIP());
}

void MyLotNode::connectToServer() {
	while(!wsClient.connect(this->websocket_server, this->websocket_port, "/")) {
		delay(100);
		Serial.println(this->websocket_port);
		Serial.println(this->websocket_server);
		Serial.println("Attempting to connect to websocket server ....");
	}
}

void MyLotNode::defineWSClient() {
	wsClient.onMessage([this](WebsocketsMessage message){
		this->onMessageCallback(message);
	});

	wsClient.onEvent([this](WebsocketsEvent event, String data) {
		if (event == WebsocketsEvent::ConnectionOpened) {
			Serial.print("Websocket server connected for client: ");
			Serial.println(this->local_IP);
		} else if (event == WebsocketsEvent::ConnectionClosed) {
			Serial.print("Websocket server disconnected for client: ");
			Serial.println(this->local_IP);
		} else if (event == WebsocketsEvent::GotPing) {
			Serial.println("Ping received");
		}
	});
}

void MyLotNode::onMessageCallback(WebsocketsMessage message){
	Serial.println("This is callback!!!!!!!!!!!!!!!!!!!!!!");
	String msg = message.data();
	String log = "Message received: " + message.data();
	Serial.println(log);
	if (msg == "TAKE_PICTURE") {
		this->takePicture = true;
	}
}

void MyLotNode::rollcall() {
	if(wsClient.available()) {
		String msg = this->local_IP.toString() + " ACTIVE"; 
		wsClient.send(msg);
	}
	else 
		this->connectToServer();
}

void MyLotNode::readDistance(int myTrig, int myEcho) {
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

void MyLotNode::sendDistance(String myString, int myThreshold, int myTrig, int myEcho) {  
  this->readDistance(myTrig, myEcho);
  
  String msg_event = "OBJECT_DETECTED";
  String msg_zero = myString + "_0_distance";
  if (this->distance > 0 && this->distance < myThreshold) {
    Serial.print("Object detected on ");
    Serial.println(myString);
    wsClient.send(msg_event);
  }
  else if (this->distance == 0) wsClient.send(msg_zero);
  //else wsClient.send("no_object");
}

void MyLotNode::sendPicture(const char* data, const size_t len) {
	wsClient.sendBinary(data, len);
	this->takePicture = false;
}


