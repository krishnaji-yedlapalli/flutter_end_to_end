enum ScreenType {
  dashboard,
  routing,
  school,
  smartControl,
  smartControlMqtt,
  schoolMvc,
  automaticKeepAlive,
  localizationWithCalendar,
  isolates,
  shortcuts,
  plugins,
  scrollTypes,
  pushNotifications,
  deepLinking,
  gemini,
  dailyTracker
}

enum RouteType {
  shellRouting,
  stateFullShellRoutingWithIndexed,
  stateFullShellRoutingWithoutIndexed
}

enum IsolateType { isolateWithWithOutLag, isolateWithSpawn }

enum PluginType {
  youtube,
  localAuthentication,
  localNotifications,
  sharePlus,
  audioPlayer,
  networkInfo
}

typedef OfflineDumpingStatus = ({String title, int percentage})?;

enum SchoolDiscoverFeatureType {
  create,
  edit,
  delete,
  sync,
  dumpOfflineData,
  setDdConfig,
  resetDb
}

enum PartsOfDay { allDay, morning, afternoon, evening, night, customTime }

enum EventDayType {
  everyday,
  dayByDay,
  weekly,
  fortnight,
  quaterly,
  customDate,
  action
}

enum EventStatus { inProgress, pending, completed, skip }

enum EventActionType { edit, completed, skip, inProgress }
