import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/back_button.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

@RoutePage()
class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({super.key});

  @override
  State<ReportProblemScreen> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<String> _categories = [
    'Technical Issue',
    'Account Problem',
    'Payment Issue',
    'Content Error',
    'Feature Request',
    'Other',
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      toolbarHeight: 60,
      title: Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: CustomBackButton(onPress: () => context.router.pop()),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Report a Problem',
                  style: const TextStyle(
                    color: Color(0xFF181D27),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.12,
                    letterSpacing: 0.20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 56),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement submit logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Problem report submitted successfully'),
          backgroundColor: Colors.green,
        ),
      );
      context.router.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: _buildCustomAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VSpace(20),
              // Header section
              const Text(
                'File a complaint.',
                style: TextStyle(
                  color: Color(0xFF181D27),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.22,
                ),
              ),
              const VSpace(8),
              const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                ),
              ),
              const VSpace(32),
              // Category dropdown
              const Text(
                'Category',
                style: TextStyle(
                  color: Color(0xFF181D27),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.14,
                ),
              ),
              const VSpace(8),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                ),
                child: Center(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    hint: Text(
                      'Select category',
                      style: TextStyle(
                        color: const Color(0xFFA3A7AE),
                        fontSize: 14,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w400,
                        height: 1,
                        letterSpacing: 0.20,
                      ),
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                      isDense: true,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xFF6B7280),
                    ),
                    dropdownColor: Colors.white,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                    items: _categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(
                          category,
                          style: const TextStyle(
                            color: Color(0xFF181D27),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                  ),
                ),
              ),
              const VSpace(24),
              // Subject/Title field
              const Text(
                'Subject/Title',
                style: TextStyle(
                  color: Color(0xFF181D27),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.14,
                ),
              ),
              const VSpace(8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                ),
                child: TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    hintText: 'Subject that suit your problem',
                    hintStyle: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  style: const TextStyle(
                    color: Color(0xFF181D27),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a subject';
                    }
                    return null;
                  },
                ),
              ),
              const VSpace(24),
              // Short Description field
              const Text(
                'Short Description',
                style: TextStyle(
                  color: Color(0xFF181D27),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.14,
                ),
              ),
              const VSpace(8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                ),
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText: 'Describe your problem',
                    hintStyle: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  style: const TextStyle(
                    color: Color(0xFF181D27),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please describe your problem';
                    }
                    return null;
                  },
                ),
              ),
              const VSpace(40),
              // Submit button
              ButtonFactory.blackButton(
                mainAxisAlignment: MainAxisAlignment.center,
                isFullWidth: true,
                text: 'Submit',
                backgroundColor: Colors.black,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                onPressed: _handleSubmit,
              ),
              const VSpace(20),
            ],
          ),
        ),
      ),
    );
  }
}
