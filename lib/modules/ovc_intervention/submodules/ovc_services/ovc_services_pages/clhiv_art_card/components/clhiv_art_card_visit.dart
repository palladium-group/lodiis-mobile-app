import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/core/components/material_card.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:provider/provider.dart';

class ClhivArtCardVisit extends StatelessWidget {
  const ClhivArtCardVisit({
    Key? key,
    required this.eventData,
    required this.visitName,
    this.visitCount,
    this.onView,
    this.onEdit,
    this.editDisabled,
  }) : super(key: key);

  final Events eventData;
  final Function? onView;
  final Function? onEdit;
  final int? visitCount;
  final String visitName;
  final bool? editDisabled;

  @override
  Widget build(BuildContext context) {
    double iconHeight = 20;
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 17.0,
      ),
      child: MaterialCard(
        body: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                      text: TextSpan(
                    text: '${eventData.eventDate}   ',
                    style: const TextStyle().copyWith(
                      color: const Color(0xFF82898D),
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
                  Expanded(
                    child: RichText(
                        text: TextSpan(
                      text: visitCount == null || visitCount == 0
                          ? visitName
                          : "$visitName ${visitCount.toString()}",
                      style: const TextStyle().copyWith(
                        color: const Color(0xFF05131B),
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                    ),
                    child: InkWell(
                      onTap: onView as void Function()?,
                      child: Container(
                        height: iconHeight,
                        width: iconHeight,
                        margin: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 5.0,
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/expand_icon.svg',
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF4B9F46),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Consumer<CurrentUserState>(
                    builder: (context, currentUserState, child) {
                      bool isKbFacilitySocialWorker =
                          currentUserState.isKbFacilitySocialWorker;
                      return Visibility(
                        visible:
                            isKbFacilitySocialWorker && editDisabled != true,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                          ),
                          child: InkWell(
                            onTap: editDisabled == true
                                ? () => AppUtil.showToastMessage(
                                      message:
                                          'This visit has been disabled for editing',
                                      position: ToastGravity.TOP,
                                    )
                                : onEdit as void Function()?,
                            child: Container(
                              height: iconHeight,
                              width: iconHeight,
                              margin: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 5,
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/edit-icon.svg',
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF4B9F46),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
