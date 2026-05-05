
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_re_assessment_list_state.dart';
import 'package:kb_mobile_app/app_state/education_intervention_state/education_bursary_state.dart';
import 'package:kb_mobile_app/app_state/education_intervention_state/education_lbse_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ogac_intervention_list_state/ogac_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/pp_prev_intervention_state/pp_prev_intervention_state.dart';
import 'package:kb_mobile_app/app_state/referral_notification_state/referral_notification_state.dart';
import 'package:kb_mobile_app/app_state/synchronization_state/synchronization_status_state.dart';
import 'package:kb_mobile_app/core/constants/app_logs_constants.dart';
import 'package:kb_mobile_app/core/constants/device_tracking_constant.dart';
import 'package:kb_mobile_app/core/constants/pagination.dart';
import 'package:kb_mobile_app/core/offline_db/app_logs_offline/app_logs_offline_provider.dart';
import 'package:kb_mobile_app/core/services/device_tracking_service.dart';
import 'package:kb_mobile_app/core/services/implementing_partner_config_service.dart';
import 'package:kb_mobile_app/core/services/preference_provider.dart';
import 'package:kb_mobile_app/core/services/referral_notification_service.dart';
import 'package:kb_mobile_app/core/services/synchronization_service.dart';
import 'package:kb_mobile_app/core/services/user_service.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/app_logs.dart';
import 'package:kb_mobile_app/models/current_user.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/referral_notification.dart';
import 'package:kb_mobile_app/models/tracked_entity_instance.dart';
import 'package:kb_mobile_app/modules/synchronization/constants/synchronization_actions_constants.dart';
import 'package:provider/provider.dart';

class SynchronizationState with ChangeNotifier {
  final BuildContext? context;

  final String lastDataDownloadDatePreferenceKey = "lastSyncDatePreferenceKey";
  final String lastDataUploadDatePreferenceKey =
      "lastDataUploadDatePreferenceKey";

  final int dataUploadBatchSize = 50;

  SynchronizationState({this.context});

  bool _isDataUploadingActive = false;
  bool _isDataDownloadingActive = false;
  bool? _hasUnsyncedData;
  bool? _isDataAvailableForDownload;
  bool _isUnsyncedCheckingActive = true;
  bool? _isCheckingForAvailableDataFromServer;

  bool _dataUploadStopped = true;
  bool _dataDownloadStopped = true;

  int? _beneficiaryCount;
  int? _beneficiaryServiceCount;

  final int _conflictLCount = 0;

  String? _statusMessageForAvailableDataFromServer;
  String _currentSyncAction = '';

  double _notificationProgress = 0.0;
  double profileDataDownloadProgress = 0.0;
  double eventsDataDownloadProgress = 0.0;
  double overallDownloadProgress = 0.0;

  double profileDataUploadProgress = 0.0;
  double eventsDataUploadProgress = 0.0;
  double overallUploadProgress = 0.0;

  List<String>? _dataDownloadProcess;
  List<String>? _dataUploadProcess;

  List<Map<String, dynamic>>? _eventsWithConflicts;
  List<Map<String, dynamic>>? _trackedEntityInstancesWithConflicts;

  List<TrackedEntityInstance>? _trackedEntityInstance;
  List<Events>? _eventFromServer;

  List<dynamic>? _serverTrackedEntityInstance;
  Map<String, List>? _trackedInstance;
  Map<String, List>? _events;
  Map<String, List>? _relationships;

  Map? _synchronizationTrackingInfo;

  late SynchronizationService _synchronizationService;

  // selectors
  Map get synchronizationTrackingInfo => _synchronizationTrackingInfo ?? {};

  bool get isDataUploadingActive => _isDataUploadingActive;

  bool get isDataDownloadingActive => _isDataDownloadingActive;

  double get notificationProgress => _notificationProgress;

