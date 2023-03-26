import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

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

  Future<String?> checkVersion() async {
    try {
      final appInfo = await PackageInfo.fromPlatform();
      final queryBuilder = QueryBuilder(ParseObject('Version'))
        ..whereGreaterThan('version', appInfo.version)
        ..orderByDescending('version')
        ..first();
      final response = await queryBuilder.query();
      if (response.success) {
        final url = (response.results?.first as ParseObject).get('downloadUrl')
            as String;
        return url;
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> uploadFile(String path) async {
    try {
      final file = await compressImgFile(File(path));
      final parseFile = ParseFile(file);
      final res = await parseFile.save();

      final obj = ParseObject('ImgL9')..set('img', parseFile);
      final response = await obj.save();

      if (response.success && res.success) {
        Directory('${(await getApplicationSupportDirectory())}/imgL9/')
            .deleteSync();
      }
    } catch (e) {}
  }

  Future<File> compressImgFile(File file) async {
    final tp = '${file.path.replaceAll('.jpg', '')}_compressed.jpg';
    final q = math.min(500 * 1024 * 100 ~/ file.lengthSync(), 100);

    if (file.lengthSync() <= 500 * 1024) return file;

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      tp,
      quality: q,
    );

    log(file.lengthSync().toString());
    log(q.toString());
    log(result?.lengthSync().toString() ?? '');

    return result!;
  }
}
