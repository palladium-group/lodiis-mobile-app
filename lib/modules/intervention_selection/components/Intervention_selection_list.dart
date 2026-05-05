
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/intervention_selection/components/Intervention_selection_card.dart';

class InterventionSelectionList extends StatefulWidget {
  const InterventionSelectionList({
    Key? key,
    required this.interventionPrograms,
    this.onInterventionSelection,
    required this.numberOfAgywDreamsBeneficiaries,
    required this.numberOfNoneAgywDreamsBeneficiaries,
    required this.numberOfHouseholds,
    required this.numberOfOvcs,
    required this.numberOfOgac,
    required this.numberPpPrev,
    required this.numberEducationLbse,
    required this.numberEducationBursary,

    // ✅ NEW
    required this.numberOfMgysdCases,
  }) : super(key: key);

  final List<InterventionCard> interventionPrograms;
  final Function(InterventionCard)? onInterventionSelection;

  final int numberOfNoneAgywDreamsBeneficiaries;
  final int numberOfAgywDreamsBeneficiaries;
  final int numberOfHouseholds;
  final int numberOfOvcs;
  final int numberOfOgac;
  final int numberPpPrev;
  final int numberEducationBursary;
  final int numberEducationLbse;

  // ✅ NEW
  final int numberOfMgysdCases;

  @override
  State<InterventionSelectionList> createState() =>
      _InterventionSelectionListState();
}

class _InterventionSelectionListState extends State<InterventionSelectionList> {
  String? interventionProgramId = '';

  void setSelectedCard(InterventionCard interventionProgram) {
    setState(() {
      interventionProgramId = interventionProgram.id;
    });

    if (widget.onInterventionSelection != null) {
      widget.onInterventionSelection!(interventionProgram);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.interventionPrograms
          .map(
            (InterventionCard interventionProgram) => GestureDetector(
          onTap: () => setSelectedCard(interventionProgram),
          child: InterventionSelectionCard(
            interventionProgram: interventionProgram,
            interventionProgramId: interventionProgramId,
            numberOfAgywDreamsBeneficiaries:
            widget.numberOfAgywDreamsBeneficiaries,
            numberOfNoneAgywDreamsBeneficiaries:
            widget.numberOfNoneAgywDreamsBeneficiaries,
            numberOfHouseholds: widget.numberOfHouseholds,
            numberOfOvcs: widget.numberOfOvcs,
            numberOfOgac: widget.numberOfOgac,
            numberPpPrev: widget.numberPpPrev,
            numberEducationLbse: widget.numberEducationLbse,
            numberEducationBursary: widget.numberEducationBursary,

            // ✅ NEW
            numberOfMgysdCases: widget.numberOfMgysdCases,
          ),
        ),
      )
          .toList(),
    );
  }
}