  double get overallSyncProgress =>
      _currentSyncAction == SynchronizationActionsConstants.downloadAndUpload
          ? (overallUploadProgress +
          overallDownloadProgress +
          notificationProgress) /
          3
          : ((overallUploadProgress + overallDownloadProgress) +
          notificationProgress) /
          2;

  double get eventsSyncProgress => _isDataUploadingActive
      ? eventsDataUploadProgress
      : _isDataDownloadingActive
      ? eventsDataDownloadProgress
      : 0.0;

  double get profileSyncProgress => _isDataUploadingActive
      ? profileDataUploadProgress
      : _isDataDownloadingActive
      ? profileDataDownloadProgress
      : 0.0;

  bool get isCheckingForAvailableDataFromServer =>
      _isCheckingForAvailableDataFromServer ?? false;

  String get statusMessageForAvailableDataFromServer =>
      _statusMessageForAvailableDataFromServer ?? '';

  String get currentSyncAction => _currentSyncAction;

  bool get hasUnsyncedData => _hasUnsyncedData ?? false;

  bool get isDataAvailableForDownload => _isDataAvailableForDownload ?? false;

  bool get isUnsyncedCheckingActive => _isUnsyncedCheckingActive;

  int get beneficiaryCount => _beneficiaryCount ?? 0;

  int get beneficiaryServiceCount => _beneficiaryServiceCount ?? 0;

  List<String> get dataUploadProcesses => _dataUploadProcess ?? [];

  List<String> get dataDownloadProcesses => _dataDownloadProcess ?? [];

  List<Events> get eventFromServer => _eventFromServer ?? [];

  int get conflictCount => _conflictLCount;

  List<TrackedEntityInstance> get trackedEntityInstanceFromServer =>
      _trackedEntityInstance ?? [];

  List<dynamic> get serverTrackedEntityInstance =>
      _serverTrackedEntityInstance ?? [];

  Map<String, List> get trackedInstance => _trackedInstance ?? {};

  Map<String, List> get events => _events ?? {};

  Map<String, List> get relationships => _relationships ?? {};

  List<Map<String, dynamic>> get eventsWithConflicts =>
      _eventsWithConflicts ?? [];

  List<Map<String, dynamic>> get trackedEntityInstancesWithConflicts =>
      _trackedEntityInstancesWithConflicts ?? [];

  // reducers
  void updateDataUploadStatus(bool status) {
    _isDataUploadingActive = status;
    notifyListeners();
  }

  void updateUnsyncedDataCheckingStatus(bool status) {
    _isUnsyncedCheckingActive = status;
    notifyListeners();
  }

  void updateStatusForAvailableDataFromServer({bool? status}) {
    _isCheckingForAvailableDataFromServer = status;
    notifyListeners();
  }

  void setStatusMessageForAvailableDataFromServer(String statusMessage) {
    _statusMessageForAvailableDataFromServer = statusMessage;
    notifyListeners();
  }

  void updateDataDownloadStatus(bool status) {
    _isDataDownloadingActive = status;
    notifyListeners();
  }

  double _clamp01(double v) => v.clamp(0.0, 1.0);

  double _withinProgress(int index, int total) {
    if (total <= 0) return 1.0;
    return _clamp01((index + 1) / total);
  }

  Future<void> _logError(String where, Object e) async {
    final log = AppLogs(
      type: AppLogsConstants.errorLogType,
      message: '$where: ${e.toString()}',
    );
    await AppLogsOfflineProvider().addLogs(log);
  }

