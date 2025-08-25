class TicketModel {
  final String fromStation;
  final String toStation;
  final String journeyType;
  final int tickets;
  final String ticketNumber;
  final String validTill;
  final String qrData;

  TicketModel({
    required this.fromStation,
    required this.toStation,
    required this.journeyType,
    required this.tickets,
    required this.ticketNumber,
    required this.validTill,
    required this.qrData
  });
}
