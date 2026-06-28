import 'dart:developer';

import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/contest/bloc/contest_bloc.dart';
import 'package:learnwayv2/features/contest/model/all_contest_model.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/gen/assets.gen.dart';

Future<({bool success, ContestState? state})?> showPaymentBottomSheet({
  required BuildContext context,
  required Contest contest,
  required ContestBloc contestBloc,
  String? accessCode,
}) {
  return showModalBottomSheet<({bool success, ContestState? state})>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (context) => BlocProvider.value(
      value: contestBloc,
      child: PaymentBottomSheet(contest: contest, accessCode: accessCode),
    ),
  );
}

class PaymentBottomSheet extends StatefulWidget {
  const PaymentBottomSheet({super.key, required this.contest, this.accessCode});

  final Contest contest;
  final String? accessCode;

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentState = context.read<ContestBloc>().state;
      if (currentState is AccessCodeVerified && widget.accessCode != null) {
        context.read<ContestBloc>().add(
          ShowPaymentScreen(
            contest: widget.contest,
            accessCode: widget.accessCode!,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return BlocConsumer<ContestBloc, ContestState>(
      listener: (context, state) {
        if (state is PaymentSuccessful) {
          context.read<ContestBloc>().add(
            JoinContestEvent(
              contestId: widget.contest.id ?? '',
              accessCode: widget.accessCode,
            ),
          );
          return;
        }

        if (state is ContestJoined) {
          Navigator.of(
            context,
          ).pop((success: true, state: context.read<ContestBloc>().state));
          return;
        }
        if (state is ErrorJoiningContest) {
          Navigator.of(
            context,
          ).pop((success: false, state: context.read<ContestBloc>().state));
          Future.delayed(Duration.zero, () {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to join: ${state.message}'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          });
          return;
        }
        if (state is InsufficientGems) {
          _showInsufficientGemsDialog(state);
        }

        if (state is PaymentFailed) {
          log('Payment failed');
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: Container(
            padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _PaymentBottomSheetHeader(),
                    const VSpace(11),
                    const _PaymentDivider(),
                    const VSpace(24),
                    _buildContent(state),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(ContestState state) {
    return switch (state) {
      ShowingPayment() => _PaymentContent(state: state),
      ProcessingPayment() => const _ProcessingPaymentWidget(),
      PaymentSuccessful() => const _JoiningContestWidget(),
      JoiningContest() => const _JoiningContestWidget(),
      ContestJoined() => const _JoiningContestWidget(),
      _ => const _LoadingState(),
    };
  }

  void _showInsufficientGemsDialog(InsufficientGems state) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Insufficient Gems'),
        content: Text(
          'You need ${state.requiredGems} gems to join this contest.\n'
          'Your balance: ${state.userGemBalance} gems\n'
          'Required: ${state.requiredGems} gems\n'
          'Short by: ${state.shortfall} gems',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigate to gem store')),
              );
            },
            child: const Text('Get Gems'),
          ),
        ],
      ),
    );
  }
}

class _JoiningContestWidget extends StatelessWidget {
  const _JoiningContestWidget();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          VSpace(40),
          CircularProgressIndicator(),
          VSpace(24),
          Text('Joining contest...'),
          VSpace(40),
        ],
      ),
    );
  }
}

class _PaymentBottomSheetHeader extends StatelessWidget {
  const _PaymentBottomSheetHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, right: 16),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Join Contest',
                style: AppTextStyles.baseSemiBold(context),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.close, color: AppColors.gray900, size: 24),
          ),
        ],
      ),
    );
  }
}

class _PaymentDivider extends StatelessWidget {
  const _PaymentDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 2,
      decoration: BoxDecoration(
        color: AppColors.gray200,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(40.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ProcessingPaymentWidget extends StatelessWidget {
  const _ProcessingPaymentWidget();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          VSpace(40),
          CircularProgressIndicator(),
          VSpace(24),
          Text('Processing payment...'),
          VSpace(40),
        ],
      ),
    );
  }
}

class _PaymentContent extends StatelessWidget {
  const _PaymentContent({required this.state});

  final ShowingPayment state;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Your Gem Balance',
              style: AppTextStyles.smRegular(context),
            ),
          ),
          const VSpace(10),
          _BuildGemBalanceCard(balance: state.userGemBalance),
          const _BuildContestHowTo(),
          const VSpace(26),
          _BuildPaymentSummary(state: state, contest: state.contest),
          const VSpace(60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ButtonFactory.blackButton(
              onPressed: state.hasEnoughGems
                  ? () {
                      context.read<ContestBloc>().add(ProcessPayment());
                    }
                  : () {},
              mainAxisAlignment: MainAxisAlignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.hasEnoughGems ? 'Pay to Start' : 'Get More Gems',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const VSpace(58),
        ],
      ),
    );
  }
}

class _BuildGemBalanceCard extends StatelessWidget {
  const _BuildGemBalanceCard({required this.balance});
  final int balance;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.blueGray100,
        ),
        padding: const EdgeInsets.only(
          top: 10,
          left: 20,
          right: 20,
          bottom: 10,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 35,
                  width: 35,
                  child: Image.asset(Assets.images.singleDiamond.path),
                ),
                const HSpace(8),
                Text('$balance', style: AppTextStyles.xxlBold(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildPaymentSummary extends StatelessWidget {
  const _BuildPaymentSummary({required this.state, required this.contest});
  final Contest contest;
  final ShowingPayment state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.contest.description,
            style: AppTextStyles.xsRegular(context),
          ),
          const VSpace(5),
          Text(
            state.contest.title ?? '',
            style: AppTextStyles.baseSemiBold(context),
          ),
          const VSpace(13),
          const Divider(height: 1),
          const VSpace(13),
          _BuildInfoContainer(
            icon: Image(
              image: AssetImage(Assets.images.singleDiamond.path),
              height: 18,
              width: 18,
            ),
            label: 'Fees',
            value: contest.entryFee.toString(),
          ),
          if (!state.hasEnoughGems) ...[
            const VSpace(16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.error700,
                    size: 20,
                  ),
                  const HSpace(8),
                  Expanded(
                    child: Text(
                      'Insufficient gems. You need ${contest.entryFee ?? -state.userGemBalance} more gems.',
                      style: AppTextStyles.xs(
                        context,
                      ).copyWith(color: AppColors.error700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BuildContestHowTo extends StatelessWidget {
  const _BuildContestHowTo();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(Assets.icons.hintIcon),
          Text(
            'How Battle Works',
            style: AppTextStyles.smRegular(
              context,
            ).copyWith(color: AppColors.primaryMain),
          ),
        ],
      ),
    );
  }
}

class _BuildInfoContainer extends StatelessWidget {
  const _BuildInfoContainer({
    required this.icon,
    required this.label,
    required this.value,
  });
  final Widget icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.blueGray100,
        borderRadius: BorderRadius.circular(60),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$label: ',
                style: AppTextStyles.smBold(
                  context,
                ).copyWith(fontSize: 10, color: AppColors.gray600),
              ),
              icon,
              const HSpace(2),
              Flexible(
                child: Text(
                  value,
                  style: AppTextStyles.xsSemiBold(context),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
