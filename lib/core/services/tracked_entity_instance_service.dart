import 'dart:convert';

import 'package:kb_mobile_app/core/services/http_service.dart';
import 'package:kb_mobile_app/core/services/user_service.dart';
import 'package:kb_mobile_app/models/current_user.dart';

class TrackedEntityInstanceService {
  Future discoverTrackedEntityInstnaceById(String teiId) async {
    try {
      CurrentUser? currentUser = await (UserService().getCurrentUser());
      HttpService httpService = HttpService(
        username: currentUser!.username,
        password: currentUser.password,
      );
      var url = "api/trackedEntityInstances/$teiId.json";
      List<String> programs = await discoveringBeneficiaryPrograms(teiId);
      for (String program in programs) {
        var queryParameters = {
          "program": program,
          "fields":
              "trackedEntityInstance,trackedEntityType,orgUnit,attributes[attribute,value,displayName],enrollments[enrollment,enrollmentDate,incidentDate,orgUnit,program,trackedEntityInstance,status,events[event,program,programStage,trackedEntityInstance,status,orgUnit,dataValues[dataElement,value,displayName],eventDate]],relationships[relationshipType,relationship,from[trackedEntityInstance[trackedEntityInstance]],to[trackedEntityInstance[trackedEntityInstance]]]"
        };
        var response =
            await httpService.httpGet(url, queryParameters: queryParameters);
        if (response.statusCode == 200) {
          Map<String, dynamic> teiJson = json.decode(response.body);
          List teiEnrollmentsJson = teiJson["enrollments"] ?? [];
          List teiReleationShipsJson = teiJson["relationships"] ?? [];
          List teiEventsJson = [];
          for (var enrollment in teiEnrollmentsJson) {
            teiEventsJson.addAll(enrollment["events"] ?? []);
          }
          await saveTrackeEntityInstanceProfile(teiJson);
          await saveTrackeEntityInstanceEnrollment(teiEnrollmentsJson);
          await saveTrackeEntityInstanceEvents(teiEventsJson);
          await saveTrackeEntityInstanceRelationShips(teiReleationShipsJson);
        }
      }
    } catch (error) {
      print("error on discoverTrackedEntityInstnaceById ${error.toString()}");
    }
  }

  Future saveTrackeEntityInstanceProfile(dynamic teiJson) async {}

  Future saveTrackeEntityInstanceEnrollment(List teiEnrollmentsJson) async {
    for (dynamic json in teiEnrollmentsJson) {
      print("enrollment->json=> $json");
    }
  }

  Future saveTrackeEntityInstanceEvents(List teiEventsJson) async {
    for (dynamic json in teiEventsJson) {
      print("evebts->json=> $json");
    }
  }

  Future saveTrackeEntityInstanceRelationShips(
    List teiReleationShipsJson,
  ) async {
    for (dynamic json in teiReleationShipsJson) {
      print("relations->json=> $json");
    }
  }

  Future<List<String>> discoveringBeneficiaryPrograms(String teiId) async {
    List<String> programs = [];
    try {
      CurrentUser? currentUser = await (UserService().getCurrentUser());
      HttpService httpService = HttpService(
        username: currentUser!.username,
        password: currentUser.password,
      );
      var url = "api/trackedEntityInstances/$teiId.json";
      var queryParameters = {"fields": "enrollments[program]"};
      var response =
          await httpService.httpGet(url, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        Map<String, dynamic> dataReponse = json.decode(response.body);
        List enrollments = dataReponse["enrollments"] ?? [];
        for (var enrollment in enrollments) {
          programs.add(enrollment["program"] ?? "");
        }
      }
    } catch (error) {}
    return programs
        .toSet()
        .toList()
        .where((program) => program.isNotEmpty)
        .toList();
  }
}
