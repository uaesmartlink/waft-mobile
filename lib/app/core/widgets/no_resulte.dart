import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/localization/language_key.dart';

class NoResults extends StatelessWidget {
  const NoResults({this.message, Key? key}) : super(key: key);

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded),
          const SizedBox(width: 10),
          Text(LanguageKey.noData.tr),
        ],
      ),
    );
  }
}