  // ----------------------------
  // main methods
  // ----------------------------
  checkingForAvailableBeneficiaryData(BuildContext context) async {
    String currentLanguage =
        Provider.of<LanguageTranslationState>(context, listen: false)
            .currentLanguage;
    updateStatusForAvailableDataFromServer(status: true);
    setStatusMessageForAvailableDataFromServer(
        'Checking for available beneficiary data from server...');

    try {
      CurrentUser? currentUser = await (UserService().getCurrentUser());
      if (currentUser == null) {
        setStatusMessageForAvailableDataFromServer('');
        updateStatusForAvailableDataFromServer(status: false);
        return;
      }

      String? lastSyncDate = await PreferenceProvider.getPreferenceValue(
          lastDataDownloadDatePreferenceKey);
      lastSyncDate =
          lastSyncDate ?? AppUtil.formattedDateTimeIntoString(DateTime(2020));

      _synchronizationService = SynchronizationService(
        currentUser.username,
        currentUser.password,
        currentUser.programs,
        currentUser.userOrgUnitIds,
      );

      int onlineEnrollmentsCount = await _synchronizationService
          .getOnlineEnrollmentsCount(currentUser, lastSyncDate);
      int onlineEventsCount = await _synchronizationService
          .getOnlineEventsCount(currentUser, lastSyncDate);

      _isDataAvailableForDownload =
          onlineEnrollmentsCount > 0 || onlineEventsCount > 0;
      notifyListeners();

      setStatusMessageForAvailableDataFromServer(_isDataAvailableForDownload!
          ? currentLanguage == 'lesotho'
          ? "Lintlha tse ncha tsa mojalefa lia fumaneha"
          : 'New beneficiary data are available, try to sync!'
          : '');
    } catch (e) {
      await _logError('checkingForAvailableBeneficiaryData', e);
      setStatusMessageForAvailableDataFromServer('');
    }

    updateStatusForAvailableDataFromServer(status: false);
  }

  Future<void> startCheckingStatusOfUnsyncedData() async {
    CurrentUser? user = await (UserService().getCurrentUser());
    if (user == null) {
      _beneficiaryCount = 0;
      _beneficiaryServiceCount = 0;
      _hasUnsyncedData = false;
      updateUnsyncedDataCheckingStatus(false);
      return;
    }

    _synchronizationService = SynchronizationService(
      user.username,
      user.password,
      user.programs,
      user.userOrgUnitIds,
    );

    int unsyncedTeiCount = await _synchronizationService.getUnsyncedTeiCount();
    int unsyncedEventsCount =
    await _synchronizationService.getUnsyncedEventsCount();

    _beneficiaryServiceCount = unsyncedEventsCount;
    _beneficiaryCount = unsyncedTeiCount;
    _hasUnsyncedData = unsyncedEventsCount > 0 || unsyncedTeiCount > 0;

    updateUnsyncedDataCheckingStatus(false);
  }

  void setSynchronizationTrackingInformation(Map dataObjet) {
    _synchronizationTrackingInfo ??= {};

    if (dataObjet.keys.isEmpty) {
      _synchronizationTrackingInfo = {};
      notifyListeners();
      return;
    }

    for (dynamic key in dataObjet.keys.toList()) {
      _synchronizationTrackingInfo![key] = dataObjet[key];
    }
    notifyListeners();
  }

  stopSyncActivity() async {
    _isDataDownloadingActive = false;
    _isDataUploadingActive = false;
    _dataUploadStopped = true;
    _dataDownloadStopped = true;

    profileDataDownloadProgress = 0.0;
    eventsDataDownloadProgress = 0.0;
    overallDownloadProgress = 0.0;

    profileDataUploadProgress = 0.0;
    eventsDataUploadProgress = 0.0;
    overallUploadProgress = 0.0;

    _notificationProgress = 0.0;
    _currentSyncAction = '';
    notifyListeners();

    await refreshBeneficiaryCounts();
    await startCheckingStatusOfUnsyncedData(); // ✅ refresh numbers too
    notifyListeners();
  }

