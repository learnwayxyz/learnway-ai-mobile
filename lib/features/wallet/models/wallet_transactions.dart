class LearnWayTransaction {
  LearnWayTransaction({
    required this.transactionHash,
    required this.sender,
    required this.recipient,
    required this.amount,
    required this.blockTimestamp,
    required this.tokenAddress,
    required this.rawInput,
  });

  factory LearnWayTransaction.fromJson(Map<String, dynamic> json) {
    return LearnWayTransaction(
      transactionHash: json['transaction_hash'] as String,
      sender: json['sender'] as String,
      recipient: json['recipient'] as String,
      amount: json['amount'] as String,
      blockTimestamp: json['block_timestamp'] as String,
      tokenAddress: json['token_address'] as String,
      rawInput: json['raw_input'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_hash': transactionHash,
      'sender': sender,
      'recipient': recipient,
      'amount': amount,
      'block_timestamp': blockTimestamp,
      'token_address': tokenAddress,
      'raw_input': rawInput,
    };
  }

  final String transactionHash;
  final String sender;
  final String recipient;
  final String amount;
  final String blockTimestamp;
  final String tokenAddress;
  final String rawInput;

  DateTime get timestamp {
    final timestampInt = int.tryParse(blockTimestamp);
    if (timestampInt == null) return DateTime.now();
    return DateTime.fromMillisecondsSinceEpoch(timestampInt * 1000);
  }

  String get amountInEth {
    try {
      final bigIntAmount = BigInt.parse(amount);
      final double ethAmount = bigIntAmount / BigInt.from(10).pow(18);
      return ethAmount.toStringAsFixed(6);
    } catch (e) {
      return '0.000000';
    }
  }

  String get shortTxHash {
    if (transactionHash.length < 10) return transactionHash;
    return '${transactionHash.substring(0, 6)}...${transactionHash.substring(transactionHash.length - 4)}';
  }

  String shortAddress(String addr) {
    if (addr.length < 10) return addr;
    return '${addr.substring(0, 6)}...${addr.substring(addr.length - 4)}';
  }

  String get shortSender => shortAddress(sender);

  String get shortRecipient => shortAddress(recipient);

  String get formattedDate {
    return '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}

class TransactionResponse {
  TransactionResponse({
    required this.success,
    required this.count,
    required this.data,
    this.error,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      success: json['success'] as bool? ?? false,
      count: json['count'] as int? ?? 0,
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) =>
                    LearnWayTransaction.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      error: json['error'] as String?,
    );
  }

  final bool success;
  final int count;
  final List<LearnWayTransaction> data;
  final String? error;
}

class SingleTransactionResponse {
  SingleTransactionResponse({required this.success, this.data, this.error});

  factory SingleTransactionResponse.fromJson(Map<String, dynamic> json) {
    return SingleTransactionResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null
          ? LearnWayTransaction.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      error: json['error'] as String?,
    );
  }

  final bool success;
  final LearnWayTransaction? data;
  final String? error;
}

class StatsResponse {
  StatsResponse({required this.success, required this.total, this.error});

  factory StatsResponse.fromJson(Map<String, dynamic> json) {
    return StatsResponse(
      success: json['success'] as bool? ?? false,
      total: json['total'] as int? ?? 0,
      error: json['error'] as String?,
    );
  }

  final bool success;
  final int total;
  final String? error;
}

class PaginationInfo {
  PaginationInfo({
    required this.currentPage,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['currentPage'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 100,
      totalCount: json['totalCount'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'pageSize': pageSize,
      'totalCount': totalCount,
      'totalPages': totalPages,
    };
  }

  final int currentPage;
  final int pageSize;
  final int totalCount;
  final int totalPages;

  bool get hasNext => currentPage < totalPages;
  bool get hasPrevious => currentPage > 1;
}
