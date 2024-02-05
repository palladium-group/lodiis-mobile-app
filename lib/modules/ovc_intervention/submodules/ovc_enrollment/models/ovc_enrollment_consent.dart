import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_intervention_constant.dart';

class OvcEnrollmentConsent {
  static List<String> getMandatoryField() {
    return [
      'location',
      'enrollmentDate',
      'OVaqHW5kimy',
      'JCI4nxcE4N6',
      'XVRQaLDDSpx',
      'gCdkCgKJhng',
      'fxqfSmoLBvT',
      'R026OBBkvLi',
      'MP7ROUSWfT9',
      'sCGr0RTmvJ7'
    ];
  }

  static List<FormSection> getFormSections() {
    return [
      FormSection(name: '', color: const Color(0xFF737373), inputFields: [
        InputField(
          id: 'location',
          name: 'Location',
          translatedName: 'Sebaka',
          valueType: 'ORGANISATION_UNIT',
          allowedSelectedLevels: [
            AppHierarchyReference.communityLevel,
            AppHierarchyReference.facilityLevel
          ],
          filteredPrograms: [
            OvcInterventionConstant.ovcProgramprogram,
            OvcInterventionConstant.caregiverProgram,
          ],
          inputColor: const Color(0xFF4B9F46),
          labelColor: const Color(0xFF737373),
        ),
        InputField(
          id: 'enrollmentDate',
          isReadOnly: false,
          inputColor: const Color(0xFF4B9F46),
          labelColor: const Color(0xFF737373),
          name: 'Date of Enrollment to Program',
          translatedName: "Letsatsi leo lelapa le keneng ka hara morero",
          valueType: 'DATE',
          allowFuturePeriod: false,
        ),
        InputField(
            id: 'OVaqHW5kimy',
            name:
                'Do you understand the goal of the KB OVC Program and its potential benefits to my household',
            translatedName:
                'Ke utloisisa sepheo sa morero oa bana ba tlokotsing ba Karabo ea Bophelo le melemo ea eona ho lelapa laka',
            valueType: 'BOOLEAN',
            labelColor: const Color(0xFF1A3518),
            inputColor: const Color(0xFF4B9F46)),
        InputField(
            id: 'JCI4nxcE4N6',
            name:
                'Does your household agrees to regularly meet with CMW to discuss issues faced, set goals for future, and plan how to achieve those goals?',
            translatedName:
                'Lelapa leso le lumela ho kopana khafetsa le Case Management Worker ho buisana ka mathata ao re tobaneng le ona, ho ipehela lipheo tsa bokamoso ba rona, le hore na re ka fihlela sepheo seo joang, re sebetsa \'moho ho fihlela re fihlela sepheo sa rona?',
            valueType: 'BOOLEAN',
            labelColor: const Color(0xFF1A3518),
            inputColor: const Color(0xFF4B9F46)),
        InputField(
            id: 'XVRQaLDDSpx',
            name:
                'Do you allow your information to be stored in a Case Management Information System ',
            translatedName:
                'Ke lumela hore litaba tsa rona li bolokoe ke morero oa Karabo ea Bophelo sebakeng se bolokehileng. Sena se bolela hore Mokhatlo o sebetsang le uena o tla boloka litaba tsa hau tsohle tsa ts’ebetso, ‘mmoho le methati eohle e tla lateloa sebakeng se bolokehileng. Litaba tsa hau li ka arolelanoa feela le mekhatlo eo o faneng ka tumello.',
            valueType: 'BOOLEAN',
            labelColor: const Color(0xFF1A3518),
            inputColor: const Color(0xFF4B9F46)),
        InputField(
            id: 'gCdkCgKJhng',
            name:
                'Do you allow specific information on your household’s and child(ren) information to be shared with and discussed amongst (called case conferencing) the service provider(s) (organizations or groups).',
            translatedName:
                'Ke fana ka tumello ea hore litaba tse tobileng lelapa laka le bana baka li ka arolelanoa le ho buisanoa le mekhatlo e meng ho fana ka litsebeletso molemong oa ho ntlafatsa bophelo ba lelapa la ka le bana ba ka.',
            valueType: 'BOOLEAN',
            labelColor: const Color(0xFF1A3518),
            inputColor: const Color(0xFF4B9F46)),
        InputField(
            id: 'fxqfSmoLBvT',
            name:
                'Have you agreed to be referred to help you  and your family achieve our goals',
            translatedName:
                'ke lumetse hore ke fetisetsoe lits’ebeletsong tse ling ho thusa nna le lelapa laka ho fihlela sepheo sa rona. Kea utloisisa hore litaba tse arolelanoeng litla bolokoa ele lekunutu ka tlhompho \'me li arolelanoe feela ka mokhoa o hlokahalang ho fana ka thuso eo ke e kopang kapa eo ke e hlokang        ',
            valueType: 'BOOLEAN',
            labelColor: const Color(0xFF1A3518),
            inputColor: const Color(0xFF4B9F46)),
        InputField(
            id: 'R026OBBkvLi',
            name:
                'Do you understand that you can change your mind and decide not to share information',
            translatedName:
                'Kea utloisisa hore nka fetola maikutlo a ka mme ka etsa qeto ea ho se arolelane litaba',
            valueType: 'BOOLEAN',
            labelColor: const Color(0xFF1A3518),
            inputColor: const Color(0xFF4B9F46)),
        InputField(
            id: 'MP7ROUSWfT9',
            name:
                'Do you understand that in life-threatening or emergency situations your information will be shared with necessary authorities whether or not you have given consent',
            translatedName:
                'Kea utloisisa hore maemong a tlokotsi kapa a tšohanyetso, litaba tsa rona litla arolelanoa le ba boholong hore na ke fane ka tumello kapa che. (Maemo a ts’osang a bophelo kapa maemo a tšohanyetso a akaretsa empa ha felle feela maemong a tlhekefetso ea bana, ho loants’ana, ho ………… kapa ho hlekefetsoa.) ',
            valueType: 'BOOLEAN',
            labelColor: const Color(0xFF1A3518),
            inputColor: const Color(0xFF4B9F46)),
      ]),
      FormSection(name: '', color: const Color(0xFF737373), inputFields: [
        InputField(
            id: 'sCGr0RTmvJ7',
            name: 'Are you willing to be among beneficiaries of this program?',
            translatedName:
                'Na u ikemiselitse ho ba e mong oa bajalefa ba lenaneo lee?',
            valueType: 'BOOLEAN',
            labelColor: const Color(0xFF1A3518),
            inputColor: const Color(0xFF4B9F46))
      ])
    ];
  }
}
