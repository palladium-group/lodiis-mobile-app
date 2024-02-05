import 'dart:convert';
import 'package:kb_mobile_app/core/constants/app_logs_constants.dart';
import 'package:kb_mobile_app/core/offline_db/app_logs_offline/app_logs_offline_provider.dart';
import 'package:kb_mobile_app/core/services/http_service.dart';
import 'package:kb_mobile_app/core/services/organisation_unit_service.dart';
import 'package:kb_mobile_app/core/services/user_service.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/app_logs.dart';
import 'package:kb_mobile_app/models/current_user.dart';
import 'package:kb_mobile_app/modules/app_logs/constants/program_stages_constants.dart';
import 'package:kb_mobile_app/modules/app_logs/constants/programs_constants.dart';

class AppLogsService {
  Future<void> saveLogs(AppLogs appLog) async {
    await AppLogsOfflineProvider().addLogs(appLog);
  }

  Future<List<AppLogs>> getAppLogs(
      {int? page, String searchableValue = ''}) async {
    List<AppLogs> appLogsList = [];
    try {
      List<AppLogs> appLogs =
          await AppLogsOfflineProvider().getLogs(page: page);

      for (var logs in appLogs) {
        logs.message = await getFormattedMessage(logs.message ?? '');
        appLogsList.add(logs);
      }
    } catch (e) {
      AppLogs log = AppLogs(
          type: AppLogsConstants.errorLogType,
          message: 'getAppLogs: ${e.toString()}');
      await AppLogsOfflineProvider().addLogs(log);
    }

    return searchableValue == ''
        ? appLogsList
        : appLogsList
            .where((AppLogs logs) => AppUtil().searchFromString(
                searchableString: logs.searchableValue,
                searchedValue: searchableValue))
            .toList();
  }

  void sendLogsToDataStore() async {
    String url = "api/dataStore/kb-mobile-app-logs";
    try {
      CurrentUser? user = await UserService().getCurrentUser();
      if (user != null) {
        String password = user.password ?? '';
        String username = user.username ?? '';

        HttpService http = HttpService(
          username: username,
          password: password,
        );
        List<AppLogs> appLogs = await AppLogsOfflineProvider().getLogs();
        List<Map> body = appLogs.map((log) {
          return log.toOffline();
        }).toList();
        await http.httpDelete('$url/$username');
        await http.httpPost('$url/$username', json.encode(body));
      }
    } catch (error) {
      AppLogs log = AppLogs(
          type: AppLogsConstants.errorLogType,
          message: 'sendLogsToDataStore: ${error.toString()}');
      await AppLogsOfflineProvider().addLogs(log);
    }
  }

  Future<List<Map>> getAllAppLogs() async {
    List<Map> appLogsList = [];
    try {
      List<AppLogs> appLogs = await AppLogsOfflineProvider().getLogs();
      List<Map> refactoredAppLogs = appLogs.map((log) {
        return log.toOffline();
      }).toList();
      appLogsList.addAll(refactoredAppLogs);
    } catch (e) {
      AppLogs log = AppLogs(
          type: AppLogsConstants.errorLogType,
          message: 'getAllAppLogs: ${e.toString()}');
      await AppLogsOfflineProvider().addLogs(log);
    }
    return appLogsList;
  }

  Future<String> getFormattedMessage(String message) async {
    String formattedMessage = '';
    try {
      RegExp connectionRegex = RegExp(r"(timed out)");
      RegExp accessRegex = RegExp(r"(access)");
      RegExp enrollmentRegex = RegExp(r"(not enrolled)");
      RegExp socketRegex = RegExp(r"(SocketException)");
      RegExp eventForTeiNotExistRegex = RegExp(
          r"Event.trackedEntityInstance does not point to a valid tracked entity instance");
      RegExp eventForStageNotExistRegex =
          RegExp(r"Event.programStage does not point to a valid programStage");
      RegExp attributeRegEx = RegExp(r"Attribute.value");
      RegExp notValidRegEx = RegExp(r"is not a valid");
      RegExp clientConnection =
          RegExp(r"ClientException: Software cause connection abort");
      RegExp ouAccessRegEx =
          RegExp(r"Program is not assigned to this organisation unit");

      // Check for possible error messages
      if (socketRegex.hasMatch(message) || clientConnection.hasMatch(message)) {
        formattedMessage = 'Internet connection error';
      } else if (accessRegex.hasMatch(message)) {
        String programStage = getProgramStageName(message);
        formattedMessage =
            'Current user has no access to $programStage service';
      } else if (enrollmentRegex.hasMatch(message)) {
        String program = getProgramName(message);
        formattedMessage =
            'Beneficiaries not enrolled to $program intervention.';
      } else if (connectionRegex.hasMatch(message)) {
        formattedMessage = 'Failed to connect to the server';
      } else if (eventForTeiNotExistRegex.hasMatch(message)) {
        formattedMessage =
            'Can not upload services for unenrolled beneficiaries';
      } else if (eventForStageNotExistRegex.hasMatch(message)) {
        formattedMessage = 'Can not upload services for unknown intervention';
      } else if (attributeRegEx.hasMatch(message) ||
          notValidRegEx.hasMatch(message)) {
        formattedMessage = 'Attribute has invalid value type';
      } else if (ouAccessRegEx.hasMatch(message)) {
        String ouId = message.split(':').last.trim();
        var ou = (await OrganisationUnitService().getOrganisationUnits([ouId]))
            .first;
        formattedMessage = 'Intervention is not assigned to ${ou.name}';
      } else {
        formattedMessage = message;
      }
    } catch (e) {
      formattedMessage = message;
    }
    return formattedMessage;
  }

  Future<void> clearLogs() async {
    await AppLogsOfflineProvider().clearLogs();
  }

  String getProgramStageName(String message) {
    Map programStages = ProgramStagesConstants.programStages;
    String programStage = '';
    programStages.forEach((id, name) {
      if (message.contains(id)) {
        programStage = 'to $name';
      }
    });

    return programStage;
  }

  String getProgramName(String message) {
    Map programs = ProgramsConstants.programs;
    String program = '';
    programs.forEach((id, name) {
      if (message.contains(id)) {
        program = ' $name';
      }
    });

    return program;
  }

  Future<int> getAppLogsCount() async {
    return await AppLogsOfflineProvider().getAppLogsCount();
  }
}
