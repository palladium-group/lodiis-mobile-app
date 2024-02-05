import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/core/constants/beneficiary_identification.dart';
import 'package:kb_mobile_app/core/constants/user_account_reference.dart';
import 'package:kb_mobile_app/core/offline_db/enrollment_offline/enrollment_offline_provider.dart';
import 'package:kb_mobile_app/core/offline_db/event_offline/event_offline_provider.dart';
import 'package:kb_mobile_app/core/offline_db/tei_relationship_offline/tei_relationship_offline_provider.dart';
import 'package:kb_mobile_app/core/offline_db/tracked_entity_instance_offline/tracked_entity_instance_offline_provider.dart';
import 'package:kb_mobile_app/core/services/organisation_unit_service.dart';
import 'package:kb_mobile_app/core/services/reserved_attribute_value_service.dart';
import 'package:kb_mobile_app/core/utils/app_info_util.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/enrollment.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';
import 'package:kb_mobile_app/models/organisation_unit.dart';
import 'package:kb_mobile_app/models/tei_relationship.dart';
import 'package:kb_mobile_app/models/tracked_entity_instance.dart';
import 'package:provider/provider.dart';

class FormUtil {
  static bool hasAllMandatoryFieldsFilled(
    List mandatoryFields,
    Map dataDynamic, {
    required List<InputField> checkBoxInputFields,
    required Map hiddenFields,
  }) {
    bool hasMandoryFieldCheckPass = true;
    List inputFieldWithData = dataDynamic.keys.toList();
    List hiddenFieldsIds = hiddenFields.keys
        .toList()
        .where((key) => hiddenFields[key] == true)
        .toList();
    List checkBoxInputFieldIds = checkBoxInputFields
        .map((InputField inputField) => inputField.id)
        .toSet()
        .toList();
    List filteredMandatoryFields = mandatoryFields
        .where((field) => !hiddenFieldsIds.contains(field))
        .toList();

    for (var mandatoryField in filteredMandatoryFields) {
      if (!inputFieldWithData.contains(mandatoryField)) {
        if (checkBoxInputFieldIds.contains(mandatoryField)) {
          bool hasAtLeastOneInputFieldFilled = isAtLeastOneCheckBoxTicked(
            checkBoxInputFields
                .where(
                    (InputField inputField) => inputField.id == mandatoryField)
                .toList(),
            dataDynamic,
          );
          if (!hasAtLeastOneInputFieldFilled) {
            hasMandoryFieldCheckPass = false;
          }
        } else {
          hasMandoryFieldCheckPass = false;
        }
      } else {
        if ('${dataDynamic[mandatoryField]}'.trim() == '' ||
            '${dataDynamic[mandatoryField]}'.trim() == 'null') {
          if (checkBoxInputFieldIds.contains(mandatoryField)) {
            bool hasAtLeastOneInputFieldFilled = isAtLeastOneCheckBoxTicked(
              checkBoxInputFields
                  .where((InputField inputField) =>
                      inputField.id == mandatoryField)
                  .toList(),
              dataDynamic,
            );
            if (!hasAtLeastOneInputFieldFilled) {
              hasMandoryFieldCheckPass = false;
            }
          } else {
            hasMandoryFieldCheckPass = false;
          }
        }
      }
    }
    return hasMandoryFieldCheckPass;
  }

  static bool isAtLeastOneCheckBoxTicked(
    List<InputField> checkBoxInputFields,
    Map dataDynamic,
  ) {
    bool hasAtLeastOneInputFieldFilled = false;
    List<String> ids = [];
    for (InputField inputField in checkBoxInputFields) {
      ids.addAll((inputField.options ?? [])
          .map((InputFieldOption option) => '${option.code}')
          .toList());
    }
    for (String key in dataDynamic.keys.where((key) => ids.contains(key))) {
      dynamic value = dataDynamic[key];
      if ("$value".trim().isNotEmpty && "$value".trim() != 'null') {
        hasAtLeastOneInputFieldFilled = true;
      }
    }
    return hasAtLeastOneInputFieldFilled;
  }

