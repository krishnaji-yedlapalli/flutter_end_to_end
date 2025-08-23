#include <ArduinoJson.h>
#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <EEPROM.h>

// Wi-Fi and MQTT Broker Settings
const char* ssid = "Airtel_medi_0191";
const char* password = "air86395";
// const char* ssid = "KRISHNAJI";
// const char* password = "9949210191";

const char* deviceStatus = "/deviceConnectionStatus";
const char* reqDeviceStatus = "/reqConnectionStatus";
const char* controlDevice = "/control";
const char* status = "/status";
const char* updateAutoManualStatus = "/updateAutoManualStatus";
const char* controlAutoManualStatus = "/controlAutoManualStatus";
const char* updateSettings = "/updateSettings";
const char* updateTimeStatusToClient = "/updateTimeStatusToClient";

bool isAuto = true;


const char* onlineStatus = "online";
const char* offlineStatus = "offline";

unsigned long timerStart = 0;
bool timerRunning = false;
unsigned long timerDuration = 2 * 60 * 1000;


const char* mqtt_server = "192.168.1.19";  // e.g., "192.168.1.100"
// const char* mqtt_user = "username"; // Optional
// const char* mqtt_password = "password"; // Optional
const char* device_id = "node1";  // Unique ID for each NodeMCU

// Pin Definitions
#define RELAY_PIN D1  // Relay pin for light
#define PIR_PIN D5    // PIR sensor pin

WiFiClient espClient;
PubSubClient client(espClient);
unsigned long lastMsg = 0;

void setup() {
  Serial.begin(115200);
  EEPROM.begin(512);  // size in bytes
  pinMode(RELAY_PIN, OUTPUT);
  pinMode(PIR_PIN, INPUT);
  digitalWrite(RELAY_PIN, LOW);  // Light off initially

  // Connect to Wi-Fi
  setup_wifi();

  // Set MQTT server and callback
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);
}

void setup_wifi() {
  delay(10);
  Serial.println("Connecting to WiFi...");
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("WiFi connected");
}

void callback(char* topic, byte* payload, unsigned int length) {
  String message;
  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  Serial.println(message);

  // Control relay based on topic and message
  String controlTopic = String(device_id) + controlDevice;
  if (String(topic) == controlTopic) {
    if (message == "ON") {
      digitalWrite(RELAY_PIN, HIGH);
      client.publish((String(device_id) + status).c_str(), "ON", true);
    } else if (message == "OFF") {
      digitalWrite(RELAY_PIN, LOW);
      client.publish((String(device_id) + status).c_str(), "OFF", true);
    }
  }

  String controlTopicDeviceStatus = String(device_id) + reqDeviceStatus;
  if (String(topic) == controlTopicDeviceStatus) {
    String deviceStatusTopic = String(device_id) + deviceStatus;
    client.publish(deviceStatusTopic.c_str(), onlineStatus, true);
  }


  String controlTopicAutoManualStatus = String(device_id) + controlAutoManualStatus;
  if (String(topic) == controlTopicAutoManualStatus) {
    if (message == "AUTO") {
      isAuto = true;
      /// Disable Error
      stopTimer();
    } else {
      isAuto = false;
      startOrResetTimer();  /// Start timer
    }
    updateAutoManualStatusToClient();
  }

  /// Update Settings
  String controlSettings = String(device_id) + updateSettings;
  if (String(topic) == controlSettings) {

    // Allocate JSON document
    StaticJsonDocument<200> doc;

    // Parse JSON
    DeserializationError error = deserializeJson(doc, message);
    if (error) {
      Serial.print("JSON parsing failed: ");
      Serial.println(error.c_str());
      return;
    }

    // Extract values
    int time = doc["time"];  // 1200
    timerDuration = time;

    /// Stroign the value
    EEPROM.put(0, timerDuration);
    EEPROM.commit();
    Serial.print("Time arrived " + time);

    // String deviceStatusTopic = String(device_id) + deviceStatus;
    // client.publish(deviceStatusTopic.c_str(), onlineStatus, true);
  }
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    String willTopic = String(device_id) + deviceStatus;
    if (client.connect(device_id, NULL, NULL, willTopic.c_str(), 0, true, offlineStatus)) {
      Serial.println("connected");

      String deviceStatusTopic = String(device_id) + deviceStatus;
      client.publish(deviceStatusTopic.c_str(), onlineStatus, true);

      /// Updating the time status to client
      int readValue = -1;
      EEPROM.get(0, readValue);
      if (readValue != -1) {
        String updateTimeStatusTopic = String(device_id) + updateTimeStatusToClient;
        client.publish(updateTimeStatusTopic.c_str(), String(readValue).c_str(), true);
      }

      // Subscribe to control topic
      client.subscribe((String(device_id) + controlDevice).c_str());
      client.subscribe((String(device_id) + reqDeviceStatus).c_str());
      client.subscribe((String(device_id) + controlAutoManualStatus).c_str());
      client.subscribe((String(device_id) + updateSettings).c_str());

    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      delay(5000);
    }
  }
}

void loop() {
  checkTimer();
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  // Publish PIR sensor data every 5 seconds
  unsigned long now = millis();

  if (isAuto && now - lastMsg > 5000) {
    Serial.println("is Auto : " + isAuto ? "true" : "false");
    lastMsg = now;
    int pirState = digitalRead(PIR_PIN);

    if (pirState) {
      digitalWrite(RELAY_PIN, HIGH);
      client.publish((String(device_id) + status).c_str(), "ON", true);
    } else {
      digitalWrite(RELAY_PIN, LOW);
      client.publish((String(device_id) + status).c_str(), "OFF", true);
    }

    Serial.println("PIR Motion: " + pirState ? "Detected" : "No motions");
  }
}

void startOrResetTimer() {
  timerStart = millis();
  timerRunning = true;
  Serial.println("Timer started/reset.");
}

void checkTimer() {
  if (timerRunning && millis() - timerStart >= timerDuration) {
    timerRunning = false;
    isAuto = true;
    updateAutoManualStatusToClient();
    Serial.println("20 minutes passed!");
    // Add your action here, e.g., turn off a relay
  }
}

void stopTimer() {
  isAuto = true;
  updateAutoManualStatusToClient();
  timerRunning = false;
  Serial.println("Timer stopped.");
}

void updateAutoManualStatusToClient() {
  String updateAutoManualStatusTopic = String(device_id) + updateAutoManualStatus;
  client.publish(updateAutoManualStatusTopic.c_str(), isAuto ? "AUTO" : "MANUAL", true);
}