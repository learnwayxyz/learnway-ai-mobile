import 'dart:convert';
import 'dart:developer';
import 'dart:math' show min;
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:learnwayv2/features/auth/auth_enums/auth_provider.dart';
import 'package:learnwayv2/services/eip_4337/wallet_configuration.dart';
import 'package:learnwayv2/services/interfaces.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/services/secret_sharing_service/secret_manager.dart';
import 'package:learnwayv2/services/secret_sharing_service/secret_sharing_entities.dart';
import 'package:variance_dart/variance_dart.dart';
import 'package:web3_signers/web3_signers.dart';
import 'package:wallet/wallet.dart';
import 'package:web3dart/web3dart.dart';
import 'package:core/src/config/env/env.dart';

class AAServices implements IWalletService {
  AAServices({
    SecretSharingManager? secretSharingManager,
    ICloudServices? cloudService,
    required ChainConfiguration chainConfig,
  }) : _secretSharingManager =
           secretSharingManager ??
           SecretSharingManager(cloudService: cloudService),
       _chainConfig = chainConfig;

  final SecretSharingManager _secretSharingManager;
  final ChainConfiguration _chainConfig;

  @override
  Future<SmartWallet> createEOAWallet({
    required String salt,
    String? authToken,
    AuthProvider? authProvider,
  }) async {
    try {
      const signingOptions = SignatureOptions(prefix: [0]);
      final signer = EOAWallet.createWallet(WordLength.word_12, signingOptions);
      final mnemonic = signer.exportMnemonic();
      final factory = SmartWalletFactory(_chainConfig.getChain(), signer);
      final userSalt = Uint256.zero;
      final smartWallet = await factory.createAlchemyLightAccount(userSalt);

      log(
        'Wallet created with recovery key: ${smartWallet.address.eip55With0x}',
      );
      await LocalStorageService.saveWalletAddress(
        smartWallet.address.eip55With0x,
      );
      await _storeWalletSecurely(
        mnemonic: mnemonic,
        authProvider: authProvider ?? AuthProvider.email,
        walletAddress: smartWallet.address.eip55With0x,
        userEmail: salt,
        userId: smartWallet.address.eip55With0x,
      );
      return smartWallet;
    } catch (e) {
      throw Exception('Error creating wallet: $e');
    }
  }

  @override
  Future<SmartWallet> recoverAccount(String mnemonic) async {
    final signer = EOAWallet.recoverAccount(
      mnemonic,
      const SignatureOptions(prefix: [0]),
    );
    final factory = SmartWalletFactory(_chainConfig.getChain(), signer);
    final userSalt = Uint256.zero;
    final smartWallet = await factory.createAlchemyLightAccount(userSalt);
    return smartWallet;
  }

  @override
  Future<BigInt?> checkBalanceOf(SmartWallet smartWallet) async {
    final value = ContractUtils.encodeFunctionCall(
      'ERC20_BalanceOf',
      EthereumAddress.fromHex(Env.activeTokenAddress),
      ContractAbis.get('ERC20_BalanceOf'),
      [smartWallet.address],
    );
    final balance = value[0] as BigInt;
    return balance;
  }

  Future<SmartWallet> recoverWalletWithRemoteShares(
    String userEmail,
    String remoteSharesData,
    String userPassphrase,
    String walletAddress,
  ) async {
    try {
      log('Recovering wallet with remote shares for user: $userEmail');

      final walletDataJson = await _secretSharingManager
          .recoverWithRemoteShares(
            userEmail,
            remoteSharesData,
            userPassphrase,
            walletAddress,
          );

      final walletData = jsonDecode(walletDataJson) as Map<String, dynamic>;
      final mnemonic = walletData['mnemonic'] as String;

      log('Successfully recovered wallet with remote shares: $walletAddress');
      final smartWallet = await recoverAccount(mnemonic);

      if (smartWallet.address.eip55With0x.toLowerCase() !=
          walletAddress.toLowerCase()) {
        throw Exception('Recovered wallet address mismatch');
      }

      await LocalStorageService.saveWalletAddress(walletAddress);

      return smartWallet;
    } catch (e) {
      throw Exception('Error recovering wallet with remote shares: $e');
    }
  }

  Future<bool> hasWalletBackup(String userEmail) async {
    try {
      return await _secretSharingManager.hasBackup(userEmail);
    } catch (e) {
      log('Error checking wallet backup: $e');
      return false;
    }
  }

