import '../ticket.dart';
import 'base_response.dart';

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
