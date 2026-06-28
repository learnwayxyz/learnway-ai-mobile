// import 'package:learnwayv2/gen/assets.gen.dart';

// enum ContestType { ongoing, upcoming, finished, private }

// ///create a base model for ContestCardModel and Contest
// ///

// class LearnWayContestBaseModel {}

// class ContestCardModel {
//   ContestCardModel({
//     required this.title,
//     required this.hostName,
//     required this.imageUrl,
//     required this.id,
//     required this.startTime,
//     required this.participantIcon,
//     required this.type,
//     required this.participantCount,
//     required this.gemsIconPath,
//     required this.fees,
//     this.isPrivateContest = false,
//     this.endTime,
//     this.timeLeft,
//     this.pricePool,
//   });

//   final String hostName;
//   final String participantIcon;
//   final String gemsIconPath;
//   final DateTime? startTime;
//   final DateTime? endTime;
//   final DateTime? timeLeft;
//   final String? pricePool;
//   final String participantCount;
//   final bool isPrivateContest;
//   final String fees;
//   final String title;
//   final String imageUrl;
//   final String id;
//   final ContestType type;
// }

// List<ContestCardModel> get contests {
//   final allContests = List<ContestCardModel>.from(_contestsList);
//   allContests.sort((a, b) {
//     if (a.isPrivateContest && !b.isPrivateContest) {
//       return -1;
//     } else if (!a.isPrivateContest && b.isPrivateContest) {
//       return 1;
//     }
//     return 0;
//   });
//   return allContests;
// }

// List<ContestCardModel> _contestsList = [
//   ContestCardModel(
//     title: 'TON & Oyster Labs Ecosystem Quiz Contest',
//     hostName: 'OYSTER LABS',
//     imageUrl: Assets.images.contest1.path,
//     id: '1',
//     startTime: DateTime.now(),
//     fees: '50',
//     participantIcon: Assets.icons.participantIcon,
//     type: ContestType.ongoing,
//     participantCount: '100',
//     gemsIconPath: Assets.images.feeGem,
//   ),
//   ContestCardModel(
//     title: 'TON & Oyster Labs Ecosystem Quiz Contest',
//     hostName: 'OYSTER LABS',
//     imageUrl: Assets.images.contest1.path,
//     id: '2',
//     startTime: DateTime.now(),
//     fees: '50',
//     participantIcon: Assets.icons.participantIcon,
//     type: ContestType.ongoing,
//     participantCount: '100',
//     gemsIconPath: Assets.images.feeGem,
//   ),
//   ContestCardModel(
//     title: 'TON & Oyster Labs Ecosystem Quiz Contest',
//     hostName: 'OYSTER LABS',
//     imageUrl: Assets.images.contest2.path,
//     id: '3',
//     startTime: DateTime.now(),
//     fees: '50',
//     participantIcon: Assets.icons.participantIcon,
//     type: ContestType.ongoing,
//     participantCount: '100',
//     gemsIconPath: Assets.images.feeGem,
//   ),
//   ContestCardModel(
//     title: 'TON & Oyster Labs Ecosystem Quiz Contest',
//     hostName: 'OYSTER LABS',
//     imageUrl: Assets.images.contest1.path,
//     id: '4',
//     startTime: DateTime.now(),
//     fees: '50',
//     participantIcon: Assets.icons.participantIcon,

//     type: ContestType.upcoming,
//     participantCount: '100',
//     gemsIconPath: Assets.images.feeGem,
//   ),
//   ContestCardModel(
//     title: 'TON & Oyster Labs Ecosystem Quiz Contest',
//     hostName: 'OYSTER LABS',
//     imageUrl: Assets.images.contest1.path,
//     id: '5',
//     startTime: DateTime.now(),
//     fees: '50',
//     participantIcon: Assets.icons.participantIcon,

//     type: ContestType.upcoming,
//     participantCount: '100',
//     gemsIconPath: Assets.images.feeGem,
//   ),
//   ContestCardModel(
//     title: 'TON & Oyster Labs Ecosystem Quiz Contest',
//     hostName: 'OYSTER LABS',
//     imageUrl: Assets.images.contest1.path,
//     id: '6',
//     startTime: DateTime.now(),
//     fees: '50',
//     participantIcon: Assets.icons.participantIcon,

//     type: ContestType.upcoming,
//     participantCount: '100',
//     gemsIconPath: Assets.images.feeGem,
//   ),
//   ContestCardModel(
//     title: 'TON & Oyster Labs Ecosystem Quiz Contest',
//     hostName: 'OYSTER LABS',
//     imageUrl: Assets.images.contest1.path,
//     id: '7',
//     startTime: DateTime.now(),
//     fees: '50',
//     participantIcon: Assets.icons.participantIcon,

//     type: ContestType.finished,
//     participantCount: '100',
//     gemsIconPath: Assets.images.feeGem,
//   ),
//   ContestCardModel(
//     title: 'TON & Oyster Labs Ecosystem Quiz Contest',
//     hostName: 'OYSTER LABS',
//     imageUrl: Assets.images.contest1.path,
//     id: '8',
//     startTime: DateTime.now(),
//     fees: '50',
//     participantIcon: Assets.icons.participantIcon,

//     type: ContestType.finished,
//     participantCount: '100',
//     gemsIconPath: Assets.images.feeGem,
//   ),
//   ContestCardModel(
//     title: 'TON & Oyster Labs Ecosystem Quiz Contest',
//     hostName: 'OYSTER LABS',
//     imageUrl: Assets.images.contest1.path,
//     id: '9',
//     startTime: DateTime.now(),
//     fees: '50',
//     participantIcon: Assets.icons.participantIcon,

//     type: ContestType.finished,
//     participantCount: '100',
//     gemsIconPath: Assets.images.feeGem,
//   ),
//   ContestCardModel(
//     title: 'TON & Oyster Labs Ecosystem Quiz Contest',
//     hostName: 'OYSTER LABS',
//     imageUrl: Assets.images.contest1.path,
//     id: '10',
//     isPrivateContest: true,
//     startTime: DateTime.now(),
//     fees: '50',
//     participantIcon: Assets.icons.participantIcon,

//     type: ContestType.finished,
//     participantCount: '100',
//     gemsIconPath: Assets.images.feeGem,
//   ),
// ];
