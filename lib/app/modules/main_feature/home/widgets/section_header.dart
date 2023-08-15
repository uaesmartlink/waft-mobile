import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/widget_state.dart';

class SectionHeaderWidget extends StatelessWidget {
  const SectionHeaderWidget({
    super.key,
    required this.title,
    required this.onSeeAll,
    required this.widgetState,
    required this.onSelectItem,
    required this.items,
    required this.selectedItem,
  });
  final String title;
  final void Function() onSeeAll;
  final void Function(int) onSelectItem;
  final WidgetState widgetState;
  final List<SectionHeaderItem> items;
  final SectionHeaderItem? selectedItem;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: onSeeAll,
                child: Text(
                  LanguageKey.seeAll.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widgetState != WidgetState.error)
          SizedBox(
            height: 40,
            child: ListView.separated(
              itemCount: widgetState == WidgetState.loading ? 10 : items.length,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) {
                return const SizedBox(width: 10);
              },
              itemBuilder: (context, index) {
                if (widgetState == WidgetState.loading) {
                  return Shimmer.fromColors(
                    baseColor: AppColors.codeInput,
                    highlightColor: AppColors.background,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.codeInput,
                      ),
                      width: 50 * (index % 3 + 1),
                      height: 40,
                    ),
                  );
                } else {
                  return InkWell(
                    onTap: () {
                      onSelectItem(items[index].id);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: items[index] == selectedItem
                            ? AppColors.primary
                            : AppColors.codeInput,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Center(
                          child: Text(
                        items[index].title,
                        style: TextStyle(
                          color: items[index] == selectedItem
                              ? AppColors.background
                              : AppColors.font,
                        ),
                      )),
                    ),
                  );
                }
              },
            ),
          ),
      ],
    );
  }
}

class SectionHeaderItem {
  final int id;
  final String title;

  SectionHeaderItem({
    required this.id,
    required this.title,
  });
  @override
  bool operator ==(Object other) {
    return other is SectionHeaderItem && other.id == id && other.title == title;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode;
}