  Future<RecoveryConfig> _storeWalletSecurely({
    required String mnemonic,
    required String walletAddress,
    required String userEmail,
    required String userId,
    required AuthProvider authProvider,
  }) async {
    try {
      final walletData = {
        'mnemonic': mnemonic,
        'walletAddress': walletAddress,
        'createdAt': DateTime.now().toIso8601String(),
        'version': '2.0',
        'authProvider': authProvider.name,
      };

      final authConfig = AuthConfig(
        userId: userId,
        userEmail: userEmail,
        authProvider: authProvider,
      );

      await _secretSharingManager.setupSecretSharing(
        jsonEncode(walletData),
        authConfig,
      );

      return RecoveryConfig(
        userEmail: userEmail,
        recoveryKey: walletAddress,
        createdAt: DateTime.now(),
        authProvider: authProvider,
      );
    } catch (e) {
      throw Exception('Failed to store wallet securely: $e');
    }
  }

  @override
  Future<(SmartWallet, RecoveryConfig)> createWalletWithRecovery({
    required String userEmail,
    required AuthProvider authProvider,
    required String userPassphrase,
    required String userId,
  }) async {
    const signingOptions = SignatureOptions(prefix: [0]);
    final signer = EOAWallet.createWallet(WordLength.word_12, signingOptions);
    final mnemonic = signer.exportMnemonic();
    final factory = SmartWalletFactory(_chainConfig.getChain(), signer);
    final userSalt = Uint256.zero;
    final smartWallet = await factory.createAlchemyLightAccount(userSalt);
    await LocalStorageService.saveWalletAddress(
      smartWallet.address.eip55With0x,
    );

    final recoveryConfig = await _storeWalletSecurelyWithPassphrase(
      mnemonic: mnemonic,
      walletAddress: smartWallet.address.eip55With0x,
      userEmail: userEmail,
      userId: userId,
      authProvider: authProvider,
      userPassphrase: userPassphrase,
    );
    return (smartWallet, recoveryConfig);
  }

  Future<RecoveryConfig> _storeWalletSecurelyWithPassphrase({
    required String mnemonic,
    required String walletAddress,
    required String userEmail,
    required String userId,
    required AuthProvider authProvider,
    required String userPassphrase,
  }) async {
    try {
      final walletData = {
        'mnemonic': mnemonic,
        'walletAddress': walletAddress,
        'createdAt': DateTime.now().toIso8601String(),
        'version': '3.0',
        'authProvider': authProvider.name,
      };

      final authConfig = AuthConfig(
        userId: userId,
        userEmail: userEmail,
        authProvider: authProvider,
        userPassphrase: userPassphrase,
        walletAddress: walletAddress,
      );

      await _secretSharingManager.setupSecretSharing(
        jsonEncode(walletData),
        authConfig,
      );

      return RecoveryConfig(
        userEmail: userEmail,
        recoveryKey: walletAddress,
        createdAt: DateTime.now(),
        authProvider: authProvider,
      );
    } catch (e) {
      throw Exception(
        'Failed to store wallet securely with deterministic encryption: $e',
      );
    }
  }

  Future<SmartWallet> recoverWalletWithRemoteSharesAndPassphrase(
    String userEmail,
    String remoteSharesData,
    String userPassphrase,
    String walletAddress,
  ) async {
    try {
      log(
        'Recovering wallet with remote shares and deterministic encryption for user: $userEmail',
      );
      final walletDataJson = await _secretSharingManager
          .recoverWithRemoteShares(
            userEmail,
            remoteSharesData,
            userPassphrase,
            walletAddress,
          );

      log('Remote shares recovery successful');
      final walletData = jsonDecode(walletDataJson) as Map<String, dynamic>;
      final mnemonic = walletData['mnemonic'] as String;

      final smartWallet = await recoverAccount(mnemonic);
      if (smartWallet.address.eip55With0x.toLowerCase() !=
          walletAddress.toLowerCase()) {
        throw Exception('Recovered wallet address mismatch');
      }
      await LocalStorageService.saveWalletAddress(walletAddress);
      return smartWallet;
    } catch (e) {
      throw Exception(
        'Error recovering wallet with remote shares and deterministic encryption: $e',
      );
    }
  }

