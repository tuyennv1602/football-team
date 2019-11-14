import 'package:myfootball/models/responses/base_response.dart';
import 'package:myfootball/models/ticket.dart';

class TicketResponse extends BaseResponse {
  List<Ticket> tickets;

  TicketResponse.success(Map<String, dynamic> json) : super.success(json) {
    if (json['object'] != null) {
      tickets = new List<Ticket>();
      json['object'].forEach((v) {
        tickets.add(new Ticket.fromJson(v));
      });
    }
  }

  TicketResponse.error(String message) : super.error(message);
}
