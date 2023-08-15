import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'loading.dart';
import 'no_internet.dart';
import 'no_resulte.dart';

class StateBuilder<T extends GetxController> extends GetView<T> {
  StateBuilder({
    required this.id,
    required this.builder,
    this.initialWidgetState = WidgetState.loading,
    this.loadingView,
    this.initState,
    this.noResultsMessage = "لايوجد بيانات",
    this.disableState = false,
    this.showNoResult = true,
    this.onRetryFunction,
    this.errorView,
    this.noResultView,
    Key? key,
  }) : super(key: key) {
    bool contains = false;
    for (StateHolder stateHolder in stateList) {
      if (stateHolder.id == id) {
        contains = true;
      }
    }
    if (!contains) {
      stateList.add(StateHolder(id: id, widgetState: initialWidgetState));
    }
  }

  static List<StateHolder> stateList = [];

  final StateControllerBuilder<T> builder;
  final bool disableState;
  final bool showNoResult;
  final Widget? errorView;
  final String id;
  final WidgetState initialWidgetState;
  final Widget? loadingView;
  final Widget? noResultView;
  final String noResultsMessage;
  final Function? onRetryFunction;
  final void Function(GetBuilderState<T>)? initState;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
      id: id,
      initState: initState,
      builder: (_) {
        final widgetState = stateList
            .where((stateHolder) => stateHolder.id == id)
            .toList()
            .first
            .widgetState;
        if (disableState) {
          return builder(widgetState, controller);
        } else {
          switch (widgetState) {
            case WidgetState.loaded:
              return builder(widgetState, controller);
            case WidgetState.loading:
              return loadingView ?? const Loading();
            case WidgetState.noResults:
              return showNoResult
                  ? noResultView ?? NoResults(message: noResultsMessage)
                  : builder(widgetState, controller);
            case WidgetState.error:
              return errorView ??
                  NoInternetConnection(onRetryFunction: onRetryFunction);
            default:
              return builder(widgetState, controller);
          }
        }
      },
    );
  }
}

enum WidgetState {
  loading,
  error,
  noResults,
  loaded,
  loadingMore,
  disable,
  enable,
  noMoreData
}

typedef StateControllerBuilder<T extends GetxController> = Widget Function(
    WidgetState widgetState, T controller);

class StateHolder {
  StateHolder({
    required this.id,
    required this.widgetState,
  });

  final String id;

  WidgetState widgetState;

  @override
  String toString() {
    return '''
    StateHolder______________________________________
      "id": $id
      "widgetState": ${widgetState.toString()}
    StateHolder______________________________________
    ''';
  }
}
