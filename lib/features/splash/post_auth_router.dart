// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:learnwayv2/features/home/home_bloc/home_bloc.dart';
// import 'package:learnwayv2/features/home/home_bloc/home_event.dart';
// import 'package:learnwayv2/features/home/home_bloc/home_state.dart';
// import 'package:learnwayv2/router/app_router.dart';
// import 'package:learnwayv2/services/storage/shared_preferences_store.dart';
// import 'package:learnwayv2/services/storage/shared_pref_keys.dart';
// import 'package:learnwayv2/shared/style/text_style.dart';
// import 'package:learnwayv2/shared/widgets/overlay_loader.dart';

// @RoutePage()
// class PostAuthRouterScreen extends StatefulWidget {
//   const PostAuthRouterScreen({super.key});

//   @override
//   State<PostAuthRouterScreen> createState() => _PostAuthRouterScreenState();
// }

// class _PostAuthRouterScreenState extends State<PostAuthRouterScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<HomeBloc>().add(FetchHomeDataEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<HomeBloc, HomeState>(
//       listener: (context, state) async {
//         if (state is FetchHomeDataSuccess) {
//           final hasHalfPrivateKey =
//               state.userProfile.halfPrivateKey?.isNotEmpty;

//           if (hasHalfPrivateKey != null && hasHalfPrivateKey == true) {
//             await SharedPreferencesStore.completeAccountSetup(
//               completeAccountSetupKey,
//               true,
//             );
//             if (context.mounted) {
//               context.router.replace(const MainActivityRoute());
//             }
//           } else {
//             if (context.mounted) {
//               context.router.replace(const WelcomeToSetupRoute());
//             }
//           }
//         }

//         if (state is FetchingHomeDataError) {
//           context.router.replace(const RegisterRoute());
//         }
//       },
//       child: Scaffold(
//         body: OverlayLoader(
//           isLoading: context.watch<HomeBloc>().state is FetchingHomeData,
//           child: Center(
//             child: Text(
//               'Loading...',
//               style: AppTextStyles.baseBold(
//                 context,
//               ).copyWith(color: Colors.white),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
