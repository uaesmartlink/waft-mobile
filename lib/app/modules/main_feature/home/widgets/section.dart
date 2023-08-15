import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/models/activity_model.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/activity_item.dart';
import 'package:sport/app/core/widgets/no_internet.dart';
import 'package:sport/app/core/widgets/widget_state.dart';
import 'package:sport/app/modules/main_feature/home/widgets/section_header.dart';

class SectionWidget extends StatelessWidget {
  const SectionWidget({
    super.key,
    required this.title,
    required this.onSeeAll,
    required this.widgetState,
    required this.onSelectHeaderItem,
    required this.headerItems,
    required this.items,
    required this.selectedHeaderItem,
    required this.onSave,
    required this.onRemove,
    required this.onTap,
    this.onRetryFunction,
  });
  final String title;
  final void Function() onSeeAll;
  final WidgetState widgetState;
  final Future<bool> Function(Activity) onSave;
  final Future<bool> Function(int?) onRemove;
  final Function? onRetryFunction;
  final List<Activity> items;
  final List<SectionHeaderItem> headerItems;
  final void Function(int) onSelectHeaderItem;
  final SectionHeaderItem? selectedHeaderItem;
  final void Function(Activity)? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionHeaderWidget(
          onSeeAll: onSeeAll,
          widgetState:
              headerItems.isNotEmpty ? WidgetState.loaded : widgetState,
          items: headerItems,
          title: title,
          selectedItem: selectedHeaderItem,
          onSelectItem: onSelectHeaderItem,
        ),
        const SizedBox(height: 20),
        if (widgetState != WidgetState.error)
          if (items.isEmpty && widgetState == WidgetState.loaded)
            SizedBox(
              height: 100,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off_rounded),
                    const SizedBox(width: 10),
                    Text(LanguageKey.noData.tr),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widgetState == WidgetState.loading ? 3 : items.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 20);
              },
              itemBuilder: (context, index) {
                if (widgetState == WidgetState.loading) {
                  return Shimmer.fromColors(
                    baseColor: AppColors.codeInput,
                    highlightColor: AppColors.background,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.codeInput,
                      ),
                      width: double.infinity,
                      height: 110,
                    ),
                  );
                } else {
                  final Activity item = items[index];
                  return InkWell(
                    onTap: () {
                      if (onTap != null) {
                        onTap!(item);
                      }
                    },
                    child: ActivityItem(
                      onSave: () async {
                        return onSave(item);
                      },
                      onRemove: () async {
                        return onRemove(item.favoriteId);
                      },
                      address: item.address,
                      imageUrl: item.image,
                      rating: item.rating,
                      saved: item.isFavorite,
                      title: item.name,
                    ),
                  );
                }
              },
            )
        else
          SizedBox(
            height: 120,
            child: NoInternetConnection(onRetryFunction: onRetryFunction),
          )
      ],
    );
  }
}
