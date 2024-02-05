import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/core/constants/current_user_implementing_partner.dart';
import 'package:kb_mobile_app/models/current_user.dart';
import 'package:kb_mobile_app/modules/about_app/utils/about_page_util.dart';
import 'package:provider/provider.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';

class UserInfoContainer extends StatelessWidget {
  const UserInfoContainer({
    Key? key,
    required this.currentLanguage,
  }) : super(key: key);

  final String currentLanguage;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) => Consumer<CurrentUserState>(
        builder: (context, currentUserState, child) {
          CurrentUser? currentUser = currentUserState.currentUser;
          String currentUserLocations = currentUserState.currentUserLocations;
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: Text(
                  languageState.currentLanguage == 'lesotho'
                      ? 'Lintlha tsa mosebelisi'
                      : 'User Info',
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Table(
                    defaultColumnWidth: FixedColumnWidth(
                      size.width * 0.35,
                    ),
                    children: [
                      AboutPageUtil.getTableRowContent(
                        currentLanguage == 'lesotho'
                            ? 'Mabitso a feletseng'
                            : 'Full name',
                        currentUser?.name ?? "",
                      ),
                      AboutPageUtil.getTableRowContent(
                        currentLanguage == 'lesotho'
                            ? 'Lebitso la mosebelisi'
                            : 'username',
                        currentUser?.username ?? "",
                      ),
                      AboutPageUtil.getTableRowContent(
                        currentLanguage == 'lesotho' ? 'email' : 'email',
                        currentUser?.email ?? "",
                      ),
                      AboutPageUtil.getTableRowContent(
                        currentLanguage == 'lesotho'
                            ? 'Nomoro ea mohala'
                            : 'phone number',
                        currentUser?.phoneNumber ?? "",
                      ),
                      AboutPageUtil.getTableRowContent(
                        currentLanguage == 'lesotho'
                            ? 'Libaka tse abetsoeng'
                            : 'Assigned locations',
                        currentUserLocations,
                      ),
                      AboutPageUtil.getTableRowContent(
                        currentLanguage == 'lesotho'
                            ? 'Balekane ka hara morero'
                            : 'Implementing Partner',
                        currentUser?.implementingPartner ?? "",
                      ),
                      AboutPageUtil.getTableRowContent(
                        currentLanguage == 'lesotho'
                            ? 'Sub Balekane ka hara morero'
                            : 'Sub implementing Partner',
                        (currentUser?.subImplementingPartner ?? "")
                            .split(
                                CurrentUserImplementingPartner.crsPrefixValue)
                            .last
                            .trim(),
                      ),
                      AboutPageUtil.getTableRowContent(
                        currentLanguage == 'lesotho'
                            ? 'mesebetsi e abetsoeng '
                            : 'Assigned Roles',
                        currentUser?.userRoles ?? "",
                      ),
                      AboutPageUtil.getTableRowContent(
                        currentLanguage == 'lesotho'
                            ? 'Lihlopha tse abetsoeng'
                            : 'Assigned Groups',
                        currentUser?.userGroups ?? "",
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
