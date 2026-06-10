import 'package:lncmis_mobile_app/models/referral_event_notification.dart';

class ReferralNotification {
  String id;
  String implementingPartner;
  String nameSpaceKey;
  String tei;
  List<ReferralEventNotification>? referrals;

  static const String implementingPartnerFormVariable = "y0bvausyTyh";
  static const String facility = "jOXN2iPhkxj";
  static const String communityCouncil = "ubB83OWNWsv";

  ReferralNotification({
    required this.id,
    required this.implementingPartner,
    required this.nameSpaceKey,
    required this.tei,
    this.referrals,
  }) {
    referrals = referrals ?? [];
  }

  factory ReferralNotification.fromJson(Map data) {
    String id = data["id"] ?? "";
    String implementingPartner = data["implementingPartner"] ?? "";
    String nameSpaceKey = data["nameSpaceKey"] ?? "";
    String tei = data["tei"] ?? "";
    List referrals = (data["referrals"] as List? ?? [])
        .map((dynamic json) => ReferralEventNotification.fromJson(json))
        .toList();
    return ReferralNotification(
      id: id,
      implementingPartner: implementingPartner,
      nameSpaceKey: nameSpaceKey,
      tei: tei,
      referrals: referrals as List<ReferralEventNotification>?,
    );
  }

  Map toOffline({bool shouldTransformBooleanValues = false}) {
    var data = <String, dynamic>{};
    data["id"] = id;
    data["implementingPartner"] = implementingPartner;
    data["nameSpaceKey"] = nameSpaceKey;
    data["tei"] = tei;
    data["referrals"] = referrals!
        .map((ReferralEventNotification referralEventNotification) =>
            referralEventNotification.toOffline(
              shouldTransformBooleanValues: shouldTransformBooleanValues,
            ))
        .toList();
    return data;
  }

  @override
  String toString() {
    return "<id: $id implementingPartner: $implementingPartner nameSpaceKey: $nameSpaceKey tei: $tei referrals: $referrals>";
  }
}
