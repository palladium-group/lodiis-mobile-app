import 'package:flutter/foundation.dart';
import 'package:kb_mobile_app/core/constants/user_account_reference.dart';
import 'package:kb_mobile_app/core/services/organisation_unit_service.dart';
import 'package:kb_mobile_app/core/services/user_service.dart';
import 'package:kb_mobile_app/models/current_user.dart';
import 'package:kb_mobile_app/models/organisation_unit.dart';

class CurrentUserState with ChangeNotifier {
  // initial state
  CurrentUser? _currentUser;
  String? _currentUserLocations;
  String? _implementingPartner;
  List<String?>? _currentUserCountryLevelReferences;
  bool? _canCurrentUserDoDataEntry;
  bool? _canManageDreams;
  bool? _canManageEducation;
  bool? _canManagePpPrev;
  bool? _canManageOGAC;
  bool? _canManageOvc;
  bool? _canManageNoneAgyw;
  bool? _canManageReferral;
  bool? _canManageCLOReferral;
  bool? _canManageHtsShortForm;
  bool? _canManageHtsLongForm;
  bool? _canManageHivReg;
  bool? _canManageSrh;
  bool? _canManagePrepLongForm;
  bool? _canManagePrepShortForm;
  bool? _canManageMSGHIV;
  bool? _canManageArtRefill;
  bool? _canManageAnc;
  bool? _canManageCondom;
  bool? _canManageContraceptives;
  bool? _canManagePOSTGBV;
  bool? _canManagePEP;
  bool? _canManageServiceForm;
  bool? _canManagePOSTGBVLegal;
  bool? _canManageParenting;
  bool? _canManageHIVPreventionEducation;
  bool? _canManageViolencePreventionEducation;

  // selectors

  String get implementingPartner => _implementingPartner ?? '';
  CurrentUser? get currentUser => _currentUser;
  bool get canCurrentUserDoDataEntry =>
      _canCurrentUserDoDataEntry == null ? true : _canCurrentUserDoDataEntry!;
  bool get isKbFacilitySocialWorker =>
      implementingPartner == UserAccountReference.kbFacilitySocialWorker;
  String get currentUserLocations => _currentUserLocations ?? '';
  List<String?> get currentUserCountryLevelReferences =>
      _currentUserCountryLevelReferences ?? [];
  bool get canManageDreams => _canManageDreams ?? false;
  bool get canManageEducation => _canManageEducation ?? false;
  bool get canManagePpPrev => _canManagePpPrev ?? false;
  bool get canManageOGAC => _canManageOGAC ?? false;
  bool get canManageOvc => _canManageOvc ?? false;
  bool get canManageNoneAgyw => _canManageNoneAgyw ?? false;
  bool get canManageReferral => _canManageReferral ?? false;
  bool get canManageCLOReferral => _canManageCLOReferral ?? false;
  bool get canManageHtsShortForm => _canManageHtsShortForm ?? false;
  bool get canManageHtsLongForm => _canManageHtsLongForm ?? false;
  bool get canManageHivReg => _canManageHivReg ?? false;
  bool get canManageSrh => _canManageSrh ?? false;
  bool get canManagePrepLongForm => _canManagePrepLongForm ?? false;
  bool get canManagePrepShortForm => _canManagePrepShortForm ?? false;
  bool get canManageAnc => _canManageAnc ?? false;
  bool get canManageArtRefill => _canManageArtRefill ?? false;
  bool get canManageMSGHIV => _canManageMSGHIV ?? false;
  bool get canManageCondom => _canManageCondom ?? false;
  bool get canManageContraceptives => _canManageContraceptives ?? false;
  bool get canManagePOSTGBV => _canManagePOSTGBV ?? false;
  bool get canManagePOSTGBVLegal => _canManagePOSTGBVLegal ?? false;
  bool get canManagePEP => _canManagePEP ?? false;
  bool get canManageServiceForm => _canManageServiceForm ?? false;
  bool get canManageManageParenting => _canManageParenting ?? false;
  bool get canManageHIVPreventionEducation =>
      _canManageHIVPreventionEducation ?? false;
  bool get canManageViolencePreventionEducation =>
      _canManageViolencePreventionEducation ?? false;

