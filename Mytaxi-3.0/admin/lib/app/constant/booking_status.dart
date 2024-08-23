class BookingStatus {
  static const String bookingPlaced = "booking_placed";
  static const String bookingAccepted = "booking_accepted";
  static const String bookingOngoing = "booking_ongoing";
  static const String bookingCancelled = "booking_cancelled";
  static const String bookingCompleted = "booking_completed";

  static String getBookingStatusTitle(String status) {
    String bookingStatus = '';
    if (status == bookingPlaced) {
      bookingStatus = 'Placed';
    } else if (status == bookingAccepted) {
      bookingStatus = 'Accepted';
    } else if (status == bookingOngoing) {
      bookingStatus = 'Ongoing';
    } else if (status == bookingCancelled) {
      bookingStatus = 'Cancelled';
    } else if (status == bookingCompleted) {
      bookingStatus = 'Completed';
    }
    return bookingStatus;
  }
}
