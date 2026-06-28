import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/features/wallet/widgets/transaction_progress.dart';
import 'package:learnwayv2/shared/utilities/ui_utils.dart' as UiUtils;
import 'package:learnwayv2/shared/widgets/buttons.dart';

Future<bool> showTransactionConfirmationDialog({
  required BuildContext context,
  required String amount,
  required String recipientAddress,
  required double availableBalance,
  required TextEditingController? amountController,
  required TextEditingController? addressController,
  required VoidCallback? onResetCalled,
  String? gasEstimate,
  String? tokenSymbol = 'LWT',
}) async {
  return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return TransactionConfirmationDialog(
            amount: amount,
            recipientAddress: recipientAddress,
            availableBalance: availableBalance,
            gasEstimate: gasEstimate,
            tokenSymbol: tokenSymbol!,
            amountController: amountController!,
            addressController: addressController!,
            onResetCalled: onResetCalled,
            key: null,
          );
        },
      ) ??
      false;
}

class TransactionConfirmationDialog extends StatefulWidget {
  const TransactionConfirmationDialog({
    required this.amount,
    required this.recipientAddress,
    required this.availableBalance,
    required this.amountController,
    required this.addressController,
    required this.onResetCalled,
    required super.key,
    this.gasEstimate,
    this.tokenSymbol = 'LWT',
  });
  final String amount;
  final String recipientAddress;
  final double availableBalance;
  final String? gasEstimate;
  final String tokenSymbol;
  final TextEditingController amountController;
  final TextEditingController addressController;
  final VoidCallback? onResetCalled;

  @override
  State<TransactionConfirmationDialog> createState() =>
      _TransactionConfirmationDialogState();
}

class _TransactionConfirmationDialogState
    extends State<TransactionConfirmationDialog> {
  int _activeStep = 0;
  bool visible = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.cancel),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Transfer Confirmation',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                textAlign: TextAlign.center,
                'Check details before proceeding with transaction.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            // Transaction Details
            _buildDetailRow(
              title: 'Amount:',
              value: '${widget.amount} ${widget.tokenSymbol}',
              valueColor: Colors.black,
              isBold: true,
            ),

            _buildDetailRow(
              title: 'Recipient:',
              value: UiUtils.shortenAddress(widget.recipientAddress),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            _buildDetailRow(
              title: 'Network',
              value: 'Lisk',
              image: 'lisk_icon.svg',
            ),
            _buildDetailRow(title: 'Fee:', value: '0.1 LWT'),
          ],
        ),
      ),
      actions: [
        BlocConsumer<WalletCubit, WalletState>(
          listener: (context, state) {
            if (state.isSendingTransaction) {
              setState(() {
                _activeStep = 1;
                visible = true;
              });
            } else if (state.isTransactionSuccessful) {
              setState(() {
                _activeStep = 2;
                visible = false;
              });
              UiUtils.showSnackBar('Transaction is successful', context);
            } else if (state.hasTransactionError) {
              UiUtils.showSnackBar(state.transactionError!, context);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                TransactionProgress(
                  currentStep: _activeStep,
                  steps: FinanceSteps.transactionFlow,
                  activeColor: Colors.blue,
                  completedColor: Colors.green,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Visibility(
                      visible: visible,
                      child: Expanded(
                        child:
                            state.isSendingTransaction
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : ButtonFactory.blackButton(
                                  text: 'Send',
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  onPressed: () {
                                    context.read<WalletCubit>().transferToken(
                                      amount: widget.amount,
                                      recipientAddress: widget.recipientAddress,
                                    );
                                  },
                                ),
                      ),
                    ),
                    HSpace(10),
                    if (state.isTransactionSuccessful)
                      Expanded(
                        child: ButtonFactory.blackButton(
                          mainAxisAlignment: MainAxisAlignment.center,
                          text: 'Go Back',
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.of(context).pop(true);
                          },
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required String title,
    required String value,
    String? image,
    Color? valueColor,
    bool isBold = false,
    int maxLines = 2,
    TextOverflow overflow = TextOverflow.visible,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                // if (image != null && image.isNotEmpty)
                //   SvgPicture.asset(Img.get(image), width: 25),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                    color: valueColor,
                  ),
                  maxLines: maxLines,
                  overflow: overflow,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
