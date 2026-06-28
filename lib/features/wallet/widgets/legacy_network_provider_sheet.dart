// import 'package:flutter/material.dart';
// import 'package:learnwayv2/features/wallet/widgets/network_provider_sheet.dart';
// import 'package:learnwayv2/shared/style/colors.dart';
// import 'package:learnwayv2/shared/style/text_style.dart';
// import 'package:learnwayv2/shared/utilities/standard_spacer.dart';

// /// Legacy version of NetworkProviderBottomSheet for backward compatibility
// /// Use this for screens that don't have country/payment channel selection
// class LegacyNetworkProviderBottomSheet extends StatelessWidget {
//   final List<MobileMoneyNetwork> networks;
//   final String? selectedNetwork;
//   final Function(String) onNetworkSelected;

//   const LegacyNetworkProviderBottomSheet({
//     super.key,
//     required this.networks,
//     required this.selectedNetwork,
//     required this.onNetworkSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Color(0xffF8F9FC),
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(25),
//           topRight: Radius.circular(25),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           const VSpace(22),
//           Text('Network Provider', style: AppTextStyles.baseSemiBold(context)),
//           const VSpace(11),
//           Divider(color: AppColors.gray200, height: 1),
//           const VSpace(30),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               children: networks.map((network) {
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 16),
//                   child: LegacyNetworkOption(
//                     icon: network.icon,
//                     title: network.name,
//                     isSelected: selectedNetwork == network.name,
//                     onTap: () {
//                       onNetworkSelected(network.name);
//                       Navigator.pop(context);
//                     },
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//           const VSpace(20),
//           VSpace(MediaQuery.of(context).padding.bottom),
//         ],
//       ),
//     );
//   }
// }

// class LegacyNetworkOption extends StatelessWidget {
//   final String icon;
//   final String title;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const LegacyNetworkOption({
//     super.key,
//     required this.icon,
//     required this.title,
//     this.isSelected = false,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           children: [
//             Image(image: AssetImage(icon), width: 40, height: 40),
//             const HSpace(16),
//             Expanded(
//               child: Text(
//                 title,
//                 style: AppTextStyles.smSemiBold(
//                   context,
//                 ).copyWith(color: AppColors.gray900),
//               ),
//             ),
//             if (isSelected)
//               Icon(Icons.check_circle, color: AppColors.gray900, size: 24),
//           ],
//         ),
//       ),
//     );
//   }
// }