  static List getUnFilledMandatoryFields(
    List mandatoryFields,
    Map dataDynamic, {
    required List<InputField> checkBoxInputFields,
    required Map hiddenFields,
  }) {
    List unFilledMandatoryFields = [];
    List fieldIds = dataDynamic.keys.toList();
    List hiddenFieldsIds = hiddenFields.keys
        .toList()
        .where((key) => hiddenFields[key] == true)
        .toList();
    List checkBoxInputFieldIds = checkBoxInputFields
        .map((InputField inputField) => inputField.id)
        .toSet()
        .toList();
    List filteredMandatoryFields = mandatoryFields
        .where((field) => !hiddenFieldsIds.contains(field))
        .toList();
    for (var mandatoryField in filteredMandatoryFields) {
      if (!fieldIds.contains(mandatoryField)) {
        if (checkBoxInputFieldIds.contains(mandatoryField)) {
          bool hasAtLeastOneInputFieldFilled = isAtLeastOneCheckBoxTicked(
            checkBoxInputFields
                .where(
                    (InputField inputField) => inputField.id == mandatoryField)
                .toList(),
            dataDynamic,
          );
          if (!hasAtLeastOneInputFieldFilled) {
            unFilledMandatoryFields.add(mandatoryField);
          }
        } else {
          unFilledMandatoryFields.add(mandatoryField);
        }
      } else {
        if ('${dataDynamic[mandatoryField]}'.trim() == '' ||
            '${dataDynamic[mandatoryField]}'.trim() == 'null') {
          if (checkBoxInputFieldIds.contains(mandatoryField)) {
            bool hasAtLeastOneInputFieldFilled = isAtLeastOneCheckBoxTicked(
              checkBoxInputFields
                  .where((InputField inputField) =>
                      inputField.id == mandatoryField)
                  .toList(),
              dataDynamic,
            );
            if (!hasAtLeastOneInputFieldFilled) {
              unFilledMandatoryFields.add(mandatoryField);
            }
          } else {
            unFilledMandatoryFields.add(mandatoryField);
          }
        }
      }
    }
    return unFilledMandatoryFields;
  }

  static bool getAtLeastOneFormFieldsFilledStatus(
    List fields,
    Map dataDynamic,
  ) {
    List unFilledFields = [];
    List fieldIds = dataDynamic.keys.toList();
    for (var field in fields) {
      if (!fieldIds.contains(field)) {
        unFilledFields.add(field);
      } else {
        if ('${dataDynamic[field]}'.trim() == '' ||
            '${dataDynamic[field]}'.trim() == 'null') {
          unFilledFields.add(field);
        }
      }
    }
    return unFilledFields.length < fields.length;
  }

  static List<InputField> getInputFieldByValueType({
    required String valueType,
    required List<FormSection> formSections,
  }) {
    List<InputField> inputFields = [];
    for (FormSection formSection in formSections) {
      if (formSection.inputFields!.isNotEmpty) {
        inputFields.addAll(formSection.inputFields!
            .where((InputField inputField) => inputField.valueType == valueType)
            .toList());
      }
      if (formSection.subSections!.isNotEmpty) {
        inputFields.addAll(getInputFieldByValueType(
          valueType: valueType,
          formSections: formSection.subSections!,
        ));
      }
    }
    return inputFields;
  }

  static List<String> getInputFieldIdsByValueType({
    required String valueType,
    required List<FormSection> formSections,
  }) {
    return getInputFieldByValueType(
      valueType: valueType,
      formSections: formSections,
    ).map((InputField inputField) => inputField.id).toList();
  }

  static hasAtLeastOnFieldFilled({
    required Map hiddenFields,
    required List<FormSection> formSections,
    required Map dataObject,
  }) {
    bool hasAtLeastOneInputFieldFilled = false;
    List hiddenFieldIds = [];
    for (String key in hiddenFields.keys) {
      if (hiddenFields[key]) {
        hiddenFieldIds.add(key);
      }
    }
    List ids = FormUtil.getFormFieldIds(formSections)
        .where((element) => !hiddenFieldIds.contains(element))
        .toList();
    for (String key in dataObject.keys.where((key) => ids.contains(key))) {
      dynamic value = dataObject[key];
      if ("$value".trim().isNotEmpty) {
        hasAtLeastOneInputFieldFilled = true;
      }
    }
    return hasAtLeastOneInputFieldFilled;
  }

