import 'package:flutter/material.dart';
import 'package:myfootball/models/invite_request.dart';
import 'package:myfootball/models/responses/invite_request_resp.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class InviteRequestViewModel extends BaseViewModel {
  Api _api;

  List<InviteRequest> inviteRequests;

  InviteRequestViewModel({@required Api api}) : _api = api;

  Future<InviteRequestResponse> getAllInvites(int teamId) async {
    setBusy(true);
    var resp = await _api.getInviteRequestsByTeam(teamId);
    if (resp.isSuccess) {
      this.inviteRequests = resp.requests;
    }
    setBusy(false);
    return resp;
  }
}
