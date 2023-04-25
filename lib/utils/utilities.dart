class Utilities {
  static bool shouldOrder() {
    final year = DateTime.now().year;
    final month = DateTime.now().month;
    final day = DateTime.now().day;
    final period1Start = DateTime(year, month, day, 8);
    final period1End = DateTime(year, month, day, 10);
    final period2Start = DateTime(year, month, day, 12);
    final period2End = DateTime(year, month, day, 14);
    final period3Start = DateTime(year, month, day, 16);
    final period3End = DateTime(year, month, day, 18);

    if (DateTime.now().isAfter(period1Start) &&
        DateTime.now().isBefore(period1End)) {
      return true;
    } else if (DateTime.now().isAfter(period2Start) &&
        DateTime.now().isBefore(period2End)) {
      return true;
    } else if (DateTime.now().isAfter(period3Start) &&
        DateTime.now().isBefore(period3End)) {
      return true;
    }
    return false;
  }

  static String orderAt() {
    final year = DateTime.now().year;
    final month = DateTime.now().month;
    final day = DateTime.now().day;
    final period1Start = DateTime(year, month, day, 8);
    final period1End = DateTime(year, month, day, 10);
    final period2Start = DateTime(year, month, day, 12);
    final period2End = DateTime(year, month, day, 14);
    final period3Start = DateTime(year, month, day, 16);

    if (DateTime.now().isAfter(period2End) &&
        DateTime.now().isBefore(period3Start)) {
      return "Order between 4pm and 6pm";
    } else if (DateTime.now().isAfter(period1End) &&
        DateTime.now().isBefore(period2Start)) {
      return "Order between 12pm and 2pm";
    } else if (DateTime.now().isBefore(period1Start)) {
      return "Order between 8am and 10am";
    }
    return 'Order tomorrow between 8am and 10am';
  }

  static bool timeToDispatch(DateTime orderTime) {
    final year = DateTime.now().year;
    final month = DateTime.now().month;
    final day = DateTime.now().day;

    final period1End = DateTime(year, month, day, 10);

    final period2End = DateTime(year, month, day, 14);

    final period3End = DateTime(year, month, day, 18);
    final deliveryPeriod1 = DateTime(year, month, day, 12);
    final deliveryPeriod2 = DateTime(year, month, day, 16);
    final deliveryPeriod3 = DateTime(year, month, day, 20);
    DateTime deliveryPeriod = DateTime.now();

    if (orderTime.isBefore(period1End)) {
      deliveryPeriod = deliveryPeriod1;
    } else if (orderTime.isBefore(period2End)) {
      deliveryPeriod = deliveryPeriod2;
    } else if (orderTime.isBefore(period3End)) {
      deliveryPeriod = deliveryPeriod3;
    }

    if (DateTime.now().isAfter(deliveryPeriod)) {
      return true;
    }
    return false;
  }
}
