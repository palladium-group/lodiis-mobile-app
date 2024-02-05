import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kb_mobile_app/models/app_semantic_version.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';

class AppUtil {
  static FormSection getServiceProvisionEventDateSection({
    required Color inputColor,
    required Color labelColor,
    required Color sectionLabelColor,
    required String firstDate,
    String id = '',
    String formSectionLabel = 'Service Provision Date',
    String inputFieldLabel = 'Services On',
  }) {
    return FormSection(
      id: id.isEmpty ? AppUtil.getUid() : id,
      name: formSectionLabel,
      color: sectionLabelColor,
      inputFields: [
        InputField(
          id: 'eventDate',
          name: inputFieldLabel,
          valueType: 'DATE',
          firstDate: firstDate,
          inputColor: inputColor,
          labelColor: labelColor,
        ),
      ],
    );
  }

  static FormSection getServiceProvisionLocationSection({
    required Color inputColor,
    required Color labelColor,
    required Color sectionLabelColor,
    required List<int> allowedSelectedLevels,
    required String program,
    bool isReadOnly = false,
    String formlabel = 'Service Provision Location',
    String id = '',
  }) {
    return FormSection(
      id: id.isEmpty ? AppUtil.getUid() : id,
      name: formlabel,
      color: sectionLabelColor,
      inputFields: [
        InputField(
          id: 'location',
          name: 'Location',
          translatedName: 'Sebaka',
          valueType: 'ORGANISATION_UNIT',
          isReadOnly: isReadOnly,
          allowedSelectedLevels: allowedSelectedLevels,
          filteredPrograms: [program],
          inputColor: inputColor,
          labelColor: labelColor,
        ),
      ],
    );
  }

  static bool hasAccessToEditCasePlanServiceData(List<Events> events) {
    return events.length ==
        events
            .where((Events event) => event.enrollmentOuAccessible!)
            .toList()
            .length;
  }

  static AppSemanticVersion getSemanticVersionValue({version}) {
    List<String> versionList = version.split(".");
    int major = 0;
    int minor = 0;
    int patch = 0;
    if (versionList.isNotEmpty && versionList[0] != "") {
      major = versionList.isNotEmpty ? int.parse(versionList[0]) : major;
    }
    if (versionList.length > 1 && versionList[2] != "") {
      minor = versionList.isNotEmpty ? int.parse(versionList[1]) : minor;
    }
    if (versionList.length > 2 && versionList[2] != "") {
      patch = versionList.isNotEmpty ? int.parse(versionList[2]) : patch;
    }
    return AppSemanticVersion(major: major, minor: minor, patch: patch);
  }

  static void setStatusBarColor(Color? color) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: color,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  static String getUid() {
    Random rnd = Random();
    const letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const allowedChars = '0123456789$letters';
    const numberOfCodePoints = allowedChars.length;
    const codeSize = 11;
    String uid;
    int charIndex = (rnd.nextInt(10) / 10 * letters.length).round();
    uid = letters.substring(charIndex, charIndex + 1);
    for (int i = 1; i < codeSize; ++i) {
      charIndex = (rnd.nextInt(10) / 10 * numberOfCodePoints).round();
      uid += allowedChars.substring(charIndex, charIndex + 1);
    }
    return uid;
  }

  static String formattedDateTimeIntoString(DateTime date) {
    return date.toIso8601String().split('T')[0].trim();
  }

  static String getDataAndTimeFormatFromDateTime(DateTime date) {
    String formattedDate = formattedDateTimeIntoString(date);
    int hours = date.hour;
    int minute = date.minute;
    String formattedTime = hours > 9 ? "$hours" : "0$hours";
    formattedTime += ":";
    formattedTime += minute > 9 ? "$minute" : "0$minute";
    return "${formattedDate}T$formattedTime";
  }

  static DateTime getDateIntoDateTimeFormat(String date) {
    return DateTime.tryParse(date) ?? DateTime.now();
  }

  static DateTime getMinimumDateTimeFromDateList(List<String> dates) {
    return dates.isEmpty
        ? DateTime.now()
        : dates
            .map((String date) => getDateIntoDateTimeFormat(date))
            .reduce((previousDate, currentDate) {
            return currentDate.isBefore(previousDate)
                ? currentDate
                : previousDate;
          });
  }

  static DateTime getMaxmumDateTimeFromDateList(List<String> dates) {
    return dates.isEmpty
        ? DateTime.now()
        : dates
            .map((String date) => getDateIntoDateTimeFormat(date))
            .reduce((previousDate, currentDate) {
            return currentDate.isAfter(previousDate)
                ? currentDate
                : previousDate;
          });
  }