  static updateServiceFormState(
    BuildContext context,
    bool isEditableMode,
    Events? eventData,
  ) {
    Provider.of<ServiceFormState>(context, listen: false).resetFormState();
    Provider.of<ServiceFormState>(context, listen: false)
        .updateFormEditabilityState(isEditableMode: isEditableMode);
    if (eventData != null) {
      Provider.of<ServiceFormState>(context, listen: false)
          .setFormFieldState('eventDate', eventData.eventDate);
      Provider.of<ServiceFormState>(context, listen: false)
          .setFormFieldState('eventId', eventData.event);
      Provider.of<ServiceFormState>(context, listen: false)
          .setFormFieldState('location', eventData.orgUnit);
      for (Map dataValue in eventData.dataValues) {
        if (dataValue['value'] != '') {
          Provider.of<ServiceFormState>(context, listen: false)
              .setFormFieldState(dataValue['dataElement'], dataValue['value']);
        }
      }
    }
  }

  static List<FormSection> getFormSectionWithReadOnlyStatus(
    List<FormSection> formSections,
    bool isReadOnly,
    List<String> skippedInputs,
  ) {
    List<FormSection> sanitizedFormSections = [];
    for (FormSection formSection in formSections) {
      List<InputField> inputFields = getInputFieldsWithStatus(
          formSection.inputFields!, isReadOnly, skippedInputs);
      List<FormSection> subSection = getFormSectionWithReadOnlyStatus(
          formSection.subSections!, isReadOnly, skippedInputs);
      formSection.inputFields = inputFields;
      formSection.subSections = subSection;
      sanitizedFormSections.add(formSection);
    }
    return sanitizedFormSections;
  }

  static List<InputField> getInputFieldsWithStatus(
    List<InputField> inputFields,
    bool isReadOnly,
    List<String> skippedInputs,
  ) {
    return inputFields.map((InputField inputField) {
      if (inputField.id != '' && !skippedInputs.contains(inputField.id)) {
        inputField.isReadOnly = isReadOnly;
      }
      return inputField;
    }).toList();
  }

  static List<FormSection> getFlattenFormSections(
    List<FormSection> formSections,
  ) {
    List<FormSection> sections = [];
    for (FormSection formSection in formSections) {
      if (formSection.subSections!.isNotEmpty) {
        sections.addAll(getFlattenFormSections(formSection.subSections!));
      }
      sections.add(formSection);
    }
    return sections;
  }

  static List<InputFieldOption> getFormFieldOptions(
    List<FormSection> formSections,
    String formSectionId,
    String inputFieldId,
  ) {
    List<InputFieldOption> inputFieldOptions = [];
    InputField? inputField = (formSections
                .firstWhereOrNull(
                    (formSection) => formSection.id == formSectionId)
                ?.inputFields ??
            [])
        .firstWhereOrNull((field) => field.id == inputFieldId);

    if (inputField != null) {
      for (InputFieldOption inputFieldOption in (inputField.options ?? [])) {
        inputFieldOptions.add(inputFieldOption);
      }
    }
    return inputFieldOptions;
  }

  static List<String> getAllFormSectionInpiutFields(
    List<FormSection> formSections,
  ) {
    List<String> fieldIds = [];
    for (FormSection formSection in formSections) {
      for (InputField inputField in formSection.inputFields!) {
        if (inputField.id != '') {
          fieldIds.add(inputField.id);
        }
      }
      List<String> subSectionFormFields =
          getAllFormSectionInpiutFields(formSection.subSections!);
      fieldIds.addAll(subSectionFormFields);
    }
    return fieldIds.toSet().toList();
  }

  static List<String> getFormFieldIds(
    List<FormSection> formSections, {
    bool includeLocationId = false,
  }) {
    List<String> fieldIds = [];
    for (FormSection formSection in formSections) {
      for (InputField inputField in formSection.inputFields!) {
        if (inputField.id != '' && inputField.valueType != 'CHECK_BOX') {
          fieldIds.add(inputField.id);
        }
        if (inputField.valueType == 'CHECK_BOX') {
          for (var option in inputField.options!) {
            fieldIds.addAll([option.code, inputField.id]);
          }
        }
      }
      List<String> subSectionFormFields =
          getFormFieldIds(formSection.subSections!);
      fieldIds.addAll(subSectionFormFields);
    }
    return includeLocationId
        ? fieldIds
        : fieldIds.where((String id) => id != 'location').toList();
  }