  Future startSyncActivity({String? syncAction}) async {
    Map syncTrackingObject = {};
    setSynchronizationTrackingInformation(syncTrackingObject);

    profileDataDownloadProgress = 0.0;
    eventsDataDownloadProgress = 0.0;
    overallDownloadProgress = 0.0;

    profileDataUploadProgress = 0.0;
    eventsDataUploadProgress = 0.0;
    overallUploadProgress = 0.0;

    _notificationProgress = 0.0;

    _currentSyncAction = syncAction ?? '';
    notifyListeners();

    syncTrackingObject[DeviceTrackingConstant.syncStartTime] =
        AppUtil.getDataAndTimeFormatFromDateTime(DateTime.now());
    syncTrackingObject[DeviceTrackingConstant.unSyncedEnrollment] =
        _beneficiaryCount;
    syncTrackingObject[DeviceTrackingConstant.unSyncedServices] =
        _beneficiaryServiceCount;

    setSynchronizationTrackingInformation(syncTrackingObject);

    switch (_currentSyncAction) {
      case SynchronizationActionsConstants.download:
        await startDataDownloadActivity();
        break;
      case SynchronizationActionsConstants.upload:
        await startDataUploadActivity();
        break;
      case SynchronizationActionsConstants.downloadAndUpload:
        if (hasUnsyncedData) {
          await startDataUploadActivity();
        }
        await startDataDownloadActivity();
        break;
      default:
        break;
    }

    await syncReferralNotifications();

    // ✅ CRITICAL FIX: always refresh unsynced values after sync finishes
    await startCheckingStatusOfUnsyncedData();
    notifyListeners();

    int unSyncedEnrollment =
        syncTrackingObject[DeviceTrackingConstant.unSyncedEnrollment] ?? 0;
    int unSyncedServices =
        syncTrackingObject[DeviceTrackingConstant.unSyncedServices] ?? 0;

    syncTrackingObject[DeviceTrackingConstant.syncEndTime] =
        AppUtil.getDataAndTimeFormatFromDateTime(DateTime.now());

    syncTrackingObject[DeviceTrackingConstant.syncedEnrollment] =
    unSyncedEnrollment > (_beneficiaryCount ?? 0)
        ? unSyncedEnrollment - (_beneficiaryCount ?? 0)
        : unSyncedEnrollment;

    syncTrackingObject[DeviceTrackingConstant.syncedServices] =
    unSyncedServices > (_beneficiaryServiceCount ?? 0)
        ? unSyncedServices - (_beneficiaryServiceCount ?? 0)
        : unSyncedServices;

    syncTrackingObject[DeviceTrackingConstant.unSyncedEnrollment] =
        _beneficiaryCount;
    syncTrackingObject[DeviceTrackingConstant.unSyncedServices] =
        _beneficiaryServiceCount;

    _dataDownloadProcess = [];
    _dataUploadProcess = [];

    updateDataDownloadStatus(false);
    updateDataUploadStatus(false);

    _currentSyncAction = '';
    setSynchronizationTrackingInformation(syncTrackingObject);
    notifyListeners();

    try {
      DeviceTrackingService().syncDeviceTrackingInfoOnSynchronization(
        dataObject: _synchronizationTrackingInfo ?? {},
      );
    } catch (_) {
      // ignore
    }
  }

