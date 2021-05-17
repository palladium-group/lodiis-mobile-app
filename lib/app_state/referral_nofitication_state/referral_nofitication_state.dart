import 'package:flutter/foundation.dart';
import 'package:kb_mobile_app/core/services/referral_notification_service.dart';
import 'package:kb_mobile_app/models/referralEventNotification.dart';
import 'package:kb_mobile_app/models/referralNotification.dart';

class ReferralNotificationState with ChangeNotifier {
  // initial state
  String _currentImplementingPartner;
  List<String> _beneficiariesWithIncomingReferrals;
  List<String> _incommingReferrals;

  // Selectors
  String get currentImplementingPartner => _currentImplementingPartner ?? "";
  List<String> get beneficiariesWithIncomingReferrals =>
      _beneficiariesWithIncomingReferrals ?? [];
  List<String> get incomingReferrals => _incommingReferrals ?? [];

  // reducer for the state
  setCurrentImplementingPartner(String implementingPartner) {
    print("implementingPartner $implementingPartner");
    _currentImplementingPartner = implementingPartner;
    notifyListeners();
    print("implementingPartner $implementingPartner");
  }

  reloadReferralNotifications() async {
    _beneficiariesWithIncomingReferrals = [];
    _incommingReferrals = [];
    List<ReferralNotification> referralNofications =
        await ReferralNotificationService()
            .getReferralNotificationFromOffline();
    for (ReferralNotification referralNotification in referralNofications) {
      List<ReferralEventNotification> referrals = referralNotification.referrals
          .where((ReferralEventNotification referral) => !referral.isCompleted)
          .toList();
      if (referrals.length > 0) {
        _beneficiariesWithIncomingReferrals.add(referralNotification.tei);
        _incommingReferrals.addAll(referrals
            .map((ReferralEventNotification referral) => referral.id ?? "")
            .toList());
      }
    }
    notifyListeners();
  }

  updateReferralNotificaionEvent(String referralEventId, String tei) async {
    await ReferralNotificationService()
        .updateReferralNotificaionEvent(referralEventId, tei);
  }
}
