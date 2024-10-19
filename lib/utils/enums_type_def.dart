
enum ScreenType {dashboard, routing, school, automaticKeepAlive, localizationWithCalendar, upiPayments, isolates, shortcuts, plugins, scrollTypes, pushNotifications, deepLinking, gemini, dailyTracker}

enum RouteType {shellRouting, stateFullShellRoutingWithIndexed, stateFullShellRoutingWithoutIndexed}

enum IsolateType {isolateWithWithOutLag, isolateWithSpawn}

enum OperatingSystemType {ios, android, androidFolded, windows, linux, macos, web}

enum DeviceResolutionType {mobile, tab, desktop}

enum ApplicationType {mobile, web, desktop}

enum PluginType {youtube, localAuthentication, localNotifications, sharePlus, audioPlayer, networkInfo }

typedef OfflineDumpingStatus = ({String title, int percentage})?;

enum SchoolDiscoverFeatureType {create, edit, delete, sync, dumpOfflineData, setDdConfig, resetDb}

enum PartsOfDay {allDay, morning, afternoon, evening, night, customTime}

enum EventDayType {everyday, dayByDay, weekly, fortnight, quaterly, customDate, action}

enum EventStatus {inProgress, pending, completed, skip}

enum EventActionType {edit, completed, skip, inProgress}

