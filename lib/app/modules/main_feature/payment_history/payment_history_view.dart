import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/localization/translation.dart';
import 'package:sport/app/core/models/transaction_model.dart';
import 'package:sport/app/core/services/request_mixin.dart';
import 'package:sport/app/core/services/size_configration.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/utils/intl.dart';
import 'package:sport/app/core/widgets/pagination.dart';
import 'package:sport/app/core/widgets/widget_state.dart';
import 'package:sport/app/modules/main_feature/payment_history/payment_history_controller.dart';

class PaymentHistoryView extends GetView<PaymentHistoryController> {
  const PaymentHistoryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 100),
        child: AppBar(
          toolbarHeight: 100,
          title: Text(
            LanguageKey.paymentHistory.tr,
          ),
        ),
      ),
      body: ScreenSizer(
        builder: (CustomSize customSize) {
          return StateBuilder<PaymentHistoryController>(
            id: "getPaymentHistory",
            onRetryFunction: controller.getPaymentHistory,
            builder: (widgetState, controller) {
              return PaginationBuilder<PaymentHistoryController>(
                id: "getPaymentHistory",
                onRefresh: () async {
                  await controller.getPaymentHistory(RequestType.refresh);
                },
                onRetryFunction: controller.getPaymentHistory,
                onLoadingMore: () async {
                  await controller.getPaymentHistory(RequestType.loadingMore);
                },
                builder: (scrollController) {
                  return ListView.separated(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                    itemBuilder: (context, index) {
                      final Transaction transaction =
                          controller.dataList[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          header(index: index),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 7,
                                    offset: const Offset(1, 2),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                title: Text(
                                  "${DateFormat.yMMMMd(Translation.languageCode).format(transaction.createdAt)} - ${DateFormat.jm(Translation.languageCode).format(transaction.createdAt)}",
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: transaction.completed
                                        ? AppColors.green
                                        : transaction.refunded
                                            ? AppColors.primary
                                            : AppColors.red,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    transaction.completed
                                        ? LanguageKey.completed.tr
                                        : transaction.refunded
                                            ? LanguageKey.refunded.tr
                                            : LanguageKey.incomplete.tr,
                                    style: const TextStyle(
                                      color: AppColors.background,
                                    ),
                                  ),
                                ),
                                subtitle: Text(
                                  "${transaction.amount} ${LanguageKey.dirhams.tr}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.fontGray,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 20);
                    },
                    itemCount: controller.dataList.length,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget header({
    required int index,
  }) {
    final Transaction transaction = controller.dataList[index];
    return Builder(
      builder: (context) {
        if (index == 0) {
          if (transaction.createdAt.sameDay()) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                LanguageKey.today.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                DateFormat.MMMMd(Translation.languageCode)
                    .format(transaction.createdAt),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
        } else if (!transaction.createdAt
            .sameDay(controller.dataList[index - 1].createdAt)) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              DateFormat.MMMMd(Translation.languageCode)
                  .format(transaction.createdAt),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
