import 'package:flutter/material.dart';

import '../theme/colors.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({
    required this.termsOfUseModel,
    required this.title,
    Key? key,
  }) : super(key: key);

  final dynamic termsOfUseModel;
  final String title;

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  bool isAr = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        centerTitle: true,
      ),
    );
  }
}
