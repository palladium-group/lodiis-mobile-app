
class ImplementingPartnerReferralService {
  String? id;
  String? services;

  ImplementingPartnerReferralService({this.id, this.services});

  @override
  String toString() {
    return 'logs <$services>';
  }


  ImplementingPartnerReferralService.fromOffline(
      Map<String, dynamic> offlineData) {
    id = offlineData['id'];
    services = offlineData['services'];
  }
}
