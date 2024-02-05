import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/device_connectivity_state/device_connectivity_state.dart';
import 'package:kb_mobile_app/app_state/referral_notification_state/referral_notification_state.dart';
import 'package:kb_mobile_app/core/services/implementing_partner_referral_config_service.dart';
import 'package:kb_mobile_app/core/services/organisation_unit_service.dart';
import 'package:kb_mobile_app/core/services/program_service.dart';
import 'package:kb_mobile_app/core/services/user_access.dart';
import 'package:kb_mobile_app/core/services/user_service.dart';
import 'package:kb_mobile_app/models/current_user.dart';
import 'package:provider/provider.dart';

class CurrentUserMetadataSync extends StatefulWidget {
  const CurrentUserMetadataSync({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  State<CurrentUserMetadataSync> createState() =>
      _CurrentUserMetadataSyncState();
}

class _CurrentUserMetadataSyncState extends State<CurrentUserMetadataSync> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    onSyncCurrentUserMetadata();
  }

  onSyncCurrentUserMetadata() async {
    bool? isOnline =
        Provider.of<DeviceConnectivityState>(context, listen: false)
            .connectivityStatus;
    if (isOnline!) {
      CurrentUser? user = await UserService().getCurrentUser();
      bool syncStatus = await UserService().getCurrentUserMetadataSyncStatus();
      if (!syncStatus) {
        var userAccessConfigurations =
            await UserAccess().getUserAccessConfigurationsFromTheServer(
          user?.username,
          user?.password,
        );
        await setCurrentUserAccess(user!, userAccessConfigurations);
        for (dynamic program in user.programs ?? []) {
          await ProgramService()
              .discoverProgramOrganisationUnitsFromTheServer("$program");
        }
        await OrganisationUnitService()
            .discoveringOrgananisationUnitsFromTheServer();
        await UserService().setCurrentUserMetadataSyncStatus(true);
      }
    }
    Timer(const Duration(milliseconds: 400), () {
      _isLoading = false;
      setState(() {});
    });
  }

  Future<void> setCurrentUserAccess(
    CurrentUser user,
    userAccessConfigurations,
  ) async {
    await UserService().setCurrentUser(user);
    await UserAccess().savingUserAccessConfigurations(userAccessConfigurations);
    Provider.of<CurrentUserState>(context, listen: false)
        .setCurrentUser(user, userAccessConfigurations);
    await Provider.of<ReferralNotificationState>(context, listen: false)
        .setCurrentImplementingPartner(user.implementingPartner!);
    await ImplementingPartnerReferralConfigService()
        .addImplementingPartnerReferralServices(user.username, user.password);
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _isLoading,
      child: Container(
        margin: const EdgeInsets.symmetric(),
        child: LinearProgressIndicator(
          color: widget.color,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
