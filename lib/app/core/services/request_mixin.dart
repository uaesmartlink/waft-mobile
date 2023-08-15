import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/localization/language_key.dart';

import '../utils/exceptions.dart';
import '../widgets/app_messenger.dart';
import '../widgets/widget_state.dart';
import 'state_mixin.dart';

mixin RequestMixin on StateProvider {
  Future<void> requestMethod<R>({
    required List<String> ids,
    RequestType requestType = RequestType.getData,
    required Future<List<R>?> Function() function,
    void Function(CustomException)? onError,
    List<String>? stateLessIds,
    String? errorMessage,
    bool showLoading = false,
    bool showToast = false,
    bool showErrorToast = true,
    String? loadedMessage,
  }) async {
    try {
      if (showLoading) {
        BotToast.showLoading();
      }
      _loadingHandler(ids: ids, requestType: requestType);
      final List<R>? list = await function();
      _loadedHandler<R>(
        ids: ids,
        requestType: requestType,
        list: list,
        stateLessIds: stateLessIds,
      );
      if (loadedMessage != null) {
        CustomToast.showDefault(loadedMessage.tr, showToast);
      }
      if (showLoading) {
        BotToast.closeAllLoading();
      }
    } on CustomException catch (e) {
      if (e.error == CustomError.cancelByNextRequest) {
        return;
      }
      if (showLoading) {
        BotToast.closeAllLoading();
      }
      _errorHandler(ids: ids, requestType: requestType);

      if (showErrorToast) {
        if (errorMessage != null) {
          CustomToast.showDefault(errorMessage.tr, showToast);
        } else {
          CustomToast.showError(e, showToast);
        }
      }
      if (onError != null) {
        onError(e);
      }
    }
  }

  void _loadedHandler<R>({
    required List<String> ids,
    required RequestType requestType,
    required List<R>? list,
    List<String>? stateLessIds,
  }) {
    if (stateLessIds != null) {
      updateState(stateLessIds, WidgetState.loaded);
    }
    switch (requestType) {
      case RequestType.getData:
        if (list != null) {
          if (list.isEmpty) {
            updateState(ids, WidgetState.noResults);
          } else {
            updateState(ids, WidgetState.loaded);
          }
        } else {
          updateState(ids, WidgetState.loaded);
        }
        break;
      case RequestType.postData:
        updateState(ids, WidgetState.loaded);
        break;
      case RequestType.loadingMore:
        if (list != null) {
          if (list.isEmpty) {
            updateState(ids, WidgetState.noMoreData);
            CustomToast.showDefault(LanguageKey.noMoreData.tr);
          } else {
            updateState(ids, WidgetState.loaded);
          }
        }
        break;
      case RequestType.refresh:
        updateState(ids, WidgetState.loaded);
        break;
    }
  }

  void _loadingHandler({
    required List<String> ids,
    required RequestType requestType,
  }) {
    switch (requestType) {
      case RequestType.getData:
        updateState(ids, WidgetState.loading);
        break;
      case RequestType.postData:
        updateState(ids, WidgetState.loading);
        break;
      case RequestType.loadingMore:
        updateState(ids, WidgetState.loadingMore);
        break;
      case RequestType.refresh:
        break;
    }
  }

  void _errorHandler({
    required List<String> ids,
    required RequestType requestType,
  }) {
    switch (requestType) {
      case RequestType.getData:
        updateState(ids, WidgetState.error);
        break;
      case RequestType.postData:
        updateState(ids, WidgetState.loaded);
        break;
      case RequestType.loadingMore:
        updateState(ids, WidgetState.loaded);
        break;
      case RequestType.refresh:
        updateState(ids, WidgetState.loaded);
        break;
    }
  }
}

enum RequestType {
  getData,
  postData,
  loadingMore,
  refresh,
}
