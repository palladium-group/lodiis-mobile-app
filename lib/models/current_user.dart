
class CurrentUser {
  String? id;
  String? name;
  String? username;
  String? password;
  String? email;
  String? phoneNumber;
  String? implementingPartner;
  String? subImplementingPartner;
  String? userRoles;
  String? userGroups;
  bool? isLogin;
  bool? hasPreviousSuccessLogin;
  List? userOrgUnitIds;
  List? programs;

  static const String userTable = 'current_user';
  static const String userProgramTable = 'current_user_program';
  static const String userOrganisationUnitTable = 'current_user_ou';

  CurrentUser({
    this.id,
    this.name,
    this.username,
    this.email,
    this.phoneNumber,
    this.password,
    this.isLogin,
    this.hasPreviousSuccessLogin,
    this.implementingPartner,
    this.subImplementingPartner,
    this.userOrgUnitIds,
    this.programs,
    this.userRoles,
    this.userGroups,
  }) {
    email = email ?? "";
    phoneNumber = phoneNumber ?? "";
    userOrgUnitIds = userOrgUnitIds ?? [];
    programs = programs ?? [];
    userRoles = userRoles ?? "";
    userGroups = userGroups ?? "";
  }

  bool isCurrentUserSet() {
    return username != null &&
        username!.isNotEmpty &&
        password != null &&
        password!.isNotEmpty;
  }

  @override
  String toString() {
    return 'Current user is $username $id $name $implementingPartner->$subImplementingPartner :: $hasPreviousSuccessLogin';
  }

  factory CurrentUser.fromJson(
    dynamic json,
    String? username,
    String? password,
  ) {
    List programList = json['programs'] as List<dynamic>;
    List organisationUnitList = json['organisationUnits'] as List<dynamic>;
    List userOrgUnitIds = [];
    for (var organisationUnit in organisationUnitList) {
      userOrgUnitIds.add(organisationUnit['id']);
    }
    List attributeValues = json['attributeValues'] as List<dynamic>;
    String subImplementingPartner =
        getCurrentUserSuImplementingPartner(attributeValues);
    String implementingPartner =
        getCurrentUserImplementingPartner(attributeValues);
    String userGroups = getCurrentUserGroups(json);
    String userRoles = getCurrentUserRoles(json);
    return CurrentUser(
      name: json['name'],
      id: json['id'],
      password: password,
      username: username,
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      userGroups: userGroups,
      userRoles: userRoles,
      isLogin: false,
      hasPreviousSuccessLogin: false,
      subImplementingPartner: subImplementingPartner,
      implementingPartner: implementingPartner,
      programs: programList.map((program) => '$program').toList(),
      userOrgUnitIds: userOrgUnitIds,
    );
  }

  static String getCurrentUserRoles(
    dynamic json,
  ) {
    Map userCredentials = json["userCredentials"];
    List userRolesList = userCredentials['userRoles'] as List<dynamic>;
    return userRolesList
        .map((dynamic userRole) => userRole["name"] ?? "")
        .toList()
        .toSet()
        .toList()
        .join(", ");
  }

  static String getCurrentUserGroups(
    dynamic json,
  ) {
    List userGroupsList = json['userGroups'] as List<dynamic>;
    return userGroupsList
        .map((dynamic userGroup) => userGroup["name"] ?? "")
        .toList()
        .toSet()
        .toList()
        .join(", ");
  }

  static String getCurrentUserSuImplementingPartner(
    List<dynamic> attributeValues,
  ) {
    String subImplementingPartner = '';
    for (var attributeValue in attributeValues) {
      if (attributeValue['value'] != null &&
          attributeValue['attribute'] != null) {
        Map attribute = attributeValue['attribute'];

      }
    }
    return subImplementingPartner;
  }

  static String getCurrentUserImplementingPartner(
    List<dynamic> attributeValues,
  ) {
    String implementingPartner = '';
    for (var attributeValue in attributeValues) {
      if (attributeValue['value'] != null &&
          attributeValue['attribute'] != null) {
        Map attribute = attributeValue['attribute'];
      }
    }
    return implementingPartner;
  }

  Map toOffline(CurrentUser user) {
    var data = <String, dynamic>{};
    data['id'] = user.id;
    data['name'] = user.name;
    data['username'] = user.username;
    data['email'] = user.email;
    data['phoneNumber'] = user.phoneNumber;
    data['userGroups'] = user.userGroups;
    data['userRoles'] = user.userRoles;
    data['password'] = user.password;
    data['isLogin'] = user.isLogin! ? 1 : 0;
    data['hasPreviousSuccessLogin'] = user.hasPreviousSuccessLogin! ? 1 : 0;
    data['subImplementingPartner'] = user.subImplementingPartner;
    data['implementingPartner'] = user.implementingPartner;
    return data;
  }

  CurrentUser.fromOffline(Map<String, dynamic> mapData) {
    id = mapData['id'];
    name = mapData['name'];
    username = mapData['username'];
    password = mapData['password'];
    email = mapData['email'];
    phoneNumber = mapData['phoneNumber'];
    userGroups = mapData['userGroups'];
    userRoles = mapData['userRoles'];
    isLogin = '${mapData['isLogin']}' == '1';
    hasPreviousSuccessLogin = '${mapData['hasPreviousSuccessLogin']}' == '1';
    implementingPartner = mapData['implementingPartner'];
    subImplementingPartner = mapData['subImplementingPartner'];
    userOrgUnitIds = [];
    programs = [];
  }
}