  static bool geFormFilledStatus(
    Map dataObject,
    List<FormSection>? formSections,
  ) {
    bool isFormFilled = false;
    if (dataObject.keys.isNotEmpty) {
      List<String> inputFields = getFormFieldIds(formSections!);
      for (String id in inputFields) {
        if (dataObject.containsKey(id) && '${dataObject[id]}'.trim() != '') {
          isFormFilled = true;
        }
      }
    }
    return isFormFilled;
  }

  static List<InputField> getFormInputFields(List<FormSection> formSections) {
    List<InputField> inputFields = [];
    for (FormSection formSection in formSections) {
      List<InputField> subSectionFormFields =
          getFormInputFields(formSection.subSections!);
      inputFields.addAll(formSection.inputFields!);
      inputFields.addAll(subSectionFormFields);
    }
    return inputFields;
  }

  static Future<TrackedEntityInstance> geTrackedEntityInstanceEnrollmentPayLoad(
    String? trackedEntityInstance,
    String trackedEntityType,
    String? orgUnit,
    List<String> inputFieldIds,
    Map dataObject, {
    bool hasBeneficiaryId = true,
    List<String> skippedFields = const ['enrollmentDate', 'location'],
  }) async {
    inputFieldIds.removeWhere((field) => skippedFields.contains(field));
    trackedEntityInstance = trackedEntityInstance ?? AppUtil.getUid();
    String appAndDeviceTrackingAttribute =
        await AppInfoUtil.getAppAndDeviceTrackingInfo();
    String? beneficiaryIndex =
        dataObject[BeneficiaryIdentification.beneficiaryIndex] ??
            await ReservedAttributeValueService().getReservedAttributeValue();
    List<OrganisationUnit> organisationUnits =
        await OrganisationUnitService().getOrganisationUnits([orgUnit]);
    OrganisationUnit? organisationUnit =
        organisationUnits.isNotEmpty ? organisationUnits[0] : null;
    dataObject[UserAccountReference.appAndDeviceTrackingAttribute] =
        dataObject[UserAccountReference.appAndDeviceTrackingAttribute] ??
            appAndDeviceTrackingAttribute;
    inputFieldIds.add(UserAccountReference.appAndDeviceTrackingAttribute);
    if (hasBeneficiaryId) {
      dataObject[BeneficiaryIdentification.beneficiaryId] =
          dataObject[BeneficiaryIdentification.beneficiaryId] =
              dataObject[BeneficiaryIdentification.beneficiaryIndex] != null
                  ? dataObject[BeneficiaryIdentification.beneficiaryId]
                  : BeneficiaryIdentification().getBeneficiaryId(
                      organisationUnit!, dataObject, beneficiaryIndex);
      dataObject[BeneficiaryIdentification.beneficiaryIndex] = beneficiaryIndex;
    }

    String attributes = inputFieldIds
        .toSet()
        .toList()
        .map((String attribute) {
          String value = dataObject.keys.toList().contains(attribute)
              ? '${dataObject[attribute]}'.trim()
              : '';
          value = value == "null" ? '' : value;
          return attribute != ''
              ? '{"attribute": "$attribute", "value": "$value"}'
              : '';
        })
        .toList()
        .where((String attributeObj) => attributeObj.isNotEmpty)
        .toList()
        .join(',');
    dynamic trackedEntityInstanceJson =
        '{"trackedEntityInstance":"$trackedEntityInstance", "trackedEntityType":"$trackedEntityType", "orgUnit":"$orgUnit","syncStatus":"not-synced","attributes":[$attributes] }';
    return TrackedEntityInstance()
        .fromJson(json.decode(trackedEntityInstanceJson));
  }

