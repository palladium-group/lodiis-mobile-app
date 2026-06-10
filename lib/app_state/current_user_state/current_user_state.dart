import 'package:flutter/foundation.dart';
import 'package:kb_mobile_app/core/constants/user_account_reference.dart';
import 'package:kb_mobile_app/core/services/organisation_unit_service.dart';
import 'package:kb_mobile_app/core/services/user_access.dart';
import 'package:kb_mobile_app/core/services/user_service.dart';
import 'package:kb_mobile_app/models/current_user.dart';
import 'package:kb_mobile_app/models/organisation_unit.dart';

class CurrentUserState with ChangeNotifier {
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

  bool? _canManageMgysd;

  /// Example MGYSD permission map loaded from:
  /// api/dataStore/lodiis-mgysd-config/mobile-config
  ///
  /// Example keys:
  /// reportCase, viewReportedCases, createCase
  Map<String, bool> _mgysdPermissions = <String, bool>{};

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

  /// Module-level access.
  ///
  /// This controls whether the MGYSD module appears.
  bool get canManageMgysd => _canManageMgysd ?? false;

  /// Example role permissions.
  ///
  /// These are controlled by the `permissions` object in
  /// `lodiis-mgysd-config/mobile-config`.
  bool get canMgysdReportCase =>
      canManageMgysd && (_mgysdPermissions['reportCase'] ?? false);

  bool get canMgysdViewReportedCases =>
      canManageMgysd && (_mgysdPermissions['viewReportedCases'] ?? false);

  bool get canMgysdCreateCase =>
      canManageMgysd && (_mgysdPermissions['createCase'] ?? false);

  List<String> _normaliseList(dynamic value) {
    if (value == null) return <String>[];

    if (value is List) {
      return value
          .map((e) => e.toString().trim().toLowerCase())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return value
        .toString()
        .split(',')
        .map((e) => e.trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  bool _matchesAny(List<String> userValues, List<String> requiredValues) {
    if (requiredValues.isEmpty) return true;

    return requiredValues.any((requiredValue) {
      return userValues.any((userValue) {
        return userValue == requiredValue ||
            userValue.contains(requiredValue) ||
            requiredValue.contains(userValue);
      });
    });
  }

  bool _matchesAll(List<String> userValues, List<String> requiredValues) {
    if (requiredValues.isEmpty) return true;

    return requiredValues.every((requiredValue) {
      return userValues.any((userValue) {
        return userValue == requiredValue ||
            userValue.contains(requiredValue) ||
            requiredValue.contains(userValue);
      });
    });
  }

  bool _evaluateMgysdAccessFromConfig(dynamic mgysdConfig) {
    try {
      if (mgysdConfig == null) return false;

      final enabled = mgysdConfig['enabled'] == true;
      if (!enabled) return false;

      final accessControl = mgysdConfig['accessControl'] ?? <String, dynamic>{};

      final requiredGroups =
      _normaliseList(accessControl['requiredUserGroups']);
      final requiredRoles = _normaliseList(accessControl['requiredRoles']);

      final mode =
      (accessControl['mode'] ?? 'ANY').toString().trim().toUpperCase();

      final userGroups = _normaliseList(_currentUser?.userGroups);
      final userRoles = _normaliseList(_currentUser?.userRoles);

      final hasGroupAccess = mode == 'ALL'
          ? _matchesAll(userGroups, requiredGroups)
          : _matchesAny(userGroups, requiredGroups);

      final hasRoleAccess = mode == 'ALL'
          ? _matchesAll(userRoles, requiredRoles)
          : _matchesAny(userRoles, requiredRoles);

      if (requiredGroups.isEmpty && requiredRoles.isEmpty) return false;

      if (requiredGroups.isNotEmpty && requiredRoles.isEmpty) {
        return hasGroupAccess;
      }

      if (requiredGroups.isEmpty && requiredRoles.isNotEmpty) {
        return hasRoleAccess;
      }

      if (mode == 'ALL') {
        return hasGroupAccess && hasRoleAccess;
      }

      return hasGroupAccess || hasRoleAccess;
    } catch (e) {
      return false;
    }
  }

  String? _resolveMgysdRoleKey(dynamic mgysdConfig) {
    try {
      if (mgysdConfig == null || _currentUser == null) return null;

      final roleMappings = mgysdConfig['roleMappings'] ?? <String, dynamic>{};
      if (roleMappings is! Map) return null;

      final userRoles = _normaliseList(_currentUser?.userRoles);

      for (final entry in roleMappings.entries) {
        final dhis2RoleName = entry.key.toString().trim().toLowerCase();
        final roleKey = entry.value.toString().trim();

        if (dhis2RoleName.isEmpty || roleKey.isEmpty) continue;

        final matched = userRoles.any((userRole) {
          return userRole == dhis2RoleName ||
              userRole.contains(dhis2RoleName) ||
              dhis2RoleName.contains(userRole);
        });

        if (matched) return roleKey;
      }
    } catch (e) {
      //
    }

    return null;
  }

  Map<String, bool> _permissionsForRole(
      dynamic mgysdConfig,
      String? roleKey,
      ) {
    final emptyPermissions = <String, bool>{
      'reportCase': false,
      'viewReportedCases': false,
      'createCase': false,
    };

    try {
      if (mgysdConfig == null || roleKey == null || roleKey.trim().isEmpty) {
        return emptyPermissions;
      }

      final permissions = mgysdConfig['permissions'] ?? <String, dynamic>{};
      if (permissions is! Map) return emptyPermissions;

      final rolePermissions = permissions[roleKey] ?? <String, dynamic>{};
      if (rolePermissions is! Map) return emptyPermissions;

      bool readBool(String key) {
        return rolePermissions.containsKey(key) && rolePermissions[key] == true;
      }

      return <String, bool>{
        'reportCase': readBool('reportCase'),
        'viewReportedCases': readBool('viewReportedCases'),
        'createCase': readBool('createCase'),
      };
    } catch (e) {
      return emptyPermissions;
    }
  }

  Future<void> updateMgysdAccessStatusFromSavedConfig() async {
    try {
      final mgysdConfig = await UserAccess().getSavedMgysdMobileConfig();

      final hasModuleAccess = _evaluateMgysdAccessFromConfig(mgysdConfig);
      final roleKey = _resolveMgysdRoleKey(mgysdConfig);
      final rolePermissions = _permissionsForRole(mgysdConfig, roleKey);

      _canManageMgysd = hasModuleAccess;
      _mgysdPermissions = hasModuleAccess
          ? rolePermissions
          : <String, bool>{
        'reportCase': false,
        'viewReportedCases': false,
        'createCase': false,
      };

      notifyListeners();
    } catch (e) {
      _canManageMgysd = false;
      _mgysdPermissions = <String, bool>{
        'reportCase': false,
        'viewReportedCases': false,
        'createCase': false,
      };
      notifyListeners();
    }
  }

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

      /// Keep old MGYSD IP-based config as fallback only.
      /// It will be overwritten by updateMgysdAccessStatusFromSavedConfig()
      /// if the MGYSD Data Store config exists.
      _canManageMgysd = userAccesses.containsKey('canManageMgysd') &&
          userAccesses['canManageMgysd'] == true;
    } catch (error) {
      //
    }

    notifyListeners();
  }

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

    updateMgysdAccessStatusFromSavedConfig();

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
