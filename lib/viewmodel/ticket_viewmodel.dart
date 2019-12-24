import 'package:flutter/material.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/model/response/ticket_resp.dart';
import 'package:myfootball/model/ticket.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class TicketViewModel extends BaseViewModel {
  Api _api;
  List<Ticket> tickets;

  TicketViewModel({@required Api api}) : _api = api;

  Future<TicketResponse> getTickets(int teamId) async {
    setBusy(true);
    var resp = await _api.getTicket(teamId);
    if (resp.isSuccess) {
      this.tickets = resp.tickets;
    }
    setBusy(false);
    return resp;
  }

  Future<BaseResponse> cancelBooking(int index, int ticketId) async {
    var resp = await _api.cancelBooking(ticketId);
    if (resp.isSuccess) {
      this.tickets.removeAt(index);
      notifyListeners();
    }
    return resp;
  }
}
