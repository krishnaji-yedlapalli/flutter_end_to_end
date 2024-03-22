
enum DataErrorStateType {noInternet, timeoutException, serverNotFound, somethingWentWrong, fetchData, unauthorized, none}

enum RequestType { get, put, post, delete, patch, store}

typedef DbInfo = ({String dbName, String queryFileName, int dbVersion});
