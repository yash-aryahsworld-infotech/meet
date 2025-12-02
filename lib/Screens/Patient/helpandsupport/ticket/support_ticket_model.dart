// support_ticket_model.dart
class SupportTicket {
  final String id;
  final String title;
  final String description;
  final String priority;
  final String status;
  final String createdDate;
  final String updatedDate;

  SupportTicket({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdDate,
    required this.updatedDate,
  });
}
