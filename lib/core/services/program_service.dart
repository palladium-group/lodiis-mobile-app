import 'dart:async';
import 'dart:convert';

import 'package:lncmis_mobile_app/core/offline_db/program_ou_offline/program_ou_offline_provider.dart';
import 'package:lncmis_mobile_app/core/services/http_service.dart';
import 'package:lncmis_mobile_app/core/services/user_service.dart';
import 'package:lncmis_mobile_app/models/current_user.dart';

class ProgramService {
  Future<dynamic> discoverProgramOrganisationUnitsFromTheServer(
      String? program) async {
    List<String> programOrganisationUnits = [];
    var url = "api/programs/$program.json";
    var queryParameters = {
      "fields": "organisationUnits[id,path]",
      "paging": "false"
    };
    CurrentUser? user = await (UserService().getCurrentUser());
    HttpService http = HttpService(
      username: user!.username,
      password: user.password,
    );
    var response = await http.httpGet(
      url,
      queryParameters: queryParameters,
    );
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      for (var organisationUnit in responseData["organisationUnits"]) {
        programOrganisationUnits
            .addAll(getOrganisationUnitsFromPath(organisationUnit["path"]));
      }
      setProgramOrganisationUnits(
          program, programOrganisationUnits.toSet().toList());
    } else {
      return null;
    }
  }

  Future<List<String?>> getOfflineProgramOrganisationUnits(
      String programId) async {
    return await ProgramOuOfflineProvider()
        .getProgramOrganisationUnits(programId);
  }

  setProgramOrganisationUnits(
      String? program, List<String> organisationUnits) async {
    await ProgramOuOfflineProvider()
        .addProgramOrganisationUnit(program, organisationUnits);
  }

  List<String> getOrganisationUnitsFromPath(String path) {
    List<String> organisationUnits = path.split('/');
    organisationUnits
        .removeWhere((String organisationUnit) => organisationUnit == '');
    return organisationUnits;
  }
}
