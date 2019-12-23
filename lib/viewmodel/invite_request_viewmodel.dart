import 'package:flutter/material.dart';
import 'package:myfootball/model/invite_request.dart';
import 'package:myfootball/model/response/invite_request_resp.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class InviteRequestViewModel extends BaseViewModel {
  Api _api;

  List<InviteRequest> sentInvites = [];
  List<InviteRequest> receivedInvites = [];

  InviteRequestViewModel({@required Api api}) : _api = api;

  Future<InviteRequestResponse> getAllInvites(int teamId) async {
    setBusy(true);
    var resp = await _api.getInviteRequests(teamId);
    if (resp.isSuccess) {
      resp.requests.forEach((request) {
        if (request.getTypeRequest == 1) {
          sentInvites.add(request);
        } else {
          receivedInvites.add(request);
        }
      });
    }
    setBusy(false);
    return resp;
  }

  void removeRequest(int tab, int index) {
    if (tab == 0) {
      receivedInvites.removeAt(index);
    } else {
      sentInvites.removeAt(index);
    }
    notifyListeners();
  }

  void acceptRequest(int index) {
    receivedInvites[index].status = 2;
    notifyListeners();
  }
}
