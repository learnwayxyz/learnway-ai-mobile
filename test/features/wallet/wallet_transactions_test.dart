import 'package:flutter_test/flutter_test.dart';
import 'package:learnwayv2/features/wallet/models/wallet_transactions.dart';

void main() {
  Map<String, dynamic> transferJson({int? decimals}) => {
    'transaction_hash': '0xabc',
    'sender': '0x1',
    'recipient': '0x2',
    'amount': '100000',
    'block_timestamp': '1790820982',
    'token_address': '0xd077a400968890eacc75cdc901f0356c943e4fdb',
    'raw_input': '0x',
    if (decimals != null) 'decimals': decimals,
  };

  group('LearnWayTransaction.fromJson', () {
    test('reads per-transfer decimals from the API', () {
      final tx = LearnWayTransaction.fromJson(transferJson(decimals: 6));
      expect(tx.decimals, 6);
      expect(tx.toJson()['decimals'], 6);
    });

    test('leaves decimals null for older API responses', () {
      final tx = LearnWayTransaction.fromJson(transferJson());
      expect(tx.decimals, isNull);
    });
  });
}
