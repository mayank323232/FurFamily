// appointment.dart
class Appointment {
  final String vetName;
  final String vetSpeciality;
  final DateTime date;
  final String slot;

  Appointment({
    required this.vetName,
    required this.vetSpeciality,
    required this.date,
    required this.slot,
  });
}

// Global appointment list (temporary, non-persistent)
List<Appointment> globalAppointments = [];