  static Enrollment getEnrollmentPayLoad(
    String? enrollment,
    String? enrollmentDate,
    String? incidentDate,
    String? orgUnit,
    String program,
    String? trackedEntityInstance,
    Map? dataObject,
  ) {
    enrollment = enrollment ?? AppUtil.getUid();
    enrollmentDate =
        enrollmentDate ?? AppUtil.formattedDateTimeIntoString(DateTime.now());
    incidentDate =
        incidentDate ?? AppUtil.formattedDateTimeIntoString(DateTime.now());
    String searchableValue =
        dataObject != null ? _getSearchableFieldFromDataObject(dataObject) : '';
    dynamic enrollmentJson =
        '{"enrollment":"$enrollment", "enrollmentDate":"$enrollmentDate","incidentDate":"$incidentDate","orgUnit":"$orgUnit","program":"$program","trackedEntityInstance":"$trackedEntityInstance","status":"ACTIVE","syncStatus":"not-synced", "searchableValue":"$searchableValue" }';
    return Enrollment().fromJson(json.decode(enrollmentJson));
  }

  static String _getSearchableFieldFromDataObject(Map dataObjet) {
    String searchableField = '';

    List<String> searchableFields = [
      'WTZ7GLTrE8Q',
      's1HaiT6OllL',
      'rSP9c21JsfC',
      'VJiWumvINR6',
      UserAccountReference.implementingPartnerAttribute,
      BeneficiaryIdentification.beneficiaryId,
      BeneficiaryIdentification.primaryUIC,
      BeneficiaryIdentification.secondaryUIC,
    ];

    for (String field in searchableFields) {
      if (dataObjet[field] != null) {
        searchableField += '${dataObjet[field]} ';
      }
    }
    return searchableField.trim();
  }

  static TeiRelationship getTeiRelationshipPayload(
    String relationshipType,
    String? fromTei,
    String toTei,
  ) {
    String id = AppUtil.getUid();
    dynamic source =
        '{"id":"$id","relationshipType":"$relationshipType","toTei":"$toTei", "fromTei":"$fromTei", "syncStatus": "not-synced"}';
    return TeiRelationship().fromJson(json.decode(source));
  }

  static Events getEventPayload(
    String? event,
    String? program,
    String? programStage,
    String? orgUnit,
    List<String> inputFieldIds,
    Map? dataObject,
    String? eventDate,
    String? trackedEntityInstance,
  ) {
    event = event ?? AppUtil.getUid();
    trackedEntityInstance = trackedEntityInstance ?? '';
    eventDate =
        eventDate ?? AppUtil.formattedDateTimeIntoString(DateTime.now());
    String dataValues = inputFieldIds
        .toSet()
        .toList()
        .map((String dataElement) {
          String value = dataObject!.keys.toList().contains(dataElement)
              ? '${dataObject[dataElement]}'.trim()
              : '';
          value = value == "null" ? '' : value;
          return dataElement != ''
              ? '{"dataElement": "$dataElement", "value": "$value"}'
              : '';
        })
        .toList()
        .where((String dataElementObj) => dataElementObj.isNotEmpty)
        .toList()
        .join(',');
    dynamic eventJson =
        '{"event" : "$event", "eventDate":"$eventDate",  "program":"$program", "programStage":"$programStage", "trackedEntityInstance":"$trackedEntityInstance", "status":"COMPLETED", "orgUnit":"$orgUnit", "syncStatus":"not-synced", "dataValues":[$dataValues] }';
    return Events().fromJson(json.decode(eventJson));
  }

  static Future savingTrackedEntityInstance(
    TrackedEntityInstance trackedEntityInstance,
  ) async {
    await TrackedEntityInstanceOfflineProvider()
        .addOrUpdateTrackedEntityInstance(trackedEntityInstance);
    await ReservedAttributeValueService().cleanUsedReservedAttributeValues();
  }

  static Future savingEnrollment(Enrollment enrollment) async {
    await EnrollmentOfflineProvider().addOrUpdateEnrollment(enrollment);
  }

  static Future savingTeiRelationship(TeiRelationship teiRelationship) async {
    await TeiRelationshipOfflineProvider()
        .addOrUpdateTeiRelationship(teiRelationship);
  }

  static Future savingEvent(Events event) async {
    await EventOfflineProvider().addOrUpdateEvent(event);
  }
}