  static Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
  }

  static int getAgeInYear(
    String? dateOfBirth, {
    DateTime? currentDate,
    bool? ceil = false,
  }) {
    int age = 0;
    try {
      currentDate = currentDate ?? DateTime.now();
      DateTime birthDate = dateOfBirth != null && dateOfBirth != ''
          ? getDateIntoDateTimeFormat(dateOfBirth)
          : getDateIntoDateTimeFormat(formattedDateTimeIntoString(currentDate));
      age = currentDate.year - birthDate.year;

      if (ceil == true) {
        if (birthDate.month > currentDate.month ||
            birthDate.day > currentDate.day) {
          age++;
        }
      } else {
        if (birthDate.month > currentDate.month) {
          age--;
        } else if (birthDate.month == currentDate.month) {
          if (birthDate.day > currentDate.day) {
            age--;
          }
        }
      }
    } catch (e) {
      //
    }
    return age;
  }

  static List<List<dynamic>> chunkItems({
    List<dynamic> items = const [],
    int size = 0,
  }) {
    List<List<dynamic>> groupedItems = [];
    size = size != 0 ? size : items.length;
    for (var count = 1; count <= (items.length / size).ceil(); count++) {
      int start = (count - 1) * size;
      int end = (count * size);
      List<dynamic> subList =
          items.sublist(start, end > items.length ? items.length : end);
      groupedItems.add(subList);
    }
    return groupedItems;
  }

  bool searchFromString({
    String? searchableString,
    required String searchedValue,
  }) {
    List<String> searchedValues =
        searchedValue.split(' ').where((item) => item.isNotEmpty).toList();

    for (String search in searchedValues) {
      if (RegExp(search.toLowerCase())
          .hasMatch(searchableString!.toLowerCase())) {
        return true;
      }
    }

    return false;
  }

  static Widget getConfirmationWidget(
    BuildContext context,
    String? message,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: Text(
              message ?? '',
              style: const TextStyle().copyWith(
                color: const Color(0xFF82898D),
                fontSize: 14.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                      right: 5.0,
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Color(0xFF7FBA7C),
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          color: Color(0xFF7FBA7C),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 5.0,
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.redAccent,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        "Discard changes",
                        style: TextStyle(
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  static showActionSheetModal({
    required BuildContext context,
    required Widget containerBody,
    Widget? title,
    Color? backgroundColor,
    double initialHeightRatio = 0.3,
    double minHeightRatio = 0.1,
    double maxHeightRatio = 0.85,
  }) {
    maxHeightRatio = maxHeightRatio > 0 ? maxHeightRatio : 0.85;
    return showModalBottomSheet(
      context: context,
      elevation: 2.0,
      isDismissible: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {},
          child: DraggableScrollableSheet(
            initialChildSize: initialHeightRatio,
            maxChildSize: maxHeightRatio < initialHeightRatio
                ? initialHeightRatio
                : maxHeightRatio,
            minChildSize: minHeightRatio < initialHeightRatio
                ? minHeightRatio
                : initialHeightRatio,
            builder: (BuildContext context, ScrollController scrollController) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8.0)),
                      color: backgroundColor ?? Colors.white),
                  child: Column(
                    children: [
                      Visibility(
                          visible: title != null,
                          child: Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: title)),
                      Flexible(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 1.0,
                              ),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.0),
                                ),
                              ),
                              child: containerBody,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  static showToastMessage({
    required String message,
    ToastGravity? position = ToastGravity.BOTTOM,
  }) {
    if (message.isNotEmpty) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: position,
        backgroundColor: const Color(0xFF656565),
      );
    }
  }

  static showPopUpModal(
    BuildContext context,
    Widget modal,
    bool diablePadding, {
    String title = '',
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.0),
          ),
          child: Padding(
            padding: diablePadding
                ? const EdgeInsets.all(0)
                : const EdgeInsets.only(
                    bottom: 12.0,
                    top: 5.0,
                    right: 5.0,
                    left: 5.0,
                  ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 9,
                          child: title == ''
                              ? Container()
                              : Container(
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: const TextStyle().copyWith(
                                          color: const Color(0xFF82898D),
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () => Navigator.of(context).pop(true),
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 22,
                                  width: 22,
                                  child: SvgPicture.asset(
                                    'assets/icons/close_icon.svg',
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  modal
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