  void updateUserAccessStatus(
    String? implementingPartner,
    dynamic userAccessConfigurations,
  ) {
    var userAccesses = userAccessConfigurations[implementingPartner] ?? {};
    try {
      _canManageDreams = userAccesses.containsKey('canManageDreams') &&
          userAccesses['canManageDreams'] == true;
      _canManageEducation = userAccesses.containsKey('canManageEducation') &&
          userAccesses['canManageEducation'] == true;
      _canManagePpPrev = userAccesses.containsKey('canManagePpPrev') &&
          userAccesses['canManagePpPrev'] == true;
      _canManageOGAC = userAccesses.containsKey('canManageOGAC') &&
          userAccesses['canManageOGAC'] == true;
      _canManageOvc = userAccesses.containsKey('canManageOvc') &&
          userAccesses['canManageOvc'] == true;
      _canManageNoneAgyw = userAccesses.containsKey('canManageNoneAgyw') &&
          userAccesses['canManageNoneAgyw'] == true;
      _canManageReferral = userAccesses.containsKey('canManageReferral') &&
          userAccesses['canManageReferral'] == true;
      _canManageCLOReferral =
          userAccesses.containsKey('canManageCLOReferral') &&
              userAccesses['canManageCLOReferral'] == true;
      _canManageHtsShortForm =
          userAccesses.containsKey('canManageHtsShortForm') &&
              userAccesses['canManageHtsShortForm'] == true;
      _canManageHtsLongForm =
          userAccesses.containsKey('canManageHtsLongForm') &&
              userAccesses['canManageHtsLongForm'] == true;
      _canManageHivReg = userAccesses.containsKey('canManageHivReg') &&
          userAccesses['canManageHivReg'] == true;
      _canManageSrh = userAccesses.containsKey('canManageSrh') &&
          userAccesses['canManageSrh'] == true;
      _canManagePrepLongForm =
          userAccesses.containsKey('canManagePrepLongForm') &&
              userAccesses['canManagePrepLongForm'] == true;
      _canManagePrepShortForm =
          userAccesses.containsKey('canManagePrepShortForm') &&
              userAccesses['canManagePrepShortForm'] == true;
      _canManagePEP = userAccesses.containsKey('canManagePEP') &&
          userAccesses['canManagePEP'] == true;
      _canManageCondom = userAccesses.containsKey('canManageCondom') &&
          userAccesses['canManageCondom'] == true;
      _canManageContraceptives =
          userAccesses.containsKey('canManageContraceptives') &&
              userAccesses['canManageContraceptives'] == true;
      _canManageMSGHIV = userAccesses.containsKey('canManageMSGHIV') &&
          userAccesses['canManageMSGHIV'] == true;
      _canManageArtRefill = userAccesses.containsKey('canManageArtRefill') &&
          userAccesses['canManageArtRefill'] == true;
      _canManageAnc = userAccesses.containsKey('canManageAnc') &&
          userAccesses['canManageAnc'] == true;
      _canManageServiceForm =
          userAccesses.containsKey('canManageServiceForm') &&
              userAccesses['canManageServiceForm'] == true;
      _canManagePOSTGBV = userAccesses.containsKey('canManagePOSTGBV') &&
          userAccesses['canManagePOSTGBV'] == true;
      _canManagePOSTGBVLegal =
          userAccesses.containsKey('canManagePOSTGBVLegal') &&
              userAccesses['canManagePOSTGBVLegal'] == true;
      _canManageParenting = userAccesses.containsKey('canManageParenting') &&
          userAccesses['canManageParenting'] == true;
      _canManageHIVPreventionEducation =
          userAccesses.containsKey('canManageHIVPreventionEducation') &&
              userAccesses['canManageHIVPreventionEducation'] == true;
      _canManageViolencePreventionEducation =
          userAccesses.containsKey('canManageViolencePreventionEducation') &&
              userAccesses['canManageViolencePreventionEducation'] == true;
    } catch (error) {
      //
    }
    notifyListeners();
  }

  //reducers
  void setCurrentUser(
    CurrentUser user,
    dynamic userAccessConfigurations,
  ) {
    _currentUser = user;
    String? implementingPartner = user.implementingPartner;
    _implementingPartner = implementingPartner;
    updateUserAccessStatus(
      implementingPartner,
      userAccessConfigurations,
    );
    setCurrentUserLocation();
  }

  void setCurrentUserCountryLevelReferences() async {
    int level = 1;
    List<OrganisationUnit> organisationUnits =
        await OrganisationUnitService().getOrganisationUnitsByLevel(level);
    _currentUserCountryLevelReferences = organisationUnits
        .map((OrganisationUnit organisationUnit) => organisationUnit.id)
        .toList()
        .toSet()
        .toList();
    notifyListeners();
  }

  void setCurrentUserLocation() async {
    String locations = '';
    if (_currentUser != null && _currentUser!.userOrgUnitIds != null) {
      List<OrganisationUnit> organisationUnits = await OrganisationUnitService()
          .getOrganisationUnits(_currentUser!.userOrgUnitIds!);
      locations = organisationUnits
          .map((OrganisationUnit organisationUnit) =>
              organisationUnit.name ?? '')
          .toList()
          .join(', ');
    }
    _currentUserLocations = locations;
    notifyListeners();
  }

  Future getAndSetCurrentUserDataEntryAuthorityStatus() async {
    if (_currentUser != null) {
      bool status =
          await UserService().getCurrentUserDataEntryAuthorityStatus();
      bool canCurrentUserDoDataEntry = status &&
          !UserAccountReference.superUserIpNames
              .contains(_currentUser?.implementingPartner);
      await UserService()
          .setDataEntryAuthorityStatus(canCurrentUserDoDataEntry);
      _canCurrentUserDoDataEntry = canCurrentUserDoDataEntry;
      notifyListeners();
    }
  }
}
