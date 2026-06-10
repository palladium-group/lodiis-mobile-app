class BeneficiaryWithoutEnrollmentCriteriaConstant {
  String attribute;
  String dataElement;

  BeneficiaryWithoutEnrollmentCriteriaConstant({
    required this.attribute,
    required this.dataElement,
  });

  static List<BeneficiaryWithoutEnrollmentCriteriaConstant>
      getWithoutEnrollmentCriteriaConstants() {
    return <BeneficiaryWithoutEnrollmentCriteriaConstant>[];
  }

  // Backward-compatible method kept so shared offline providers still compile.
  static List<BeneficiaryWithoutEnrollmentCriteriaConstant>
      getLegacyWithoutEnrollmentCriteriaConstants() {
    return getWithoutEnrollmentCriteriaConstants();
  }
}
