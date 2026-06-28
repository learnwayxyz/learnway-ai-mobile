import 'package:flutter/material.dart';

void showCameraDialog(
  BuildContext context, {
  required VoidCallback onTapCamera,
  required VoidCallback onTapGallery,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text('Camera'),
                  onTap: () {
                    onTapCamera();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text('Gallery'),
                  onTap: () {
                    onTapGallery();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