  Future startDataDownloadActivity() async {
    profileDataDownloadProgress = 0.0;
    eventsDataDownloadProgress = 0.0;
    overallDownloadProgress = 0.0;

    _dataDownloadStopped = false;
    updateDataDownloadStatus(true);

    int count = 0;
    int totalCount = 0;

    try {
      String? lastSyncDate = await PreferenceProvider.getPreferenceValue(
          lastDataDownloadDatePreferenceKey);
      lastSyncDate =
          lastSyncDate ?? AppUtil.formattedDateTimeIntoString(DateTime(2020));

      CurrentUser? currentUser = await (UserService().getCurrentUser());
      if (currentUser == null) {
        updateDataDownloadStatus(false);
        AppUtil.showToastMessage(message: 'No active user session');
        return;
      }

      _synchronizationService = SynchronizationService(
        currentUser.username,
        currentUser.password,
        currentUser.programs,
        currentUser.userOrgUnitIds,
      );

      var implementingPartnerConfig = await ImplementingPartnerConfigService()
          .getImplementingPartnerConfigFromTheServer(
          currentUser.username, currentUser.password);

      List currentUserPrograms =
          implementingPartnerConfig[currentUser.implementingPartner] ?? [];

      final int orgUnitLen = _synchronizationService.orgUnitIds?.length ?? 0;
      final int programLen = (_synchronizationService.programs ?? [])
          .where((p) => currentUserPrograms.contains(p))
          .length;

      final int total = orgUnitLen * programLen;
      if (total == 0) {
        updateDataDownloadStatus(false);
        AppUtil.showToastMessage(
            message: 'No programs/org units configured for download');
        return;
      }

      // TEIs
      count = 0;
      for (String? orgUnitId in _synchronizationService.orgUnitIds ?? []) {
        for (String? program in (_synchronizationService.programs ?? [])
            .where((program) => currentUserPrograms.contains(program))) {
          if (_dataDownloadStopped) return;

          await _synchronizationService.getAndSaveTrackedInstanceFromServer(
              program, orgUnitId, lastSyncDate);

          count++;
          totalCount++;

          profileDataDownloadProgress = _clamp01(count / total);
          overallDownloadProgress = _clamp01(totalCount / (total * 2));
          notifyListeners();
        }
      }

      // Events
      count = 0;
      for (String? orgUnitId in _synchronizationService.orgUnitIds ?? []) {
        for (String? program in (_synchronizationService.programs ?? [])
            .where((program) => currentUserPrograms.contains(program))) {
          if (_dataDownloadStopped) return;

          await _synchronizationService.getAndSaveEventsFromServer(
              program, orgUnitId, lastSyncDate);

          count++;
          totalCount++;

          eventsDataDownloadProgress = _clamp01(count / total);
          overallDownloadProgress = _clamp01(totalCount / (total * 2));
          notifyListeners();
        }
      }

      await refreshBeneficiaryCounts();

      AppUtil.showToastMessage(
          message: 'Data has been successfully downloaded');
      setStatusMessageForAvailableDataFromServer('');

      lastSyncDate = AppUtil.formattedDateTimeIntoString(DateTime.now());
      await PreferenceProvider.setPreferenceValue(
          lastDataDownloadDatePreferenceKey, lastSyncDate);
    } catch (e) {
      _dataDownloadProcess = [];
      await _logError('startDataDownloadActivity', e);
      updateDataDownloadStatus(false);
      AppUtil.showToastMessage(message: 'Error downloading data');
    }
  }

