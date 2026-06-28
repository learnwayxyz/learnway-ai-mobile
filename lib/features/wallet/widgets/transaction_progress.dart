import 'package:flutter/material.dart';

class TransactionProgress extends StatelessWidget {
  const TransactionProgress({
    required this.currentStep,
    required this.steps,
    super.key,
    this.activeColor = const Color(0xFF2196F3),
    this.inactiveColor = const Color(0xFFE0E0E0),
    this.completedColor = const Color(0xFF4CAF50),
    this.textColor = const Color(0xFF333333),
    this.stepSize = 24.0,
    this.lineHeight = 2.0,
    this.spacing = 40.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.showLabels = true,
  });

  final int currentStep;
  final List<FinanceStepItem> steps;
  final Color activeColor;
  final Color inactiveColor;
  final Color completedColor;
  final Color textColor;
  final double stepSize;
  final double lineHeight;
  final double spacing;
  final Duration animationDuration;
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          SizedBox(height: stepSize, child: Row(children: _buildStepperLine())),
          if (showLabels) ...[
            const SizedBox(height: 12),
            Row(children: _buildLabels()),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildStepperLine() {
    List<Widget> widgets = [];

    for (int i = 0; i < steps.length; i++) {
      widgets.add(_buildStepCircle(i));
      if (i < steps.length - 1) {
        widgets.add(_buildConnectingLine(i));
      }
    }

    return widgets;
  }

  List<Widget> _buildLabels() {
    return steps.asMap().entries.map((entry) {
      int index = entry.key;
      FinanceStepItem step = entry.value;

      return Expanded(
        child: Text(
          step.label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _getStepTextColor(index),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildStepCircle(int index) {
    final isCompleted = index < currentStep;
    final isActive = index == currentStep;
    Color backgroundColor;
    Color borderColor;
    Widget? child;

    if (isCompleted) {
      backgroundColor = completedColor;
      borderColor = completedColor;
      child = Icon(Icons.check, size: stepSize * 0.6, color: Colors.white);
    } else if (isActive) {
      backgroundColor = Colors.white;
      borderColor = activeColor;
      child = Container(
        width: stepSize * 0.4,
        height: stepSize * 0.4,
        decoration: BoxDecoration(color: activeColor, shape: BoxShape.circle),
      );
    } else {
      backgroundColor = Colors.white;
      borderColor = inactiveColor;
      child = null;
    }

    return AnimatedContainer(
      duration: animationDuration,
      width: stepSize,
      height: stepSize,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
        boxShadow:
            isActive || isCompleted
                ? [
                  BoxShadow(
                    color: (isCompleted ? completedColor : activeColor)
                        .withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
                : null,
      ),
      child: child,
    );
  }

  Widget _buildConnectingLine(int index) {
    final isCompleted = index < currentStep;
    final isActive = index == currentStep - 1;

    Color lineColor;
    if (isCompleted) {
      lineColor = completedColor;
    } else if (isActive) {
      lineColor = activeColor;
    } else {
      lineColor = inactiveColor;
    }

    return Expanded(
      child: AnimatedContainer(
        duration: animationDuration,
        height: lineHeight,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: lineColor,
          borderRadius: BorderRadius.circular(lineHeight / 2),
        ),
      ),
    );
  }

  Color _getStepTextColor(int index) {
    final isCompleted = index < currentStep;
    final isActive = index == currentStep;

    if (isCompleted) {
      return completedColor;
    } else if (isActive) {
      return activeColor;
    } else {
      return inactiveColor;
    }
  }
}

class FinanceStepItem {
  const FinanceStepItem({required this.label, this.icon});

  final String label;
  final IconData? icon;
}

class FinanceSteps {
  static const List<FinanceStepItem> transactionFlow = [
    FinanceStepItem(label: 'Ready', icon: Icons.account_balance_wallet),
    FinanceStepItem(label: 'Processing', icon: Icons.sync),
    FinanceStepItem(label: 'Completed', icon: Icons.check_circle),
  ];

  static const List<FinanceStepItem> paymentFlow = [
    FinanceStepItem(label: 'Details', icon: Icons.edit),
    FinanceStepItem(label: 'Verify', icon: Icons.verified_user),
    FinanceStepItem(label: 'Payment', icon: Icons.payment),
    FinanceStepItem(label: 'Success', icon: Icons.check_circle),
  ];

  static const List<FinanceStepItem> transferFlow = [
    FinanceStepItem(label: 'Amount', icon: Icons.attach_money),
    FinanceStepItem(label: 'Recipient', icon: Icons.person),
    FinanceStepItem(label: 'Confirm', icon: Icons.check),
    FinanceStepItem(label: 'Complete', icon: Icons.done_all),
  ];

  static const List<FinanceStepItem> kycFlow = [
    FinanceStepItem(label: 'Identity', icon: Icons.badge),
    FinanceStepItem(label: 'Documents', icon: Icons.folder),
    FinanceStepItem(label: 'Review', icon: Icons.rate_review),
    FinanceStepItem(label: 'Approved', icon: Icons.verified),
  ];
}
