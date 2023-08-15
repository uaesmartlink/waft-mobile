import 'package:get/get.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/widgets/widget_state.dart';

import '../widgets/app_messenger.dart';
import 'request_mixin.dart';

abstract class PaginationId {
  int lastId = 0;
}

mixin DataList<T extends PaginationId> on RequestMixin {
  int _page = 0;
  int _lastId = 0;
  final List<T> _dataList = [];
  Future<void> handelDataList({
    required List<String> ids,
    required RequestType requestType,
    required Future<List<T>> Function() function,
    void Function()? onDone,
    List<String>? stateLessIds,
    String? errorMessage,
    String? loadedMessage,
  }) async {
    switch (requestType) {
      case RequestType.getData:
        await requestMethod(
            ids: ids,
            stateLessIds: stateLessIds,
            requestType: RequestType.getData,
            function: () async {
              _lastId = 0;
              _page = 0;
              final List<T> tempDataList = await function();
              _dataList.clear();
              _dataList.addAll(tempDataList);
              if (_dataList.isNotEmpty) {
                _lastId = _dataList.last.lastId;
              }
              _page = 1;
              if (onDone != null) {
                onDone();
              }
              return tempDataList;
            });
        break;
      case RequestType.postData:
        break;
      case RequestType.loadingMore:
        await requestMethod(
            ids: ids,
            stateLessIds: stateLessIds,
            requestType: RequestType.loadingMore,
            function: () async {
              final List<T> tempDataList = await function();
              _dataList.addAll(tempDataList);
              if (_dataList.isNotEmpty) {
                _lastId = _dataList.last.lastId;
              }
              if (tempDataList.isEmpty) {
                CustomToast.showDefault(LanguageKey.noData.tr);
              }
              _page++;
              if (onDone != null) {
                onDone();
              }
              return tempDataList;
            });
        break;
      case RequestType.refresh:
        await requestMethod(
            ids: ids,
            stateLessIds: stateLessIds,
            requestType: RequestType.refresh,
            function: () async {
              _lastId = 0;
              _page = 0;
              final List<T> tempDataList = await function();
              _dataList.clear();
              _dataList.addAll(tempDataList);
              if (_dataList.isNotEmpty) {
                _lastId = _dataList.last.lastId;
              }
              _page = 1;
              if (onDone != null) {
                onDone();
              }
              return tempDataList;
            });
        break;
    }
  }

  void addItem(T item, List<String> ids) {
    _dataList.add(item);
    updateState(ids, WidgetState.loaded);
  }

  List<T> get dataList => _dataList;
  int get lastId => _lastId;
  void setLastId(int lastId) => _lastId = lastId;
  int get page => _page + 1;
}
