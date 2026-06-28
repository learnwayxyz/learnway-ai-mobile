import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learnwayv2/features/wallet/cubit/swap_cubit.dart';
import 'package:learnwayv2/features/wallet/widgets/amount_input_field.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';

@RoutePage()
class SwapScreen extends StatefulWidget {
  const SwapScreen({super.key});

  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SwapCubit>().resetState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<SwapCubit>().init();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.standardAppBar(title: AppLocalizations.of(context)!.swap, barHeight: 10),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.swapGems,
                style: AppTextStyles.xxlBold(context),
              ),
              VSpace(10),
              Text(
                AppLocalizations.of(context)!.swapGemsForUsdtInstantly,
                style: AppTextStyles.baseRegular(context),
              ),
              const SizedBox(height: 40),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(color: Color(0xff0a1b2e0d), blurRadius: 20),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Column(
                      children: [
                        GemSwapCard(),
                        SizedBox(height: 20),
                        LWTSwapCard(),
                      ],
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 88 - 20,
                      child: Center(
                        child: Container(
                          width: 55,
                          height: 55,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white,
                            border: Border.all(color: Colors.white, width: 6),
                          ),
                          child: SvgPicture.asset(Assets.icons.walletSwap),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              const SwapEquatingText(),
              const SizedBox(height: 30),
              ButtonFactory.blackButton(
                mainAxisAlignment: MainAxisAlignment.center,
                textStyle: AppTextStyles.baseBold(
                  context,
                ).copyWith(color: Colors.white),
                onPressed: () {},
                text: AppLocalizations.of(context)!.swap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SwapEquatingText extends StatelessWidget {
  const SwapEquatingText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SwapCubit, SwapState>(
      builder: (context, state) {
        const defaultGemToTokenText = '1 Gem = 0.02 USDT';
        const defaultTokenToGemText = '1 USDT = 50 Gems';

        String displayText;

        if (state.type == SwapType.gem) {
          if (state.calculatedGemValue != 0.00 &&
              state.userInput != null &&
              state.userInput!.isNotEmpty) {
            displayText =
                '${state.userInput} Gems = ${state.calculatedGemValue} USDT';
          } else {
            displayText = defaultGemToTokenText;
          }
        } else {
          if (state.calculatedLwtValue != 0.00 &&
              state.userInput != null &&
              state.userInput!.isNotEmpty) {
            displayText =
                '${state.userInput} Token = ${state.calculatedLwtValue} Gems';
          } else {
            displayText = defaultTokenToGemText;
          }
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                displayText,
                style: AppTextStyles.xsMedium(
                  context,
                  color: const Color(0xff717A8C),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class GemSwapCard extends StatelessWidget {
  const GemSwapCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grayF7,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 22,
                            width: 22,
                            child: Image(
                              image: AssetImage(Assets.images.gems.path),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            AppLocalizations.of(context)!.gems,
                            style: AppTextStyles.sm(
                              context,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 100,
                      child: AmountInputField(
                        onChanged: (value) {
                          context.read<SwapCubit>().addInput(
                            value.toString(),
                            SwapType.gem,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    BlocBuilder<SwapCubit, SwapState>(
                      builder: (context, state) {
                        return Text(
                          '≈ ${state.calculatedGemValue}',
                          style: AppTextStyles.xs(context),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LWTSwapCard extends StatelessWidget {
  const LWTSwapCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grayF7,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 22,
                            width: 22,
                            child: Image(
                              image: AssetImage(Assets.images.tetherImage.path),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            AppLocalizations.of(context)!.usdt,
                            style: AppTextStyles.sm(
                              context,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
                const Spacer(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        child: AmountInputField(
                          onChanged: (value) {
                            context.read<SwapCubit>().addInput(
                              value.toString(),
                              SwapType.lwt,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      BlocBuilder<SwapCubit, SwapState>(
                        builder: (context, state) {
                          return Text(
                            '≈ ${state.calculatedLwtValue}',
                            style: AppTextStyles.xs(
                              context,
                              color: const Color(0xff707070),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
