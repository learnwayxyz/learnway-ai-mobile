import 'dart:convert';
import 'dart:developer';
import 'dart:developer' as dev;
import 'dart:io' as io;

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:http/http.dart' as http;
import 'package:icloud_storage/icloud_storage.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/services/interfaces.dart';
import 'package:path_provider/path_provider.dart';

const List<String> _driveScopes = <String>[
  'https://www.googleapis.com/auth/drive.appdata',
];

class _AuthenticatedClient extends http.BaseClient {
  final http.Client _inner;
  final Map<String, String> _headers;

  _AuthenticatedClient(this._inner, this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _inner.send(request);
  }
}

class GoogleCloudServices implements ICloudServices {
  @override
  Future<bool?> upload(String encryptedValue) async {
    final client = await getClient();
    if (client == null) {
      return null;
    }
    final drive = DriveApi(client);
    final file = await drive.files.create(
      File()
        ..name = ICloudServices.resourceIdentifier
        ..parents = ['appDataFolder'],
      uploadMedia: Media(
        Stream.fromIterable([encryptedValue.codeUnits]),
        encryptedValue.length,
      ),
    );
    if (file.id != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> download() async {
    final client = await getClient();
    final driveApi = DriveApi(client!);
    final fileList = await driveApi.files.list(
      spaces: 'appDataFolder',
      q: 'name="${ICloudServices.resourceIdentifier}"',
      $fields: 'files(id,name)',
    );

    final file = fileList.files?.first;
    if (file == null) {
      return {};
    }
    log('download(): file is ${file.id}');
    final media =
        await driveApi.files.get(
              file.id!,
              downloadOptions: DownloadOptions.fullMedia,
            )
            as Media;
    final contents = await media.stream.transform(utf8.decoder).join();
    log('contents is $contents');
    final json = jsonDecode(contents);
    log('json is $json');
    return json as Map<String, dynamic>;
  }

  @override
  Future<bool?> backUpExists() async {
    log('backUpExists');
    final client = await getClient();
    final driveApi = DriveApi(client!);

    final fileList = await driveApi.files.list(
      spaces: 'appDataFolder',
      q: "name='${ICloudServices.resourceIdentifier}'",
      $fields: 'files(id,name)',
    );

    if (fileList.files == null || fileList.files!.isEmpty) {
      return false;
    }

    final file = fileList.files?.first;
    log('file is ${file?.id}');
    return file?.name == ICloudServices.resourceIdentifier;
  }

  @override
  Future<void> deleteFile() async {
    final client = await getClient();
    final driveApi = DriveApi(client!);
    final fileList = await driveApi.files.list(
      spaces: 'appDataFolder',
      q: "name='${ICloudServices.resourceIdentifier}'",
      $fields: 'files(id,name)',
    );
    log('all files ${fileList.files?.toList()}');
    final file = fileList.files?.first.id;
    await driveApi.files.delete(file!);
  }

  Future<http.Client?> getClient() async {
    if (!locator.isRegistered<GoogleSignInAccount>()) return null;
    final account = locator<GoogleSignInAccount>();
    try {
      GoogleSignInClientAuthorization? authorization = await account
          .authorizationClient
          .authorizationForScopes(_driveScopes);
      authorization ??= await account.authorizationClient.authorizeScopes(
        _driveScopes,
      );

      final headers = await account.authorizationClient.authorizationHeaders(
        _driveScopes,
      );
      if (headers == null) return null;
      return _AuthenticatedClient(http.Client(), headers);
    } catch (e) {
      log('getClient error: $e');
      return null;
    }
  }

  @override
  Future<bool> isSignedIn() async {
    return locator.isRegistered<GoogleSignInAccount>();
  }
}

class IOSCloudService implements ICloudServices {
  @override
  Future<bool?> backUpExists() {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteFile() {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> download() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      await ICloudStorage.download(
        containerId: 'com.learnway.app',
        relativePath: 'appDataFolder',
        destinationFilePath: '${directory.path}/backups',
        onProgress: (stream) {
          stream.listen(
            (progress) => print('Download Progress: $progress'),
            onDone: () => print('Download Completed'),
            onError: (err) => print(err),
            cancelOnError: true,
          );
        },
      );
    } catch (e) {
      throw Exception(e.toString());
    }
    return {};
  }

  @override
  Future<bool> isSignedIn() {
    throw UnimplementedError();
  }

  @override
  Future<bool?> upload(String data) async {
    try {
      bool isCompleted = false;
      final directory = await getApplicationDocumentsDirectory();

      final file = io.File("${directory.path}/backups");
      if (data.isNotEmpty) {
        await file.writeAsString(data);
      }

      await ICloudStorage.upload(
        containerId: 'iCloud.com.learnway.app',
        filePath: file.path,
        destinationRelativePath:
            '${ICloudServices.resourceIdentifier}/${DateTime.now().millisecondsSinceEpoch}',
        onProgress: (stream) {
          stream.listen(
            (progress) => print('Upload Progress: $progress'),
            onDone: () {
              isCompleted = true;
              print('Upload completed');
            },
            onError: (err) {
              print('Upload error: $err');
            },
            cancelOnError: true,
          );
        },
      );

      return isCompleted;
    } catch (ex) {
      dev.log('Error uploading to iCloud: $ex');
      throw Exception('Failed to upload to iCloud: $ex');
    }
  }
}
