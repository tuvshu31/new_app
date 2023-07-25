enum Method { get, post, put, delete }

enum NavType { none, category, store }

enum DialogType { success, warning, error }

enum DriverStatus {
  withoutOrder,
  incomingNewOrder,
  arrivedAtStore,
  receivedTheOrder,
  deliveredTheOrder,
  finishedTheOrder,
}
