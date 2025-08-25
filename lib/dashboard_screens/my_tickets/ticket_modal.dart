class TicketModel {
  final String fromStation;
  final String toStation;
  final String journeyType;
  final int tickets;
  final String ticketNumber;
  final String validTill;
  final String qrData;
  bool isUsed=false;

  TicketModel({
    required this.fromStation,
    required this.toStation,
    required this.journeyType,
    required this.tickets,
    required this.ticketNumber,
    required this.validTill,
    required this.qrData,
    this.isUsed=false
  });
  Map<String,dynamic>toMap(){
    return{
      'fromStation':fromStation,
      'toStation':toStation,
      'journeyType':journeyType,
      'tickets':tickets,
      'ticketNumber':ticketNumber,
      'validTill':validTill,
      'qrdata':qrData,
      'isUsed':isUsed ? 1:0,
    };
  }
  factory TicketModel.fromMap(Map<String,dynamic> map){
    return TicketModel(
     fromStation: map['fromStation'],
      toStation: map['toStation'],
      journeyType: map['journeyType'],
      tickets: map['tickets'],
      ticketNumber: map['ticketNumber'],
      validTill:map['validTill'],
      qrData: map['qrData'],
      isUsed: map['isUsed']==1,
    );
  }


}
