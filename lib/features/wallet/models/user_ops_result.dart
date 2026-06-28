class UserOpsResult {
  UserOpsResult({this.task});

  factory UserOpsResult.fromJson(Map<String, dynamic> json) {
    return UserOpsResult(
      task: json['task'] != null
          ? Task.fromJson(json['task'] as Map<String, dynamic>)
          : null,
    );
  }

  final Task? task;

  Map<String, dynamic> toJson() => {if (task != null) 'task': task!.toJson()};
}

class Task {
  const Task({
    this.chainId,
    this.taskId,
    this.taskState,
    this.creationDate,
    this.lastCheckDate,
    this.lastCheckMessage,
    this.transactionHash,
    this.blockNumber,
    this.gasUsed,
    this.effectiveGasPrice,
    this.executionDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      chainId: json['chainId'] as int?,
      taskId: json['taskId'] as String?,
      taskState: json['taskState'] as String?,
      creationDate: json['creationDate'] != null
          ? DateTime.tryParse(json['creationDate'] as String)
          : null,
      lastCheckDate: json['lastCheckDate'] != null
          ? DateTime.tryParse(json['lastCheckDate'] as String)
          : null,
      lastCheckMessage: json['lastCheckMessage'] as String?,
      transactionHash: json['transactionHash'] as String?,
      blockNumber: json['blockNumber'] as int?,
      gasUsed: json['gasUsed']?.toString(),
      effectiveGasPrice: json['effectiveGasPrice']?.toString(),
      executionDate: json['executionDate'] != null
          ? DateTime.tryParse(json['executionDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    if (chainId != null) 'chainId': chainId,
    if (taskId != null) 'taskId': taskId,
    if (taskState != null) 'taskState': taskState,
    if (creationDate != null) 'creationDate': creationDate!.toIso8601String(),
    if (lastCheckDate != null)
      'lastCheckDate': lastCheckDate!.toIso8601String(),
    if (lastCheckMessage != null) 'lastCheckMessage': lastCheckMessage,
    if (transactionHash != null) 'transactionHash': transactionHash,
    if (blockNumber != null) 'blockNumber': blockNumber,
    if (gasUsed != null) 'gasUsed': gasUsed,
    if (effectiveGasPrice != null) 'effectiveGasPrice': effectiveGasPrice,
    if (executionDate != null)
      'executionDate': executionDate!.toIso8601String(),
  };

  final int? chainId;
  final String? taskId;
  final String? taskState;
  final DateTime? creationDate;
  final DateTime? lastCheckDate;
  final String? lastCheckMessage;
  final String? transactionHash;
  final int? blockNumber;
  final String? gasUsed;
  final String? effectiveGasPrice;
  final DateTime? executionDate;
}
