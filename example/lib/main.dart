import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:whatsapp_stickers_injector/exceptions.dart';
import 'package:whatsapp_stickers_injector/whatsapp_stickers.dart';

void main() {
  runApp(AppRoot());
}

class AppRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('WhatsApp Stickers Flutter Demo'),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: ElevatedButton(
                    child: Text('Install from assets'),
                    onPressed: installFromAssets,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: ElevatedButton(
                    child: Text('Install from remote'),
                    onPressed: installFromRemote,
                  ),
                ),
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
          ),
        ),
      ),
    );
  }
}

const stickers = {
  '01_Cuppy_smile.webp': ['☕', '🙂'],
  '02_Cuppy_lol.webp': ['😄', '😀'],
  '03_Cuppy_rofl.webp': ['😆', '😂'],
  '04_Cuppy_sad.webp': ['😃', '😍'],
  '05_Cuppy_cry.webp': ['😭', '💧'],
  '06_Cuppy_love.webp': ['😍', '♥'],
  '07_Cuppy_hate.webp': ['💔', '👎'],
  '08_Cuppy_lovewithmug.webp': ['😍', '💑'],
  '09_Cuppy_lovewithcookie.webp': ['😘', '🍪'],
  '10_Cuppy_hmm.webp': ['🤔', '😐'],
  '11_Cuppy_upset.webp': ['😱', '😵'],
  '12_Cuppy_angry.webp': ['😡', '😠'],
  '13_Cuppy_curious.webp': ['❓', '🤔'],
  '14_Cuppy_weird.webp': ['🌈', '😜'],
  '15_Cuppy_bluescreen.webp': ['💻', '😩'],
  '16_Cuppy_angry.webp': ['😡', '😤'],
  '17_Cuppy_tired.webp': ['😩', '😨'],
  '18_Cuppy_workhard.webp': ['😔', '😨'],
  '19_Cuppy_shine.webp': ['🎉', '✨'],
  '20_Cuppy_disgusting.webp': ['🤮', '👎'],
  '21_Cuppy_hi.webp': ['🖐', '🙋'],
  '22_Cuppy_bye.webp': ['🖐', '👋'],
};

Future installFromAssets() async {
  File file = await copyAssetToLocal('assets/tray_Cuppy.png');
  File file1 = await copyAssetToLocal('assets/1.webp');
  File file2 = await copyAssetToLocal('assets/2.webp');
  File file3 = await copyAssetToLocal('assets/3.webp');

  var stickerPack = WhatsappStickers(
    identifier: 'cuppyFlutterWhatsAppStickers',
    name: 'Cuppy Flutter WhatsApp Stickers',
    publisher: 'John Doe',
    trayImageFileName: WhatsappStickerImage.fromFile(file.path),//WhatsappStickerImage.fromAsset('assets/tray_Cuppy.png'),
    publisherWebsite: '',
    privacyPolicyWebsite: '',
    licenseAgreementWebsite: '',
  );

  // stickers.forEach((sticker, emojis) {
  //   stickerPack.addSticker(WhatsappStickerImage.fromAsset('assets/$sticker'), emojis);
  // });
  // stickerPack.addSticker(WhatsappStickerImage.fromAsset('assets/processed_sticker_0.webp'), ['🖐', '👋']);
  // stickerPack.addSticker(WhatsappStickerImage.fromAsset('assets/processed_sticker_1.webp'), ['🖐', '👋']);
  // stickerPack.addSticker(WhatsappStickerImage.fromAsset('assets/processed_sticker_2.webp'), ['🖐', '👋']);
  stickerPack.addSticker(WhatsappStickerImage.fromFile(file1.path), ['🖐', '👋']);
  stickerPack.addSticker(WhatsappStickerImage.fromFile(file2.path), ['🖐', '👋']);
  stickerPack.addSticker(WhatsappStickerImage.fromFile(file3.path), ['🖐', '👋']);

  try {
    await stickerPack.sendToWhatsApp();
  } on WhatsappStickersException catch (e, s) {
    print('sendToWhatsApp ${e.cause},$s');
  }
}

/// 将 assets 文件拷贝到应用程序文档目录
/// [assetPath] assets文件路径，如: "assets/images/sticker.png"
/// [targetSubDir] 目标子目录（可选），如: "stickers"
/// [newFileName] 新文件名（可选），不指定则使用原文件名
Future<File> copyAssetToLocal(
    String assetPath, {
      String? targetSubDir,
      String? newFileName,
    }) async {
  try {
    // 1. 获取应用程序文档目录
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory targetDir = appDocDir;

    // 2. 如果指定了子目录，创建该目录
    if (targetSubDir != null && targetSubDir.isNotEmpty) {
      targetDir = Directory(path.join(appDocDir.path, targetSubDir));
      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }
    }

    // 3. 确定目标文件名
    String fileName = newFileName ?? path.basename(assetPath);
    String targetPath = path.join(targetDir.path, fileName);

    // 4. 读取 asset 数据
    ByteData data = await rootBundle.load(assetPath);

    // 5. 写入到本地文件
    List<int> bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );

    File file = File(targetPath);
    await file.writeAsBytes(bytes);

    print('✅ Asset copied: $assetPath -> $targetPath');
    return file;
  } catch (e) {
    print('❌ Failed to copy asset $assetPath: $e');
    rethrow;
  }
}

Future installFromRemote() async {
  var applicationDocumentsDirectory = await getApplicationDocumentsDirectory();
  var stickersDirectory = Directory('${applicationDocumentsDirectory.path}/stickers');
  await stickersDirectory.create(recursive: true);

  final dio = Dio();
  final downloads = <Future>[];

  stickers.forEach((sticker, emojis) {
    downloads.add(
      dio.download(
        'https://github.com/applicazza/whatsapp_stickers_plus/raw/master/example/assets/$sticker',
        '${stickersDirectory.path}/$sticker',
      ),
    );
  });

  await Future.wait(downloads);

  var stickerPack = WhatsappStickers(
    identifier: 'cuppyFlutterWhatsAppStickers',
    name: 'Cuppy Flutter WhatsApp Stickers',
    publisher: 'John Doe',
    trayImageFileName: WhatsappStickerImage.fromAsset('assets/tray_Cuppy.png'),
    publisherWebsite: '',
    privacyPolicyWebsite: '',
    licenseAgreementWebsite: '',
  );

  stickers.forEach((sticker, emojis) {
    stickerPack.addSticker(WhatsappStickerImage.fromFile('${stickersDirectory.path}/$sticker'), emojis);
  });

  try {
    await stickerPack.sendToWhatsApp();
  } on WhatsappStickersException catch (e) {
    print(e.cause);
  }
}
