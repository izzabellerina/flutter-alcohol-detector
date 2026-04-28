import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'app_footer.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.header,
    this.showFooter = true,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget body;
  final Widget? header;
  final bool showFooter;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: header == null,
        child: Column(
          children: [
            if (header != null) header!,
            Expanded(
              child: SingleChildScrollView(
                padding: padding,
                child: body,
              ),
            ),
            if (showFooter) const AppFooter(),
          ],
        ),
      ),
    );
  }
}
