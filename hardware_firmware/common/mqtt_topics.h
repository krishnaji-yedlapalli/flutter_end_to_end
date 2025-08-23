
#ifndef MQTT_TOPICS_H
#define MQTT_TOPICS_H

const char* deviceStatus = "/deviceConnectionStatus";
const char* reqDeviceStatus = "/reqConnectionStatus";
const char* controlDevice = "/control";
const char* status = "/status";
const char* updateAutoManualStatus = "/updateAutoManualStatus";
const char* controlAutoManualStatus = "/controlAutoManualStatus";
const char* updateSettings = "/updateSettings";
const char* updateTimeStatusToClient = "/updateTimeStatusToClient";

const char* onlineStatus = "online";
const char* offlineStatus = "offline";

#endif // MQTT_TOPICS_H
