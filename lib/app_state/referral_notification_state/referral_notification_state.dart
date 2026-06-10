import 'package:flutter/foundation.dart';
import 'package:lncmis_mobile_app/core/offline_db/event_offline/event_offline_provider.dart';
import 'package:lncmis_mobile_app/core/offline_db/tracked_entity_instance_offline/tracked_entity_instance_offline_provider.dart';
import 'package:lncmis_mobile_app/core/services/referral_notification_service.dart';
import 'package:lncmis_mobile_app/models/referral_event_notification.dart';
import 'package:lncmis_mobile_app/models/referral_notification.dart';

class ReferralNotificationState with ChangeNotifier {
  // initial state
  String? _currentImplementingPartner;
  List<String>? _beneficiariesWithIncomingReferrals;
  List<String>? _incomingReferrals;
  List<ReferralEventNotification>? _incomingResolvedReferrals;
  String? _incomingReferralToResolveIndicator;
  String? _incomingReferralsResolvedIndicator;

  // Selectors
  String get currentImplementingPartner => _currentImplementingPartner ?? "";
  List<String> get beneficiariesWithIncomingReferrals =>
      _beneficiariesWithIncomingReferrals ?? [];
  List<String>? get incomingReferrals => _incomingReferrals ?? [];
  List<ReferralEventNotification> get incomingResolvedReferrals =>
      _incomingResolvedReferrals ?? [];
  String get incomingReferralsResolvedIndicator =>
      _incomingReferralsResolvedIndicator ?? "";
  String get incomingReferralToResolveIndicator =>
      _incomingReferralToResolveIndicator ?? "";
  List<String> get teiWithIncomingResolvedReferrals =>
      _incomingResolvedReferrals!
          .map((referral) => referral.tei)
          .toList()
          .toSet()
          .toList();

  // reducer for the state
  Future<void> setCurrentImplementingPartner(String implementingPartner) async {
    _currentImplementingPartner = implementingPartner.split("/").join("-");
    notifyListeners();
    await reloadReferralNotifications();
  }

  Future<void> reloadReferralNotifications() async {
    _beneficiariesWithIncomingReferrals = [];
    _incomingReferrals = [];
    _incomingResolvedReferrals = [];
    int incomingReferralToResolveCount = 0;
    int incomingReferralsResolvedCount = 0;
    List<String?> offlineEventIds =
        await EventOfflineProvider().getAllOfflineEventIds();
    List<String?> offlineTrackedEntityInstanceIds =
        await TrackedEntityInstanceOfflineProvider()
            .getAllOfflineTrackedEntitiyInstanceIds();
    List<ReferralNotification> allReferralNofications =
        await ReferralNotificationService()
            .getReferralNotificationFromOffline();
    for (ReferralNotification referralNotification in allReferralNofications) {
      if (offlineTrackedEntityInstanceIds.isNotEmpty &&
          offlineTrackedEntityInstanceIds.contains(referralNotification.tei)) {
        if (referralNotification.implementingPartner ==
            _currentImplementingPartner) {
          List<ReferralEventNotification> referrals = referralNotification
              .referrals!
              .where((ReferralEventNotification referral) =>
                  !referral.isCompleted!)
              .toList();
          if (referrals.isNotEmpty) {
            List<String> filteredReferralIds = referrals
                .map((ReferralEventNotification referral) => referral.id)
                .toList()
                .where((String id) => offlineEventIds.contains(id))
                .toList();
            if (filteredReferralIds.isNotEmpty) {
              _beneficiariesWithIncomingReferrals!
                  .add(referralNotification.tei);
              _incomingReferrals!.addAll(filteredReferralIds);
            }
          }
        } else {
          _incomingResolvedReferrals!.addAll(referralNotification.referrals!
              .where((ReferralEventNotification referral) =>
                  referral.isCompleted! &&
                  !referral.isViewed! &&
                  referral.fromImplementingPartner ==
                      _currentImplementingPartner &&
                  offlineEventIds.contains(referral.id))
              .toList());
        }
      }
    }
    _beneficiariesWithIncomingReferrals =
        _beneficiariesWithIncomingReferrals!.toSet().toList();
    _incomingReferrals = _incomingReferrals!.toSet().toList();
    incomingReferralsResolvedCount = _incomingResolvedReferrals!.length;
    incomingReferralToResolveCount = _incomingReferrals!.length;

    _incomingReferralsResolvedIndicator = incomingReferralsResolvedCount == 0
        ? ""
        : incomingReferralsResolvedCount > 9
            ? "9+"
            : "$incomingReferralsResolvedCount";
    _incomingReferralToResolveIndicator = incomingReferralToResolveCount == 0
        ? ""
        : incomingReferralToResolveCount > 9
            ? "9+"
            : "$incomingReferralToResolveCount";
    notifyListeners();
  }

  Future<void> updateReferralNotificationEvent(
    String? referralEventId,
    String? tei,
    bool isCompleted,
    bool isViewed,
  ) async {
    await ReferralNotificationService().updateReferralNotificationEvent(
      referralEventId,
      tei,
      isCompleted,
      isViewed,
    );
    reloadReferralNotifications();
  }
}
