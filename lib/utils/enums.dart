enum Method { get, post, put, delete }

enum NavType { none, category, store }

enum ActionType { success, warning, error }

enum DriverStatus {
  withoutOrder,
  incoming,
  arrived,
  received,
  delivered,
  finished,
}

enum OrderStatus {
  newOrder,
  preparing,
  waitingForDriver,
  delivering,
  delivered,
}
