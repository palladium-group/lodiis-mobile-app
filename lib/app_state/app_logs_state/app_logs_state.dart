import 'package:flutter/foundation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lncmis_mobile_app/core/constants/app_logs_constants.dart';
import 'package:lncmis_mobile_app/core/services/pagination_service.dart';
import 'package:lncmis_mobile_app/models/app_logs.dart';
import 'package:lncmis_mobile_app/modules/app_logs/services/app_logs_service.dart';

class AppLogsState with ChangeNotifier {
  // initial state
  List<AppLogs> _appLogsList = <AppLogs>[];
  bool _isLoading = false;
  int _numberOfAppLogs = 0;
  int _numberOfPages = 0;
  int? _nextPage = 0;
  String _searchableValue = '';

  PagingController? _pagingController;

  // selectors
  bool get isLoading => _isLoading;
  int get numberOfPages => _numberOfPages;
  int? get nextPage => _nextPage;
  PagingController? get pagingController => _pagingController;

  Future<void> refreshAppLogsNumber() async {
    _isLoading = true;
    notifyListeners();
    await getAppLogsCount();
    await getNumberOfPages();
    if (_pagingController == null) {
      initializePagination();
    } else {
      _pagingController!.refresh();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshAppLogsList() async {
    _pagingController!.refresh();
    notifyListeners();
  }

  void searchAppLogs(String value) {
    if (_appLogsList.isEmpty) {
      _appLogsList =
          _pagingController!.itemList as List<AppLogs>? ?? <AppLogs>[];
      _nextPage = _pagingController!.nextPageKey;
    }
    if (value.isNotEmpty) {
      _searchableValue = value;
      notifyListeners();
      refreshAppLogsList();
    } else {
      _pagingController!.itemList = _appLogsList;
      _pagingController!.nextPageKey = _nextPage;
      _appLogsList = <AppLogs>[];
      _nextPage = 0;
    }
  }

  Future<void> _fetchPage(int pageKey) async {
    String searchableValue = _searchableValue;
    List<AppLogs> logsList = await AppLogsService()
        .getAppLogs(page: pageKey, searchableValue: searchableValue);
    if (logsList.isEmpty && pageKey != numberOfPages) {
      _fetchPage(pageKey + 1);
    } else {
      PaginationService.assignPagesToController(
        _pagingController,
        logsList,
        pageKey,
        numberOfPages,
      );
    }
  }

  Future<void> clearLogs() async {
    await AppLogsService().clearLogs();
    await refreshAppLogsList();
  }

  void initializePagination() {
    _pagingController = PagingController<int, AppLogs>(firstPageKey: 0);
    PaginationService.initializePagination(
        mounted: true,
        pagingController: _pagingController,
        fetchPage: _fetchPage);
  }

  void onAppLogsAdd() {
    _numberOfAppLogs = _numberOfAppLogs + 1;
    getNumberOfPages();
    notifyListeners();
  }

  getNumberOfPages() {
    _numberOfPages =
        (_numberOfAppLogs / AppLogsConstants.logsPagnationLimit).ceil();
  }

  Future<void> getAppLogsCount() async {
    _numberOfAppLogs = await AppLogsService().getAppLogsCount();
  }

  @override
  void dispose() {
    _pagingController!.dispose();
    super.dispose();
  }
}
