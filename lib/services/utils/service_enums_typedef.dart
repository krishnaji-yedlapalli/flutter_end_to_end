
enum DataErrorStateType {noInternet, timeoutException, serverNotFound, somethingWentWrong, fetchData, unauthorized, none, offlineError}

enum RequestType { get, put, post, delete, patch, store}

typedef DbInfo = ({String dbName, String queryFileName, int dbVersion});

typedef ErrorDetails = (DataErrorStateType, {String? message});