  Future<bool> uploadProfileData({
    required CurrentUser currentUser,
  }) async {
    bool conflicts = false;

    const int phases = 3;
    int phaseDone = 0;

    void updateOverall() {
      overallUploadProgress =
          (profileDataUploadProgress + eventsDataUploadProgress) / 2;
      notifyListeners();
    }

    // TEIs
    var teiCount =
    await _synchronizationService.getOfflineTrackedEntityInstanceCount();
    if (teiCount > 0) {
      int totalPages =
      (teiCount / PaginationConstants.dataUploadPaginationLimit).ceil();
      for (int page = 0; page < totalPages; page++) {
        if (_dataUploadStopped) return conflicts;

        var teiChunk =
        await _synchronizationService.getTeisFromOfflineDb(page: page);

        bool conflictOnImport =
        await _synchronizationService.uploadTeisToTheServer(teiChunk);

        conflicts = conflicts || conflictOnImport;

        final within = _withinProgress(page, totalPages);
        profileDataUploadProgress =
            _clamp01((phaseDone + within) / phases.toDouble());
        updateOverall();
      }
    }
    phaseDone++;
    profileDataUploadProgress = _clamp01(phaseDone / phases.toDouble());
    updateOverall();

    // Enrollments
    var enrollmentCount =
    await _synchronizationService.getOfflineEnrollmentCount(currentUser);
    if (enrollmentCount > 0) {
      int totalPages =
      (enrollmentCount / PaginationConstants.dataUploadPaginationLimit)
          .ceil();
      for (int page = 0; page < totalPages; page++) {
        if (_dataUploadStopped) return conflicts;

        var enrollmentChunk = await _synchronizationService
            .getTeiEnrollmentFromOfflineDb(page: page);

        bool conflictOnImport = await _synchronizationService
            .uploadEnrollmentsToTheServer(enrollmentChunk);

        conflicts = conflicts || conflictOnImport;

        final within = _withinProgress(page, totalPages);
        profileDataUploadProgress =
            _clamp01((phaseDone + within) / phases.toDouble());
        updateOverall();
      }
    }
    phaseDone++;
    profileDataUploadProgress = _clamp01(phaseDone / phases.toDouble());
    updateOverall();

    // Relationships
    var relCount = await _synchronizationService.getOfflineRelationshipCount();
    if (relCount > 0) {
      int totalPages =
      (relCount / PaginationConstants.dataUploadPaginationLimit).ceil();
      for (int page = 0; page < totalPages; page++) {
        if (_dataUploadStopped) return conflicts;

        var relChunk = await _synchronizationService
            .getTeiRelationShipFromOfflineDb(page: page);

        bool conflictOnImport = await _synchronizationService
            .uploadTeiRelationToTheServer(relChunk);

        conflicts = conflicts || conflictOnImport;

        final within = _withinProgress(page, totalPages);
        profileDataUploadProgress =
            _clamp01((phaseDone + within) / phases.toDouble());
        updateOverall();
      }
    }
    phaseDone++;
    profileDataUploadProgress = _clamp01(phaseDone / phases.toDouble());
    updateOverall();

    return conflicts;
  }

  Future<bool> uploadServiceData({
    required CurrentUser currentUser,
  }) async {
    bool conflicts = false;

    var offlineEventCount =
    await _synchronizationService.getUnsyncedEventsCount();

    if (offlineEventCount > 0) {
      int totalPages =
      (offlineEventCount / PaginationConstants.dataUploadPaginationLimit)
          .ceil();

      for (int page = 0; page < totalPages; page++) {
        if (_dataUploadStopped) return conflicts;

        var teiEventChunk =
        await _synchronizationService.getTeiEventsFromOfflineDb(page: page);

        bool conflictOnImport = await _synchronizationService
            .uploadTeiEventsToTheServer(teiEventChunk);

        conflicts = conflicts || conflictOnImport;

        eventsDataUploadProgress = _withinProgress(page, totalPages);
        overallUploadProgress =
            (profileDataUploadProgress + eventsDataUploadProgress) / 2;
        notifyListeners();
      }
    } else {
      eventsDataUploadProgress = 1.0;
      overallUploadProgress =
          (profileDataUploadProgress + eventsDataUploadProgress) / 2;
      notifyListeners();
    }

    return conflicts;
  }

