class OvcChildServiceHomeConstant {
  String? id;
  String? title;
  String? translatedTitle;
  String? icon;
  bool? groupByDate;
  List<String>? programStages;
  List<String>? groupingProgramStages;

  OvcChildServiceHomeConstant(
      {this.id,
      this.title,
      this.translatedTitle,
      this.icon,
      this.programStages,
      this.groupByDate,
      this.groupingProgramStages}) {
    programStages = programStages ?? [];
    groupByDate = groupByDate ?? false;
    groupingProgramStages =
        groupByDate == true ? groupingProgramStages ?? programStages : [];
  }

  static List<OvcChildServiceHomeConstant> getOvcChildServiceHomeConstant() {
    return [
      OvcChildServiceHomeConstant(
          id: 'assessment',
          title: 'Assessment',
          translatedTitle: 'Hlahlobo',
          icon: 'assets/icons/child_assessment_ovc_icon.svg',
          programStages: ['Pb1Gb4Aky92', 'GPg1J1xIHT6', 'RJTRRO0wg8H']),
      OvcChildServiceHomeConstant(
          id: 'casePlan',
          title: 'Case Plan',
          translatedTitle: 'moralo oa nyeoe',
          icon: 'assets/icons/child_case_plan_ovc_icon.svg',
          groupByDate: true,
          programStages: ['ZHjrdThi7Bz']),
      OvcChildServiceHomeConstant(
        id: 'services',
        title: 'Services',
        translatedTitle: 'Litsebeletso',
        icon: 'assets/icons/child_service_ovc_icon.svg',
        groupByDate: true,
        programStages: ['ZHjrdThi7Bz'],
      ),
      OvcChildServiceHomeConstant(
        id: 'clhiv_art',
        title: 'CLHIV ART Card Service',
        icon: 'assets/icons/clhiv_art_ovc_icon.svg',
        programStages: ['q5A4SXKzKV1'],
        groupingProgramStages: ['q5A4SXKzKV1'],
      ),
      OvcChildServiceHomeConstant(
        id: 'monitor',
        title: 'Monitor',
        translatedTitle: 'Etsa tlhahlobo e hlophisitsoeng',
        groupByDate: true,
        groupingProgramStages: ['ZHjrdThi7Bz'],
        icon: 'assets/icons/child_monitor_ovc_icon.svg',
        programStages: ['dVdlJNtNLIQ', 'ZHjrdThi7Bz'],
      )
    ];
  }
}
