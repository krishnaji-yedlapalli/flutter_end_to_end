#ifndef MQTT_UTILITY_H
#define MQTT_UTILITY_H

#include <PubSubClient.h>

// Define the MQTT_CALLBACK_SIGNATURE if it's not already defined by PubSubClient.h
// This is typically defined in PubSubClient.h, but including it here ensures it's available.
#ifndef MQTT_CALLBACK_SIGNATURE
#define MQTT_CALLBACK_SIGNATURE std::function<void(char*, uint8_t*, unsigned int)>
#endif

void setup_mqtt(PubSubClient& client, MQTT_CALLBACK_SIGNATURE callback);
void reconnect(PubSubClient& client, const char* device_id);

#endif // MQTT_UTILITY_H