  Future startDataUploadActivity() async {
    _dataUploadProcess = [];
    profileDataUploadProgress = 0.0;
    eventsDataUploadProgress = 0.0;
    overallUploadProgress = 0.0;

    _dataUploadStopped = false;
    updateDataUploadStatus(true);

    try {
      bool conflictOnTeisImport = false;
      bool conflictOnEventsImport = false;

      CurrentUser? currentUser = await UserService().getCurrentUser();
      if (currentUser != null) {
        _synchronizationService = SynchronizationService(
          currentUser.username,
          currentUser.password,
          currentUser.programs,
          currentUser.userOrgUnitIds,
        );

        conflictOnTeisImport = await uploadProfileData(currentUser: currentUser);
        conflictOnEventsImport =
        await uploadServiceData(currentUser: currentUser);
      }

      if (conflictOnTeisImport && conflictOnEventsImport) {
        AppUtil.showToastMessage(message: 'Error uploading data');
      } else if (conflictOnTeisImport) {
        AppUtil.showToastMessage(message: 'Error uploading some Beneficiaries');
      } else if (conflictOnEventsImport) {
        AppUtil.showToastMessage(message: 'Error uploading some Services');
      }
    } catch (e) {
      await _logError('startDataUploadActivity', e);
      AppUtil.showToastMessage(message: 'Error uploading data');
    }

    notifyListeners();

    await startCheckingStatusOfUnsyncedData();
    notifyListeners();

    if (context != null) {
      await Provider.of<ReferralNotificationState>(context!, listen: false)
          .reloadReferralNotifications();
    }

    String lastDataUploadDate =
    AppUtil.formattedDateTimeIntoString(DateTime.now());
    await PreferenceProvider.setPreferenceValue(
        lastDataUploadDatePreferenceKey, lastDataUploadDate);

    if (context != null) {
      Provider.of<SynchronizationStatusState>(context!, listen: false)
          .resetSyncStatusReferences();
    }
  }

  Future syncReferralNotifications() async {
    AppUtil.showToastMessage(
      message: 'Start synchronization of referral notifications',
      position: ToastGravity.TOP,
    );
    int totalCount = 5;
    int count = 0;
    try {
      List<ReferralNotification> onlineReferralNotifications =
      await ReferralNotificationService()
          .discoveringReferralNotificationFromServer();
      ++count;
      _notificationProgress = _clamp01(count / totalCount);
      notifyListeners();

      List<ReferralNotification> offlineReferralNotifications =
      await ReferralNotificationService()
          .getReferralNotificationFromOffline();
      ++count;
      _notificationProgress = _clamp01(count / totalCount);
      notifyListeners();

      List<ReferralNotification> referralNotifications =
      ReferralNotificationService().getMergedReferralNotifications(
          onlineReferralNotifications, offlineReferralNotifications);
      ++count;
      _notificationProgress = _clamp01(count / totalCount);
      notifyListeners();

      await ReferralNotificationService()
          .savingReferralNotificationToOfflineDb(referralNotifications);
      ++count;
      _notificationProgress = _clamp01(count / totalCount);
      notifyListeners();

      await ReferralNotificationService()
          .updateReferralNotificationToServer(referralNotifications);
      ++count;
      _notificationProgress = _clamp01(count / totalCount);
      notifyListeners();
    } catch (_) {
      //
    }
  }

  Future refreshBeneficiaryCounts() async {
    try {
      if (context == null) return;

      await Provider.of<ReferralNotificationState>(context!, listen: false)
          .reloadReferralNotifications();
      List<String> teiWithIncomingReferral =
          Provider.of<ReferralNotificationState>(context!, listen: false)
              .beneficiariesWithIncomingReferrals;
      Provider.of<DreamsInterventionListState>(context!, listen: false)
          .setTeiWithIncomingReferral(
          teiWithIncomingReferral: teiWithIncomingReferral);

      await Provider.of<OvcInterventionListState>(context!, listen: false)
          .refreshOvcNumber();
      await Provider.of<DreamsInterventionListState>(context!, listen: false)
          .refreshBeneficiariesNumber();
      await Provider.of<OgacInterventionListState>(context!, listen: false)
          .refreshOgacNumber();
      await Provider.of<EducationLbseInterventionState>(context!, listen: false)
          .refreshEducationLbseNumber();
      await Provider.of<PpPrevInterventionState>(context!, listen: false)
          .refreshPpPrevNumber();

      Provider.of<ReferralNotificationState>(context!, listen: false)
          .reloadReferralNotifications();
      Provider.of<DreamsRaAssessmentListState>(context!, listen: false)
          .refreshBeneficiariesNumber();

      await Provider.of<EducationBursaryInterventionState>(context!,
          listen: false)
          .refreshEducationBursaryNumber();
    } catch (_) {
      //
    }
  }
}
