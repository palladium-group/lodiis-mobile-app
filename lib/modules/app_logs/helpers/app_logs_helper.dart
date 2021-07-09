import 'dart:io';
import 'package:excel/excel.dart';
import 'package:kb_mobile_app/core/services/user_service.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/current_user.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:kb_mobile_app/core/offline_db/app_logs_offline/app_logs_offline_provider.dart';
import 'package:kb_mobile_app/modules/app_logs/services/app_logs_service.dart';

class AppLogsHelper {
  static Future<String> get _appPath async {
    final folderName = "Lesotho OVC-DREAMS";
    final directory = Directory("storage/emulated/0/$folderName/logs");
    if (await _requestStoragePermission(Permission.storage)) {
      if (!await directory.exists()) {
        try {
          var createdDir = await directory.create(recursive: true);
          return createdDir.path;
        } catch (e) {
          throw e;
        }
      }
      return directory.path;
    } else {
      AppUtil.showToastMessage(
          message: 'Application was not given access to phone storage');
      return '';
    }
  }

  static Future<File> get _localFile async {
    final path = await _appPath;
    if (path != '') {
      CurrentUser user = await UserService().getCurrentUser();
      return File('$path/${user.username}-logs.xlsx');
    } else {
      return null;
    }
  }

  static Future<void> writeToExcelFile(dynamic fileBytes) async {
    try {
      final file = await _localFile;
      if (file != null) {
        file..writeAsBytesSync(fileBytes, mode: FileMode.write);
        AppUtil.showToastMessage(message: 'Saved the logs successfully');
      }
    } catch (e) {
      throw e;
    }
  }

  static Future<bool> _requestStoragePermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      return result == PermissionStatus.granted;
    }
  }

  static dynamic generateLogsExcel() async {
    try {
      var excel = Excel.createExcel();
      excel.rename('Sheet1', 'app-logs');
      Sheet sheetObject = excel['app-logs'];
      List<String> tableHeaders = AppLogsOfflineProvider().getTableColumns();
      int rowCount = 0;
      sheetObject.insertRowIterables(tableHeaders, rowCount);
      List<List<String>> rows = await getExcelRows(tableHeaders);
      for (List<String> row in rows) {
        rowCount++;
        sheetObject.insertRowIterables(row, rowCount);
      }
      return excel;
    } catch (e) {
      AppUtil.showToastMessage(message: 'Failed to generate logs file');
      return null;
    }
  }

  static Future<List<List<String>>> getExcelRows(
      List<String> columnHeaders) async {
    List<List<String>> rows = [];
    List<Map> logs = await AppLogsService().getAllAppLogs();
    for (Map log in logs) {
      List<String> row = [];
      for (String column in columnHeaders) {
        row.add(log[column]);
      }
      rows.add(row);
    }
    return rows;
  }
}
