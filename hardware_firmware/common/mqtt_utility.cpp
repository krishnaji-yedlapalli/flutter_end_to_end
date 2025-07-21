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

      // Updating the time status to client
      // This part might need to be moved back to the INO or handled differently if EEPROM is device specific
      // int readValue = -1;
      // EEPROM.get(0, readValue);
      // if (readValue != -1) {
      //   String updateTimeStatusTopic = String(device_id) + updateTimeStatusToClient;
      //   client.publish(updateTimeStatusTopic.c_str(), String(readValue).c_str(), true);
      // }

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
