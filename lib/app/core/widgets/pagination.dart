import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/theme/colors.dart';

import 'widget_state.dart';

class PaginationBuilder<T extends GetxController> extends StatefulWidget {
  const PaginationBuilder({
    required this.id,
    required this.builder,
    this.onLoadingMore,
    this.loadingMoreIndicatorPadding = const EdgeInsets.all(15),
    this.onRefresh,
    this.onRetryFunction,
    this.loadingMoreIndicatorAlignment = Alignment.bottomCenter,
    Key? key,
  }) : super(key: key);

  final Future<void> Function()? onRefresh;
  final Function()? onLoadingMore;
  final StateBuilders builder;
  final String id;
  final AlignmentGeometry loadingMoreIndicatorAlignment;
  final EdgeInsetsGeometry loadingMoreIndicatorPadding;
  final Function? onRetryFunction;

  @override
  PaginationBuilderState<T> createState() => PaginationBuilderState<T>();
}

class PaginationBuilderState<T extends GetxController>
    extends State<PaginationBuilder<T>> {
  bool isLoading = false;
  ScrollController scrollController = ScrollController();

  StateHolder? stateHolder;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getStateHolder();
    });

    scrollController.addListener(_scrollListener);
    super.initState();
  }

  void getStateHolder() {
    for (StateHolder stateHolder in StateBuilder.stateList) {
      if (widget.id == stateHolder.id) {
        this.stateHolder = stateHolder;
      }
    }
  }

  void _scrollListener() async {
    if (scrollController.position.atEdge &&
        !isLoading &&
        (stateHolder!.widgetState != WidgetState.noMoreData)) {
      final bool isTop = scrollController.position.pixels == 0;
      if (!isTop && !isLoading) {
        isLoading = true;
        if (widget.onLoadingMore != null) {
          await widget.onLoadingMore!();
        }
      }
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        if (widget.onRefresh != null) {
          await widget.onRefresh!();
        }
      },
      child: Stack(
        children: [
          widget.builder(scrollController),
          StateBuilder<T>(
            id: widget.id,
            disableState: true,
            onRetryFunction: widget.onRetryFunction,
            initialWidgetState: WidgetState.loaded,
            builder: (widgetState, controller) {
              return Visibility(
                visible: widgetState == WidgetState.loadingMore,
                child: Align(
                  alignment: widget.loadingMoreIndicatorAlignment,
                  child: Padding(
                    padding: widget.loadingMoreIndicatorPadding,
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: AppColors.splash,
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

typedef StateBuilders = Widget Function(ScrollController scrollController);
