import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:learnwayv2/dataconsent_and_compliance/terms_and_condition.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

@RoutePage()
class TermsAndConditionScreen extends StatelessWidget {
  final String? title;

  const TermsAndConditionScreen({super.key, @PathParam() this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBarFactory.standardAppBar(
        title: title ?? 'Terms & Conditions',
        barHeight: 10,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VSpace(20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VSpace(13),
                    Markdown(
                      physics: const NeverScrollableScrollPhysics(),
                      data: termsandconditions,
                      shrinkWrap: true,
                      styleSheet: MarkdownStyleSheet(
                        // Headers
                        h1: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        h2: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                        h3: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
