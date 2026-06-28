import 'package:equatable/equatable.dart';
import 'package:learnwayv2/features/leader_board/models/leaderboard_entry_model.dart';

class LeaderboardResponseModel extends Equatable {
  final String period;
  final List<LeaderboardEntryModel> entries;
  final PaginationModel pagination;

  const LeaderboardResponseModel({
    required this.period,
    required this.entries,
    required this.pagination,
  });

  factory LeaderboardResponseModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardResponseModel(
      period: json['period'] as String,
      entries: (json['entries'] as List<dynamic>)
          .map((e) => LeaderboardEntryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'period': period,
      'entries': entries.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }

  @override
  List<Object?> get props => [period, entries, pagination];
}

class PaginationModel extends Equatable {
  final int limit;
  final int offset;
  final int total;

  const PaginationModel({
    required this.limit,
    required this.offset,
    required this.total,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      limit: json['limit'] as int,
      offset: json['offset'] as int,
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'limit': limit,
      'offset': offset,
      'total': total,
    };
  }

  @override
  List<Object?> get props => [limit, offset, total];
}
