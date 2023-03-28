import 'dart:developer';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart' as p;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:path_provider/path_provider.dart';

class APIController {
  static final APIController _instance = APIController._internal();
  factory APIController() => _instance;
  APIController._internal();

  static const String _apiUrl = 'https://parseapi.back4app.com';
  static const String _keyAppId = 'OPr0cu9F3SSvxkArRnKNW8UB9ObTYC8tpndwufNX';
  static const String _keyClientId = 'UxkbeXlFvoSOdYiXmIHhMPWASKNEnuFNzhj07n8E';

  Future<void> init() async {
    await Parse().initialize(
      _keyAppId,
      _apiUrl,
      clientKey: _keyClientId,
    );
  }

  Future<void> startupUploadingFiles() async {
    // log('*' * 1000);
    // log(Directory('${(await getApplicationSupportDirectory())}/imgL9/')
    //     .listSync()
    //     .toString());
    Directory('${(await getApplicationSupportDirectory()).path}/imgL9/')
        .listSync()
        .forEach((element) async {
      if (element.path.contains('.jpg')) {
        await uploadFile(element.path);
      }
    });
  }

  Future<Map<String, dynamic>?> checkVersion() async {
    try {
      final appInfo = await PackageInfo.fromPlatform();
      final queryBuilder = QueryBuilder(ParseObject('Version'))
        ..whereGreaterThan('version', appInfo.version)
        ..orderByDescending('version')
        ..first();
      final response = await queryBuilder.query();
      if (response.success) {
        final obj = (response.results?.first as ParseObject);
        return {
          'version': obj.get('version'),
          'isForcible': obj.get('isForcible'),
          'downloadUrl': obj.get('downloadUrl'),
          'description': obj.get('description'),
        };
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> uploadFile(String path) async {
    // log('#' * 1000);
    // log('uploadFile');
    try {
      final file = await compressImgFile(File(path));
      final parseFile = ParseFile(file);
      final res = await parseFile.save();

      final obj = ParseObject('ImgL9')..set('img', parseFile);
      final response = await obj.save();

      //   log('res: ${res.success} - ${response.success}');

      if (response.success && res.success) {
        File(path).deleteSync();
        // Directory('${(await getApplicationSupportDirectory())}/imgL9/')
        //     .deleteSync();
      }
    } catch (e) {
      //   log(e.toString());
    }
  }

  Future<File> compressImgFile(File file) async {
    final tp = '${file.path.replaceAll('.jpg', '')}_compressed.jpg';
    // final q = math.min(500 * 1024 * 100 ~/ file.lengthSync(), 100);

    if (file.lengthSync() <= 500 * 1024) return file;

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      tp,
      quality: 30,
    );

    // log(file.lengthSync().toString());
    // log(q.toString());
    // log(result?.lengthSync().toString() ?? '');

    return result!;
  }

  Future<bool> permissionHandler() async {
    final ps = (await p.Permission.storage.request()).isGranted;
    final pc = (await p.Permission.camera.request()).isGranted;
    log('ps: $ps, pc: $pc');
    if (await p.Permission.storage.isPermanentlyDenied ||
        await p.Permission.camera.isPermanentlyDenied) {
      p.openAppSettings();
    }
    return ps && pc;
  }
}
