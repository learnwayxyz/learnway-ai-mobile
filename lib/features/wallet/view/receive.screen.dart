import 'package:flutter/services.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/shared/utilities/ui_utils.dart';
import 'package:learnwayv2/shared/utilities/ui_utils.dart'
    as UiUtils
    show showSnackBar;
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:share_plus/share_plus.dart';

@RoutePage()
class ReceiveScreen extends StatefulWidget {
  const ReceiveScreen({super.key});
  @override
  State<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen> {
  @protected
  late QrCode qrCode;
  @protected
  late QrImage qrImage;
  String? walletAddress;

  @override
  void initState() {
    super.initState();
    walletAddress = LocalStorageService.getUserSync()?.walletAddress;
    qrCode = QrCode.fromData(
      data: walletAddress ?? '',
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );

    qrImage = QrImage(qrCode);
  }

  @override
  Widget build(BuildContext context) {
    final decoration = PrettyQrDecoration(
      shape: PrettyQrSmoothSymbol(color: AppColors.gray900),
      background: Colors.white,
      image: PrettyQrDecorationImage(
        image: AssetImage(Assets.images.tetherImage.path),
      ),
    );
    return Scaffold(
      appBar: AppBarFactory.standardAppBar(title: AppLocalizations.of(context)!.deposit, barHeight: 10),
      body: walletAddress == null || walletAddress!.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.walletAddressNotAvailable,
                    style: AppTextStyles.baseBold(context),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.pleaseCompleteWalletSetup,
                    style: AppTextStyles.baseRegular(context),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    AppLocalizations.of(context)!.scanQrCode,
                    style: AppTextStyles.xxlBold(context),
                    textAlign: TextAlign.center,
                  ),
                  const VSpace(10),
                  Text(
                    AppLocalizations.of(context)!.scanQrCodeToProcess,
                    style: AppTextStyles.baseRegular(context),
                  ),
                  const VSpace(40),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: SizedBox(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 183,
                              width: 183,
                              child: PrettyQrView(
                                qrImage: qrImage,
                                decoration: decoration,
                              ),
                            ),
                            const VSpace(16),
                            Container(
                              padding: const EdgeInsets.fromLTRB(
                                15,
                                15,
                                15,
                                15,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xffCFDDFF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.sendOnlyUsdtOnLisk,
                                style: AppTextStyles.smSemiBold(
                                  context,
                                ).copyWith(color: AppColors.primary25),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const VSpace(16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  shortenAddress(walletAddress!),
                                  style: AppTextStyles.baseBold(
                                    context,
                                  ).copyWith(color: AppColors.primary25),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () async {
                                    final msg = AppLocalizations.of(context)!.copiedToClipboard;
                                    await Clipboard.setData(
                                      ClipboardData(text: walletAddress!),
                                    );
                                    if (mounted) {
                                      UiUtils.showSnackBar(msg, context);
                                    }
                                  },
                                  child: SvgPicture.asset(
                                    Assets.icons.copyIcon,
                                    colorFilter: const ColorFilter.mode(
                                      Color(0xff2B61E3),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const VSpace(36),
                  ButtonFactory.blackButton(
                    mainAxisAlignment: MainAxisAlignment.center,
                    backgroundColor: AppColors.gray900,
                    onPressed: () {
                      SharePlus.instance.share(
                        ShareParams(
                          text: walletAddress,
                          title: AppLocalizations.of(context)!.sendOnlyUsdtOnLisk,
                        ),
                      );
                    },
                    text: AppLocalizations.of(context)!.shareAddress,
                    trailingIcon: SvgPicture.asset(
                      Assets.icons.shareIcon,
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    textStyle: AppTextStyles.mdBold(
                      context,
                    ).copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
    );
  }
}
