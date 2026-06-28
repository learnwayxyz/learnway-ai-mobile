enum TransactionType { send, receive, swap }

class TransactionDummyData {
  final TransactionType type;
  final String amount;
  final String date;

  TransactionDummyData({
    required this.type,
    required this.amount,
    required this.date,
  });
}

List<TransactionDummyData> transactionHistory = [
  TransactionDummyData(
    type: TransactionType.send,
    amount: '50 USDT',
    date: '2024-08-19',
  ),
  TransactionDummyData(
    type: TransactionType.receive,
    amount: '100 USDT',
    date: '2024-08-18',
  ),
  TransactionDummyData(
    type: TransactionType.swap,
    amount: '30 USDT',
    date: '2024-08-17',
  ),
  TransactionDummyData(
    type: TransactionType.send,
    amount: '25 USDT',
    date: '2024-08-16',
  ),
  TransactionDummyData(
    type: TransactionType.receive,
    amount: '75 USDT',
    date: '2024-08-15',
  ),
  TransactionDummyData(
    type: TransactionType.swap,
    amount: '40 USDT',
    date: '2024-08-14',
  ),
];
