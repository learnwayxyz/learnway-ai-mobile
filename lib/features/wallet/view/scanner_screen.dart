import 'package:flutter/material.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/shared/utilities/ethereum_utils.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  Barcode? _barcode;
  bool _isProcessing = false;
  final MobileScannerController _controller = MobileScannerController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBarcodeInfo() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: ShapeDecoration(
        color: const Color(0xffCFDDFF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: Text(
        'The QR Code will be automaticly detected when you position it between the guide lines',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xff2B61E3),
        ),
      ),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (!mounted || _isProcessing) return;

    setState(() {
      _isProcessing = true;
      _barcode = barcodes.barcodes.firstOrNull;
      _isProcessing = false;
    });

    if (_barcode != null &&
        EthereumAddressUtils.isValidAddress(_barcode!.displayValue!)) {
      _controller.stop();

      Navigator.pop(context, _barcode!.displayValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarFactory.standardAppBar(
        title: 'WithDraw',
        showBackButton: true,
        barHeight: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Scan the QR Code to process your payment',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.height * 0.4,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: MobileScanner(
                    controller: _controller,
                    overlayBuilder: (context, constraints) {
                      return QRScannerOverlay(
                        overlayColor: Colors.transparent,
                        borderColor: Colors.white,
                        borderRadius: 10,
                        borderLength: 30,
                        borderWidth: 10,
                        cutOutSize: MediaQuery.of(context).size.width * 0.8,
                      );
                    },
                    onDetect: _handleBarcode,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildBarcodeInfo(),
          ),
        ],
      ),
    );
  }
}

class QRScannerOverlay extends StatelessWidget {
  const QRScannerOverlay({
    required this.overlayColor,
    required this.borderColor,
    required this.borderLength,
    required this.borderWidth,
    required this.borderRadius,
    required this.cutOutSize,
    super.key,
  });

  final Color overlayColor;
  final Color borderColor;
  final double borderLength;
  final double borderWidth;
  final double borderRadius;
  final double cutOutSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(overlayColor, BlendMode.srcOut),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Center(
                child: Container(
                  height: cutOutSize,
                  width: cutOutSize,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Corner markers
        Center(
          child: SizedBox(
            width: cutOutSize,
            height: cutOutSize,
            child: CustomPaint(
              painter: CornerPainter(
                borderColor: borderColor,
                borderLength: borderLength,
                borderWidth: borderWidth,
                radius: borderRadius,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CornerPainter extends CustomPainter {
  const CornerPainter({
    required this.borderColor,
    required this.borderLength,
    required this.borderWidth,
    required this.radius,
  });

  final Color borderColor;
  final double borderLength;
  final double borderWidth;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    final cornerSize = borderLength;

    // Top Left Corner
    canvas
      ..drawPath(
        Path()
          ..moveTo(0, cornerSize)
          ..lineTo(0, 10)
          ..arcToPoint(Offset(radius, 0), radius: Radius.circular(radius))
          ..lineTo(cornerSize, 0),
        paint,
      )
      // Top Right Corner
      ..drawPath(
        Path()
          ..moveTo(size.width - cornerSize, 0)
          ..lineTo(size.width - radius, 0)
          ..arcToPoint(
            Offset(size.width, radius),
            radius: Radius.circular(radius),
          )
          ..lineTo(size.width, cornerSize),
        paint,
      )
      // Bottom Right Corner
      ..drawPath(
        Path()
          ..moveTo(size.width, size.height - cornerSize)
          ..lineTo(size.width, size.height - radius)
          ..arcToPoint(
            Offset(size.width - radius, size.height),
            radius: Radius.circular(radius),
          )
          ..lineTo(size.width - cornerSize, size.height),
        paint,
      )
      // Bottom Left Corner
      ..drawPath(
        Path()
          ..moveTo(cornerSize, size.height)
          ..lineTo(radius, size.height)
          ..arcToPoint(
            Offset(0, size.height - radius),
            radius: Radius.circular(radius),
          )
          ..lineTo(0, size.height - cornerSize),
        paint,
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
