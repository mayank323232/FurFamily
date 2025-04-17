class AppointmentManager {
  static final List<Map<String, dynamic>> _appointments = [];

  static void addAppointment(Map<String, dynamic> appointment) {
    _appointments.add(appointment);
  }

  static List<Map<String, dynamic>> getAppointments() {
    return List.from(_appointments.reversed); // newest first
  }

  static void clearAppointments() {
    _appointments.clear();
  }
}
