import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/localization/translation.dart';
import 'package:sport/app/core/models/activity_model.dart';
import 'package:sport/app/core/models/package_model.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';
import 'package:sport/app/core/services/getx_state_controller.dart';
import 'package:sport/app/core/services/request_mixin.dart';
import 'package:sport/app/core/utils/logger.dart';
import 'package:sport/app/core/widgets/app_messenger.dart';
import 'package:sport/app/modules/main_feature/shared/constant/home_routes.dart';

class ReviewSummaryController extends GetxStateController {
  final ActivitiesRepository activitiesRepository;
  late final Activity activity;
  late final DateTime date;
  late final Package selectedPackage;
  late final bool fromBookings;

  ReviewSummaryController({required this.activitiesRepository});
  @override
  void onInit() {
    activity = Get.arguments["activity"];
    date = Get.arguments["date"];
    selectedPackage = Get.arguments["selectedPackage"];
    fromBookings = Get.arguments["fromBookings"] ?? false;
    super.onInit();
  }

  Future<void> bookStadium() async {
    requestMethod(
      ids: ["bookStadium"],
      requestType: RequestType.getData,
      function: () async {
        String paymentUrl = await activitiesRepository.bookStadium(
          stadiumId: activity.id,
          package: selectedPackage,
          userId: DataHelper.user!.id,
          startTime: date,
        );
        Get.toNamed(
          HomeRoutes.paymentGatewayRoute,
          parameters: {"paymentGatewayUrl": paymentUrl},
          arguments: {
            "activity": activity,
            "date": date,
            "selectedPackage": selectedPackage,
          },
        );
        return null;
      },
    );
  }

  late String _localPath;
  late bool _permissionReady;
  late TargetPlatform? platform;

  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        PermissionStatus result = await Permission.storage.request();
        result = await Permission.manageExternalStorage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create(recursive: true);
    }
  }

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/storage/emulated/0/Download/WAFT";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return '${directory.path}${Platform.pathSeparator}Download/WAFT';
    }
  }

  Font? arabicFont;
  Future<void> savePDF() async {
    _permissionReady = await _checkPermission();
    arabicFont =
        pw.Font.ttf(await rootBundle.load("assets/fonts/Amiri-Regular.ttf"));
    if (_permissionReady) {
      await _prepareSaveDir();
      try {
        final pdf = pw.Document();

        pdf.addPage(pw.Page(
            pageFormat: PdfPageFormat.a4,
            textDirection: Translation.currentLanguage.languageCode == "ar"
                ? pw.TextDirection.rtl
                : pw.TextDirection.ltr,
            build: (pw.Context context) {
              return pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex("ffFAFAFA"),
                  borderRadius: pw.BorderRadius.circular(15),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      activity.name,
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        font: arabicFont,
                      ),
                    ),
                    pw.SizedBox(height: 20),
                    summaryItem(
                      firstString: LanguageKey.address.tr,
                      secondString: activity.address,
                    ),
                    pw.SizedBox(height: 20),
                    summaryItem(
                      firstString: LanguageKey.bookingDate.tr,
                      secondString: DateFormat.yMMMMd(Translation.languageCode)
                          .format(date),
                    ),
                    if (selectedPackage.packageType ==
                        PackageType.timeSlot) ...[
                      pw.SizedBox(height: 20),
                      summaryItem(
                        firstString: LanguageKey.bookingHour.tr,
                        secondString: DateFormat.jm(Translation.languageCode)
                            .format(date),
                      ),
                    ],
                    pw.SizedBox(height: 20),
                    summaryItem(
                      firstString: LanguageKey.description.tr,
                      secondString: selectedPackage.name,
                    ),
                    pw.SizedBox(height: 20),
                    summaryItem(
                      firstString: LanguageKey.bookingType.tr,
                      secondString:
                          selectedPackage.packageType == PackageType.timeSlot
                              ? LanguageKey.oneTimeReservation.tr
                              : LanguageKey.subscription.tr,
                    ),
                    pw.SizedBox(height: 20),
                    summaryItem(
                      firstString: LanguageKey.price.tr,
                      secondString:
                          "${selectedPackage.price} ${LanguageKey.dirhams.tr}",
                    ),
                  ],
                ),
              );
            }));
        final file = File(
            "$_localPath/${activity.name}-${DateTime.now().minute}-${DateTime.now().second}.pdf");
        await file.writeAsBytes(await pdf.save());
        AppMessenger.message(LanguageKey.savedToDownloads.tr);
      } catch (e) {
        logger("Download Failed.\n\n$e");
      }
    }
  }

  pw.Widget summaryItem({
    required String firstString,
    required String secondString,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        if (Translation.currentLanguage.languageCode == "en")
          pw.Text(
            firstString,
            style: pw.TextStyle(
              fontSize: 14,
              font: arabicFont,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        pw.Text(
          secondString,
          style: pw.TextStyle(
            fontSize: 16,
            font: arabicFont,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        if (Translation.currentLanguage.languageCode == "ar")
          pw.Text(
            firstString,
            style: pw.TextStyle(
              fontSize: 14,
              font: arabicFont,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
      ],
    );
  }
}
