import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class AppUtil {
  static bool hasAllMandarotyFieldsFilled(List mandatoryFields, Map dataObject,
      {Map hiddenFields = const {}}) {
    bool hasFilled = true;
    List fieldIds = dataObject.keys.toList();
    List hiddenFieldsIds = hiddenFields.keys.toList();
    //Remove all hidden fields which are mandatory from the list
    List filteredMandatoryFields = mandatoryFields
        .where((field) => hiddenFieldsIds.indexOf(field) < 0)
        .toList();
    for (var mandatoryField in filteredMandatoryFields) {
      if (fieldIds.indexOf(mandatoryField) == -1) {
        hasFilled = false;
      } else {
        if ('${dataObject[mandatoryField]}'.trim() == '' ||
            '${dataObject[mandatoryField]}'.trim() == 'null') {
          hasFilled = false;
        }
      }
    }
    return hasFilled;
  }

  static List getUnFilledMandatoryFields(List mandatoryFields, Map dataObject,
      {Map hiddenFields = const {}}) {
    List unFilledMandatoryFields = [];
    List fieldIds = dataObject.keys.toList();
    List hiddenFieldsIds = hiddenFields.keys.toList();
    //Remove all hidden fields which are mandatory from the list
    List filteredMandatoryFields = mandatoryFields
        .where((field) => hiddenFieldsIds.indexOf(field) < 0)
        .toList();
    for (var mandatoryField in filteredMandatoryFields) {
      if (fieldIds.indexOf(mandatoryField) == -1) {
        unFilledMandatoryFields.add(mandatoryField);
      } else {
        if ('${dataObject[mandatoryField]}'.trim() == '' ||
            '${dataObject[mandatoryField]}'.trim() == 'null') {
          unFilledMandatoryFields.add(mandatoryField);
        }
      }
    }
    return unFilledMandatoryFields;
  }

  static bool getAtleastOneFormFieldsFilledStatus(
    List fields,
    Map dataObject,
  ) {
    List unFilledFields = [];
    List fieldIds = dataObject.keys.toList();
    for (var field in fields) {
      if (fieldIds.indexOf(field) == -1) {
        unFilledFields.add(field);
      } else {
        if ('${dataObject[field]}'.trim() == '' ||
            '${dataObject[field]}'.trim() == 'null') {
          unFilledFields.add(field);
        }
      }
    }
    return unFilledFields.length < fields.length;
  }

  static void setStatusBarColor(Color color) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: color,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  static String getUid() {
    Random rnd = new Random();
    const letters = 'abcdefghijklmnopqrstuvwxyz' + 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const allowedChars = '0123456789' + letters;
    const NUMBER_OF_CODEPOINTS = allowedChars.length;
    const CODESIZE = 11;
    String uid;
    int charIndex = (rnd.nextInt(10) / 10 * letters.length).round();
    uid = letters.substring(charIndex, charIndex + 1);
    for (int i = 1; i < CODESIZE; ++i) {
      charIndex = (rnd.nextInt(10) / 10 * NUMBER_OF_CODEPOINTS).round();
      uid += allowedChars.substring(charIndex, charIndex + 1);
    }
    return uid;
  }

  static String formattedDateTimeIntoString(DateTime date) {
    return date.toIso8601String().split('T')[0].trim();
  }

  static DateTime getDateIntoDateTimeFormat(String date) {
    return DateTime.parse(date);
  }

  static Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
  }

  static int getAgeInYear(String dateOfBirth) {
    int age = 0;
    try {
      DateTime currentDate = DateTime.now();
      DateTime birthDate = dateOfBirth != null && dateOfBirth != ''
          ? getDateIntoDateTimeFormat(dateOfBirth)
          : getDateIntoDateTimeFormat(formattedDateTimeIntoString(currentDate));
      age = currentDate.year - birthDate.year;
      if (birthDate.month > currentDate.month) {
        age--;
      } else if (birthDate.month == currentDate.month) {
        if (birthDate.day > currentDate.day) {
          age--;
        }
      }
    } catch (e) {}
    return age;
  }

  static showToastMessage({
    String message,
    ToastGravity position = ToastGravity.BOTTOM,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: position,
      backgroundColor: Color(0xFF656565),
    );
  }

  static showPopUpModal(
    BuildContext context,
    Widget modal,
    bool diablePadding,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
          child: Container(
            child: Padding(
              padding: diablePadding
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.only(
                      bottom: 12,
                      top: 5,
                      right: 5,
                      left: 5,
                    ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              margin: EdgeInsets.all(10),
                              height: 22,
                              width: 22,
                              child: SvgPicture.asset(
                                'assets/icons/close_icon.svg',
                              ),
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
          ),
        );
      },
    );
  }
}
