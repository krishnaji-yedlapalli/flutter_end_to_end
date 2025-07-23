#include "mqtt_utility.h"
#include "arduino_config.h"
#include "mqtt_topics.h"

void setup_mqtt(PubSubClient& client, MQTT_CALLBACK_SIGNATURE callback) {
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);
}

void reconnect(PubSubClient& client, const char* device_id) {
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    String willTopic = String(device_id) + deviceStatus;
    if (client.connect(device_id, NULL, NULL, willTopic.c_str(), 0, true, offlineStatus)) {
      Serial.println("connected");

      String deviceStatusTopic = String(device_id) + deviceStatus;
      client.publish(deviceStatusTopic.c_str(), onlineStatus, true);

      

      // Subscribe to control topic
      client.subscribe((String(device_id) + controlDevice).c_str());
      client.subscribe((String(device_id) + reqDeviceStatus).c_str());
      client.subscribe((String(device_id) + controlAutoManualStatus).c_str());
      client.subscribe((String(device_id) + updateSettings).c_str());
