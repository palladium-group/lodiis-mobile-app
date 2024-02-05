import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/components/input_fields/boolean_input_field_container.dart';
import 'package:kb_mobile_app/core/components/input_fields/check_box_list_input_field.dart';
import 'package:kb_mobile_app/core/components/input_fields/coordinate_input_field_container.dart';
import 'package:kb_mobile_app/core/components/input_fields/date_input_field_container.dart';
import 'package:kb_mobile_app/core/components/input_fields/input_clear_icon.dart';
import 'package:kb_mobile_app/core/components/input_fields/numerical_input_container.dart';
import 'package:kb_mobile_app/core/components/input_fields/organisation_unit_input_field_container.dart';
import 'package:kb_mobile_app/core/components/input_fields/phone_number_input_field_container.dart';
import 'package:kb_mobile_app/core/components/input_fields/select_input_field.dart';
import 'package:kb_mobile_app/core/components/input_fields/text_input_field_container.dart';
import 'package:kb_mobile_app/core/components/input_fields/true_only_input_field_container.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class InputFieldContainer extends StatelessWidget {
  const InputFieldContainer({
    Key? key,
    required this.inputField,
    this.lastUpdatedId = '',
    required this.currentLanguage,
    required this.hiddenInputFieldOptions,
    required this.hiddenFields,
    required this.currentUserCountryLevelReferences,
    this.onInputValueChange,
    this.dataObject,
    this.mandatoryFieldObject,
    this.isEditableMode,
    this.showClearIcon = true,
  }) : super(key: key);

  final InputField inputField;
  final String? lastUpdatedId;
  final String? currentLanguage;
  final bool? isEditableMode;
  final Function? onInputValueChange;
  final Map? dataObject;
  final Map? mandatoryFieldObject;
  final Map hiddenInputFieldOptions;
  final bool showClearIcon;
  final Map? hiddenFields;
  final List<String?> currentUserCountryLevelReferences;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: inputField.background),
      padding: inputField.background != Colors.transparent
          ? const EdgeInsets.only(
              top: 10.0,
              bottom: 0.0,
              left: 10.0,
              right: 10.0,
            )
          : const EdgeInsets.all(0),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 2.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: inputField.name != '',
              child: Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: currentLanguage == 'lesotho' &&
                                inputField.translatedName != null
                            ? inputField.translatedName
                            : inputField.name,
                        style: TextStyle(
                          color: inputField.hasError != null &&
                                  inputField.hasError!
                              ? Colors.red
                              : inputField.labelColor,
                          fontSize: 13.0,
                          fontWeight: FontWeight.normal,
                        ),
                        children: [
                          TextSpan(
                            text: mandatoryFieldObject != null &&
                                    mandatoryFieldObject![inputField.id] == true
                                ? ' *'
                                : '',
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: inputField.description != '',
              child: Container(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        currentLanguage == 'lesotho' &&
                                inputField.translatedDescription != null
                            ? inputField.translatedDescription!
                            : inputField.description!,
                        style: const TextStyle().copyWith(
                          color: inputField.labelColor,
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: inputField.hasSubInputField! &&
                  inputField.subInputField != null &&
                  (hiddenFields == null ||
                      '${hiddenFields![inputField.id]}'.trim() != 'true'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      child: isEditableMode! ||
                              inputField.valueType == 'ORGANISATION_UNIT'
                          ? _getInputField(
                              inputField.subInputField,
                              isEditableMode,
                            )
                          : _getInputFieldLabel(inputField),
                    ),
                  ),
                  Visibility(
                    visible: inputField.subInputField != null,
                    child: Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            inputField.subInputField != null
                                ? currentLanguage == 'lesotho' &&
                                        inputField.subInputField!
                                                .translatedName !=
                                            null
                                    ? inputField.subInputField!.translatedName!
                                    : inputField.subInputField!.name
                                : '',
                          ),
                          Container(
                            child: isEditableMode! ||
                                    inputField.valueType == 'ORGANISATION_UNIT'
                                ? _getInputField(
                                    inputField.subInputField,
                                    isEditableMode,
                                  )
                                : _getInputFieldLabel(inputField.subInputField),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible:
                  !inputField.hasSubInputField! && !inputField.hasLabelOnly!,
              child: Container(
                child: isEditableMode! ||
                        inputField.valueType == 'ORGANISATION_UNIT'
                    ? _getInputField(
                        inputField,
                        isEditableMode,
                      )
                    : _getInputFieldLabel(inputField),
              ),
            ),
            Visibility(
              visible: !inputField.hasLabelOnly!,
              child: LineSeparator(
                color: inputField.inputColor!.withOpacity(0.3),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getInputFieldLabel(InputField? inputField) {
    dynamic value =
        inputField != null && '${dataObject![inputField.id]}' != 'null'
            ? '${dataObject![inputField.id]}'
            : '   ';
    if (inputField != null) {
      if (inputField.valueType == "BOOLEAN") {
        value = value == 'true'
            ? currentLanguage == 'lesotho'
                ? 'E'
                : 'Yes'
            : value == 'false'
                ? currentLanguage == 'lesotho'
                    ? 'Che'
                    : 'No'
                : value;
      } else if (inputField.valueType == 'TRUE_ONLY') {
        value = value == 'true'
            ? currentLanguage == 'lesotho'
                ? 'E'
                : 'Yes'
            : value;
      } else if (inputField.options!.isNotEmpty) {
        InputFieldOption? option = inputField.options!.firstWhereOrNull(
            (InputFieldOption option) =>
                option.code != null && option.code == value);
        value = option != null ? option.name : value;
      }
    }
    return Container(
      child: inputField != null && inputField.valueType == 'CHECK_BOX'
          ? CheckBoxListInputField(
              hiddenFields: hiddenFields ?? {},
              currentLanguage: currentLanguage,
              inputField: inputField,
              isReadOnly: true, //this.onInputValueChange,
              dataObject: dataObject,
            )
          : Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 10.0,
                    ),
                    child: Text(
                      value.toString(),
                      style: const TextStyle().copyWith(
                        color:
                            inputField != null && inputField.inputColor != null
                                ? inputField.inputColor
                                : null,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Widget _getInputField(
    InputField? inputField,
    bool? isEditableMode,
  ) {
    return Container(
      child: inputField != null
          ? Row(
              children: [
                Expanded(
                  child: inputField.valueType == 'CHECK_BOX'
                      ? CheckBoxListInputField(
                          hiddenFields: hiddenFields ?? {},
                          currentLanguage: currentLanguage,
                          inputField: inputField,
                          onInputValueChange: (id, value) {
                            onInputValueChange!(id, value);
                          },
                          dataObject: dataObject,
                        )
                      : inputField.options!.isNotEmpty
                          ? SelectInputField(
                              hiddenInputFieldOptions:
                                  hiddenInputFieldOptions[inputField.id] ?? {},
                              currentLanguage: currentLanguage,
                              color: inputField.inputColor,
                              sortOptions: inputField.sortOptions,
                              isReadOnly: inputField.isReadOnly,
                              renderAsRadio: inputField.renderAsRadio,
                              onInputValueChange: (dynamic value) =>
                                  onInputValueChange!(inputField.id, value),
                              options: inputField.options,
                              selectedOption: dataObject![inputField.id],
                            )
                          : inputField.valueType == 'TEXT' ||
                                  inputField.valueType == 'LONG_TEXT'
                              ? TextInputFieldContainer(
                                  inputField: inputField,
                                  lastUpdatedId: lastUpdatedId,
                                  inputValue: dataObject![inputField.id],
                                  onInputValueChange: (dynamic value) =>
                                      onInputValueChange!(inputField.id, value),
                                )
                              : inputField.valueType ==
                                          'INTEGER_ZERO_OR_POSITIVE' ||
                                      inputField.valueType == 'NUMBER'
                                  ? NumericalInputFieldContainer(
                                      inputField: inputField,
                                      lastUpdatedId: lastUpdatedId,
                                      inputValue: dataObject![inputField.id],
                                      onInputValueChange: (dynamic value) =>
                                          onInputValueChange!(
                                              inputField.id, value),
                                    )
                                  : inputField.valueType == 'PHONE_NUMBER'
                                      ? PhoneNumberInputFieldContainer(
                                          inputField: inputField,
                                          lastUpdatedId: lastUpdatedId,
                                          inputValue:
                                              dataObject![inputField.id],
                                          onInputValueChange: (dynamic value) =>
                                              onInputValueChange!(
                                                  inputField.id, value),
                                        )
                                      : inputField.valueType == 'BOOLEAN'
                                          ? BooleanInputFieldContainer(
                                              currentLanguage: currentLanguage,
                                              inputField: inputField,
                                              inputValue:
                                                  dataObject![inputField.id],
                                              onInputValueChange:
                                                  (dynamic value) =>
                                                      onInputValueChange!(
                                                          inputField.id, value),
                                            )
                                          : inputField.valueType == 'TRUE_ONLY'
                                              ? TrueOnlyInputFieldContainer(
                                                  currentLanguage:
                                                      currentLanguage,
                                                  inputField: inputField,
                                                  inputValue: dataObject![
                                                      inputField.id],
                                                  onInputValueChange:
                                                      (dynamic value) =>
                                                          onInputValueChange!(
                                                              inputField.id,
                                                              value),
                                                )
                                              : inputField.valueType == 'DATE'
                                                  ? DateInputFieldContainer(
                                                      inputField: inputField,
                                                      lastUpdatedId:
                                                          lastUpdatedId,
                                                      currentLanguage:
                                                          currentLanguage,
                                                      inputValue: dataObject![
                                                          inputField.id],
                                                      onInputValueChange:
                                                          (dynamic value) =>
                                                              onInputValueChange!(
                                                                  inputField.id,
                                                                  value),
                                                    )
                                                  : inputField.valueType ==
                                                          'ORGANISATION_UNIT'
                                                      ? OrganisationUnitInputFieldContainer(
                                                          inputField:
                                                              inputField,
                                                          isEditableMode:
                                                              isEditableMode!,
                                                          currentUserCountryLevelReferences:
                                                              currentUserCountryLevelReferences,
                                                          filteredPrograms:
                                                              inputField
                                                                  .filteredPrograms,
                                                          inputValue:
                                                              dataObject![
                                                                  inputField
                                                                      .id],
                                                          onInputValueChange:
                                                              (dynamic value) =>
                                                                  onInputValueChange!(
                                                                      inputField
                                                                          .id,
                                                                      value),
                                                        )
                                                      : inputField.valueType ==
                                                              'COORDINATE'
                                                          ? CoordinateInputFieldContainer(
                                                              inputField:
                                                                  inputField,
                                                              inputValue:
                                                                  dataObject![
                                                                      inputField
                                                                          .id],
                                                              onInputValueChange: (dynamic
                                                                      value) =>
                                                                  onInputValueChange!(
                                                                      inputField
                                                                          .id,
                                                                      value),
                                                            )
                                                          : Text(
                                                              '${inputField.valueType} is not supported',
                                                            ),
                ),
                InputClearIcon(
                    showClearIcon: dataObject![inputField.id] != null &&
                        dataObject![inputField.id] != '' &&
                        inputField.isReadOnly == false &&
                        showClearIcon &&
                        isEditableMode!,
                    onClearInput: () {
                      onInputValueChange!(inputField.id, null);
                    })
              ],
            )
          : const Text(''),
    );
  }
}
