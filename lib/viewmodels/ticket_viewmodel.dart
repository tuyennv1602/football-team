import 'package:flutter/material.dart';
import 'package:myfootball/models/responses/base_response.dart';
import 'package:myfootball/models/responses/ticket_resp.dart';
import 'package:myfootball/models/ticket.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class TicketViewModel extends BaseViewModel {
  Api _api;
  List<Ticket> tickets;

  TicketViewModel({@required Api api}) : _api = api;

  Future<TicketResponse> getTickets(int teamId) async {
    setBusy(true);
    var resp = await _api.getTickets(teamId);
    if (resp.isSuccess) {
      this.tickets = resp.tickets;
    }
    setBusy(false);
    return resp;
  }

  Future<void> cancelBooking(int index, int ticketId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.cancelBooking(ticketId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      this.tickets.removeAt(index);
      notifyListeners();
      UIHelper.showSimpleDialog('Đã huỷ thành công vé #$ticketId');
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }
}
