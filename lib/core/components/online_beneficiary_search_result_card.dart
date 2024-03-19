import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/synchronization_state/synchronization_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/material_card.dart';
import 'package:kb_mobile_app/core/services/tracked_entity_instance_service.dart';
import 'package:kb_mobile_app/models/online_beneficiary_search_result.dart';
import 'package:provider/provider.dart';

class OnlineBeneficiarySearchResultCard extends StatefulWidget {
  final OnlineBeneficiarySearchResult searchResult;
  final Color? primaryColor;
  final Color? lineColor;

  const OnlineBeneficiarySearchResultCard(
      {Key? key, required this.searchResult, this.lineColor, this.primaryColor})
      : super(key: key);

  @override
  State<OnlineBeneficiarySearchResultCard> createState() =>
      _OnlineBeneficiarySearchResultCardState();
}

class _OnlineBeneficiarySearchResultCardState
    extends State<OnlineBeneficiarySearchResultCard> {
  bool downloading = false;
  bool downloaded = false;

  updateDownloadingStatus() {
    if (mounted) {
      setState(() {
        downloading = !downloading;
      });
    }
  }

  updateDownloadedStatus(bool status) {
    if (mounted) {
      setState(() {
        downloaded = status;
      });
    }
  }

  Future<void> onDownloadResult() async {
    updateDownloadingStatus();
    var teiId = widget.searchResult.id ?? '';
    try {
      await TrackedEntityInstanceService().discoverTrackedEntityInstanceById(
        teiId,
        shouldDownloadRelatedTei: true,
      );
      await Provider.of<SynchronizationState>(context, listen: false)
          .refreshBeneficiaryCounts();
      updateDownloadedStatus(true);
    } catch (e) {
      updateDownloadedStatus(false);
    } finally {
      updateDownloadingStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) => Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 15.0,
        ),
        child: MaterialCard(
            body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 15.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: Text(
                      widget.searchResult.toString(),
                      style: TextStyle(
                          color: widget.primaryColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: downloading
                          ? CircularProcessLoader(
                              color: widget.primaryColor,
                              height: 20.0,
                              width: 20.0,
                              size: 2,
                            )
                          : InkWell(
                              onTap: () =>
                                  {downloaded ? null : onDownloadResult()},
                              child: SizedBox(
                                height: 20.0,
                                width: 20.0,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: downloaded
                                      ? Icon(
                                          Icons.check,
                                          color: widget.primaryColor,
                                        )
                                      : Icon(
                                          Icons.download,
                                          color: widget.primaryColor,
                                        ),
                                ),
                              ),
                            ))
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 15.0,
                ),
                child: Column(
                  children: [
                    Visibility(
                        visible: widget.searchResult.primaryUIC != '',
                        child: SearchResultDetails(
                          label: 'Primary UIC',
                          value: widget.searchResult.primaryUIC!,
                          primaryColor: widget.primaryColor ?? Colors.blueGrey,
                        )),
                    Visibility(
                        visible: widget.searchResult.location != '',
                        child: SearchResultDetails(
                          label: 'Location',
                          value: widget.searchResult.location!,
                          primaryColor: widget.primaryColor ?? Colors.blueGrey,
                        )),
                    Visibility(
                        visible: widget.searchResult.sex != '',
                        child: SearchResultDetails(
                          label: 'Sex',
                          value: widget.searchResult.sex!,
                          primaryColor: widget.primaryColor ?? Colors.blueGrey,
                        )),
                    Visibility(
                        visible: widget.searchResult.dateOfBirth != '',
                        child: SearchResultDetails(
                          label: 'Date of Birth',
                          value: widget.searchResult.dateOfBirth!,
                          primaryColor: widget.primaryColor ?? Colors.blueGrey,
                        )),
                    Visibility(
                        visible: widget.searchResult.program != '',
                        child: SearchResultDetails(
                          label: languageState.currentLanguage == 'lesotho'
                              ? 'Lenaneo'
                              : 'Program',
                          value: widget.searchResult.program!,
                          primaryColor: widget.primaryColor ?? Colors.blueGrey,
                        )),
                  ],
                ))
          ],
        )),
      ),
    );
  }
}

class SearchResultDetails extends StatelessWidget {
  final String label;
  final String? translatedLabel;
  final String value;
  final Color primaryColor;
  const SearchResultDetails(
      {Key? key,
      required this.label,
      required this.value,
      this.translatedLabel,
      required this.primaryColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? currentLanguage =
        Provider.of<LanguageTranslationState>(context, listen: false)
            .currentLanguage;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              currentLanguage == 'lesotho' ? translatedLabel ?? label : label,
              style: const TextStyle().copyWith(
                color: primaryColor.withOpacity(0.6),
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle().copyWith(
                color: primaryColor.withOpacity(0.9),
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }
}
