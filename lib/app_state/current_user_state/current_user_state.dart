import 'package:flutter/foundation.dart';
import 'package:lncmis_mobile_app/core/constants/user_account_reference.dart';
import 'package:lncmis_mobile_app/core/services/organisation_unit_service.dart';
import 'package:lncmis_mobile_app/core/services/user_access.dart';
import 'package:lncmis_mobile_app/core/services/user_service.dart';
import 'package:lncmis_mobile_app/models/current_user.dart';
import 'package:lncmis_mobile_app/models/organisation_unit.dart';

class CurrentUserState with ChangeNotifier {
  CurrentUser? _currentUser;
  String? _currentUserLocations;
  String? _implementingPartner;
  List<String?>? _currentUserCountryLevelReferences;
  bool? _canCurrentUserDoDataEntry;
  bool? _canManageMgysd;

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

  bool get canManageMgysd => _canManageMgysd ?? false;

  bool get canMgysdReportCase =>
      canManageMgysd && (_mgysdPermissions['reportCase'] ?? true);

  bool get canMgysdViewReportedCases =>
      canManageMgysd && (_mgysdPermissions['viewReportedCases'] ?? true);

  bool get canMgysdCreateCase =>
      canManageMgysd && (_mgysdPermissions['createCase'] ?? true);

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
      if (mgysdConfig == null) return true;
      final enabled = mgysdConfig['enabled'];
      if (enabled == false) return false;

      final accessControl = mgysdConfig['accessControl'] ?? <String, dynamic>{};
      final requiredGroups = _normaliseList(accessControl['requiredUserGroups']);
      final requiredRoles = _normaliseList(accessControl['requiredRoles']);

      if (requiredGroups.isEmpty && requiredRoles.isEmpty) return true;

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

      if (requiredGroups.isNotEmpty && requiredRoles.isEmpty) {
        return hasGroupAccess;
      }
      if (requiredGroups.isEmpty && requiredRoles.isNotEmpty) {
        return hasRoleAccess;
      }
      return mode == 'ALL'
          ? hasGroupAccess && hasRoleAccess
          : hasGroupAccess || hasRoleAccess;
    } catch (_) {
      return true;
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
    } catch (_) {}
    return null;
  }

  Map<String, bool> _permissionsForRole(dynamic mgysdConfig, String? roleKey) {
    final defaultPermissions = <String, bool>{
      'reportCase': true,
      'viewReportedCases': true,
      'createCase': true,
    };
    try {
      if (mgysdConfig == null || roleKey == null || roleKey.trim().isEmpty) {
        return defaultPermissions;
      }
      final permissions = mgysdConfig['permissions'] ?? <String, dynamic>{};
      if (permissions is! Map) return defaultPermissions;
      final rolePermissions = permissions[roleKey] ?? <String, dynamic>{};
      if (rolePermissions is! Map) return defaultPermissions;
      bool readBool(String key) {
        if (!rolePermissions.containsKey(key)) return true;
        return rolePermissions[key] == true;
      }
      return <String, bool>{
        'reportCase': readBool('reportCase'),
        'viewReportedCases': readBool('viewReportedCases'),
        'createCase': readBool('createCase'),
      };
    } catch (_) {
      return defaultPermissions;
    }
  }

  Future<void> updateMgysdAccessStatusFromSavedConfig() async {
    try {
      final mgysdConfig = await UserAccess().getSavedMgysdMobileConfig();
      final hasModuleAccess = _evaluateMgysdAccessFromConfig(mgysdConfig);
      final roleKey = _resolveMgysdRoleKey(mgysdConfig);
      final rolePermissions = _permissionsForRole(mgysdConfig, roleKey);
      _canManageMgysd = hasModuleAccess;
      _mgysdPermissions = hasModuleAccess ? rolePermissions : <String, bool>{};
      notifyListeners();
    } catch (_) {
      _canManageMgysd = true;
      _mgysdPermissions = <String, bool>{
        'reportCase': true,
        'viewReportedCases': true,
        'createCase': true,
      };
      notifyListeners();
    }
  }

  void updateUserAccessStatus(
    String? implementingPartner,
    dynamic userAccessConfigurations,
  ) {
    try {
      final userAccesses = userAccessConfigurations[implementingPartner] ?? {};
      _canManageMgysd =
          userAccesses['canManageMgysd'] == true || implementingPartner == 'LNCMIS';
    } catch (_) {
      _canManageMgysd = true;
    }
    notifyListeners();
  }

  void setCurrentUser(
    CurrentUser user,
    dynamic userAccessConfigurations,
  ) {
    _currentUser = user;
    final implementingPartner = user.implementingPartner;
    _implementingPartner = implementingPartner;
    updateUserAccessStatus(implementingPartner, userAccessConfigurations);
    updateMgysdAccessStatusFromSavedConfig();
    setCurrentUserLocation();
  }

  void setCurrentUserCountryLevelReferences() async {
    const int level = 1;
    final organisationUnits =
        await OrganisationUnitService().getOrganisationUnitsByLevel(level);
    _currentUserCountryLevelReferences = organisationUnits
        .map((OrganisationUnit organisationUnit) => organisationUnit.id)
        .toList()
        .toSet().cast<String?>()
        .toList();
    notifyListeners();
  }

  void setCurrentUserLocation() async {
    String locations = '';
    if (_currentUser != null && _currentUser!.userOrgUnitIds != null) {
      final organisationUnits = await OrganisationUnitService()
          .getOrganisationUnits(_currentUser!.userOrgUnitIds!);
      locations = organisationUnits
          .map((OrganisationUnit organisationUnit) => organisationUnit.name ?? '')
          .toList()
          .join(', ');
    }
    _currentUserLocations = locations;
    notifyListeners();
  }

  Future getAndSetCurrentUserDataEntryAuthorityStatus() async {
    if (_currentUser != null) {
      final status = await UserService().getCurrentUserDataEntryAuthorityStatus();
      final canCurrentUserDoDataEntry = status &&
          !UserAccountReference.superUserIpNames
              .contains(_currentUser?.implementingPartner);
      await UserService().setDataEntryAuthorityStatus(canCurrentUserDoDataEntry);
      _canCurrentUserDoDataEntry = canCurrentUserDoDataEntry;
      notifyListeners();
    }
  }
}