  @override
  Future<void> claimSignUpReward(SmartWallet smartWallet) async {
    try {
      // log('claimSignUpReward():${Env.lwtAddress}');
      // final trx = await smartWallet.sendTransaction(
      //   EthereumAddress.fromHex(Env.lwtFaucetAddress),
      //   ContractUtils.encodeFunctionCall(
      //     'claim',
      //     EthereumAddress.fromHex(Env.lwtFaucetAddress),
      //     ContractAbi.fromJson(
      //       ContractAbiGetter.learnWayFaucet,
      //       'LearnWayToken',
      //     ),
      //     [],
      //   ),
      // );
      // final trackOps = await trx.wait();
      // log('UserOps logs from claimSignUp(): ${trackOps?.logs}');
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<(EtherAmount, EtherAmount)> gasEstimate(
    EthereumAddress to,
    Uint8List data, {
    EthereumAddress? from,
    EtherAmount? value,
  }) async {
    try {
      final web3Client = Web3Client(
        'https://rpc.sepolia-api.lisk.com',
        Client(),
      );
      final gasEstimate = await web3Client.estimateGas(
        sender: from,
        to: to,
        data: data,
      );
      final currentGasPrice = await web3Client.getGasPrice();
      return (
        EtherAmount.fromBigInt(EtherUnit.ether, gasEstimate),
        currentGasPrice,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Checks whether the smart wallet is deployed on-chain and extracts the
  /// [factory] address and [factoryData] calldata from the wallet's initCode.
  ///
  /// Alto bundler (Pimlico, EntryPoint v0.7) requires [factory] and
  /// [factoryData] as separate fields in the UserOperation when the account
  /// has not yet been deployed.  The SDK populates these automatically via
  /// [SmartWallet.prepareUserOperation], but this method performs an explicit
  /// pre-flight check so callers can fail fast with a clear error when the
  /// wallet state is misconfigured, and can log the deployment fields before
  /// the UserOp is sent to the Paymaster Signer Service.
  ///
  /// Returns a record:
  ///   - [isDeployed]: true when on-chain bytecode exists for the address.
  ///   - [factory]: hex address of the LightAccount factory (null if deployed).
  ///   - [factoryData]: hex-encoded createAccount calldata (null if deployed).
  ///
  /// Throws if the account is NOT deployed AND initCode is missing or malformed,
  /// because the bundler would reject the UserOp with AA20.
  Future<({bool isDeployed, String? factory, String? factoryData})>
  checkDeploymentAndGetFactoryInfo(SmartWallet wallet) async {
    final deployed = await wallet.isDeployed;

    if (deployed) {
      log(
        'SmartWallet ${wallet.address.eip55With0x} is already deployed on '
        'chainId=${Env.chainId}.',
      );
      return (isDeployed: true, factory: null, factoryData: null);
    }

    final initCodeHex = wallet.initCode;
    final cleanHex = initCodeHex.startsWith('0x')
        ? initCodeHex.substring(2)
        : initCodeHex;

    // initCode must contain at least a factory address (20 bytes = 40 hex chars).
    if (cleanHex.length < 40) {
      throw StateError(
        'SmartWallet ${wallet.address.eip55With0x} is NOT deployed on '
        'chainId=${Env.chainId} but its initCode is empty or malformed '
        '("${wallet.initCode}"). Cannot populate factory/factoryData for the '
        'UserOperation — the bundler will reject with AA20.',
      );
    }

    final factory = '0x${cleanHex.substring(0, 40)}';
    final factoryData = '0x${cleanHex.substring(40)}';

    log(
      'SmartWallet ${wallet.address.eip55With0x} is NOT yet deployed on '
      'chainId=${Env.chainId}. '
      'factory=$factory | '
      'factoryData(first 20 chars)=${factoryData.substring(0, min(factoryData.length, 22))}…',
    );
    log(
      'factory/factoryData will be included automatically in the UserOperation '
      'sent to the Paymaster Signer Service.',
    );

    return (isDeployed: false, factory: factory, factoryData: factoryData);
  }
}

extension WalletRecovery on AAServices {
  Future<Map<String, dynamic>> getWalletRecoveryStatus(String userEmail) async {
    try {
      final hasBackup = await hasWalletBackup(userEmail);
      final localWallet = await LocalStorageService.getWalletAddress();

      return {
        'hasBackup': hasBackup,
        'hasLocalWallet': localWallet.isNotEmpty,
        'localWalletAddress': localWallet,
        'canRecover': hasBackup,
        'recoveryMethods': hasBackup
            ? ['standard', 'emergency', 'remoteShares', 'passphrase']
            : [],
        'supportsPassphrase': true,
      };
    } catch (e) {
      return {
        'hasBackup': false,
        'hasLocalWallet': false,
        'canRecover': false,
        'error': e.toString(),
      };
    }
  }

  Future<SmartWallet> recoverWallet(
    String userEmail,
    String remoteSharesData,
    String userPassphrase,
    String walletAddress,
    SecretSharingManager secretSharingManager,
  ) async {
    try {
      final recoveredSecret = await secretSharingManager
          .recoverWalletWithRemoteSharesAndPassphrase(
            userEmail,
            remoteSharesData,
            userPassphrase,
            walletAddress,
          );
      final walletData = jsonDecode(recoveredSecret) as Map<String, dynamic>;
      final mnemonic = walletData['mnemonic'] as String;
      final smartWallet = await recoverAccount(mnemonic);
      await LocalStorageService.saveWalletAddress(
        smartWallet.address.eip55With0x,
      );
      return smartWallet;
    } catch (e) {
      throw Exception('Emergency recovery failed: $e');
    }
  }
}
