import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_lbse/constants/lbse_intervention_constant.dart';

class EducationLbseLearningOutcomeForm {
  static List<String> getMandatoryField() {
    return ['kuMzFGnDULh', 'mm5ZvlsZ6Sx', 'pKF9sVeUuuE'];
  }

  static List<FormSection> getFormSections() {
    return [
      FormSection(
        name: 'Learning Outcome',
        translatedName: 'Sephetho sa boithuto',
        color: const Color(0xFF009688),
        inputFields: [
          InputField(
            id: LbseInterventionConstant.serviceProvider,
            name: "Name of Service Provider",
            translatedName: "Lebitso la Mofani oa lits'ebeletso",
            isReadOnly: true,
            valueType: 'TEXT',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'kuMzFGnDULh',
            name: 'Theme',
            translatedName: 'Sehlooho',
            valueType: 'TEXT',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Theme 1',
                  name: 'Knowing oneself and relating with others',
                  translatedName: 'Ho itseba le ho sebelisana le ba bang'),
              InputFieldOption(
                  code: 'Theme 2',
                  name: 'Human rights and child protection',
                  translatedName: 'Litokelo tsa botho le tšireletso ea bana'),
              InputFieldOption(
                  code: 'Theme 3',
                  name: 'Gender norms and gender equality',
                  translatedName: 'Litloaelo tsa bong le tekano ea bong'),
              InputFieldOption(
                  code: 'Theme 4',
                  name: 'Sexual and Reproductive Health',
                  translatedName: 'Bophelo bo botle ba thobalano le ho beleha'),
              InputFieldOption(
                  code: 'Theme 5',
                  name: 'HIV and AIDS and STIs',
                  translatedName: 'HIV le AIDS le mafu a likobo'),
              InputFieldOption(
                  code: 'Theme 6',
                  name: 'Drugs, Substance and alcohol abuse',
                  translatedName:
                      'Lithethefatsi, tlhekefetso ea lithethefatsi le joala'),
            ],
          ),
          InputField(
            id: 'mm5ZvlsZ6Sx',
            name: 'Learning outcome',
            translatedName: 'Sephetho sa boithuto',
            valueType: 'TEXT',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                code: 'LO1',
                name: 'LO1',
              ),
              InputFieldOption(
                code: 'LO2',
                name: 'LO2',
              ),
              InputFieldOption(
                code: 'LO3',
                name: 'LO3',
              ),
              InputFieldOption(
                code: 'LO4',
                name: 'LO4',
              ),
              InputFieldOption(
                code: 'LO5',
                name: 'LO5',
              ),
              InputFieldOption(
                code: 'LO6',
                name: 'LO6',
              ),
              InputFieldOption(
                code: 'LO7',
                name: 'LO7',
              ),
              InputFieldOption(
                code: 'LO8',
                name: 'LO8',
              ),
              InputFieldOption(
                code: 'LO9',
                name: 'LO9',
              ),
              InputFieldOption(
                code: 'LO10',
                name: 'LO10',
              ),
              InputFieldOption(
                code: 'LO11',
                name: 'LO11',
              ),
              InputFieldOption(
                code: 'LO12',
                name: 'LO12',
              ),
              InputFieldOption(
                code: 'LO15',
                name: 'LO15',
              ),
              InputFieldOption(
                code: 'LO16',
                name: 'LO16',
              ),
              InputFieldOption(
                code: 'LO18',
                name: 'LO18',
              ),
              InputFieldOption(
                code: 'LO21',
                name: 'LO21',
              ),
              InputFieldOption(
                code: 'LO22',
                name: 'LO22',
              ),
              InputFieldOption(
                code: 'LO25',
                name: 'LO25',
              ),
              InputFieldOption(
                code: 'LO26',
                name: 'LO26',
              ),
              InputFieldOption(
                code: 'LO32',
                name: 'LO32',
              ),
              InputFieldOption(
                code: 'LO33',
                name: 'LO33',
              ),
              InputFieldOption(
                code: 'LO34',
                name: 'LO34',
              ),
            ],
          ),
          InputField(
            id: 'pKF9sVeUuuE',
            name: 'Mode',
            translatedName: 'Mokhoa oa ho hlahloba',
            valueType: 'TEXT',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Face to face',
                  name: 'Face to face',
                  translatedName: 'Sefahleho sefahleho'),
              InputFieldOption(
                  code: 'Virtual',
                  name: 'Virtual',
                  translatedName: 'Ka marangrang')
            ],
          ),
          InputField(
            id: 'WJOfRtIYU2p',
            name: 'Comment',
            translatedName: 'Maikutlo',
            valueType: 'LONG_TEXT',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
    ];
  }
}
