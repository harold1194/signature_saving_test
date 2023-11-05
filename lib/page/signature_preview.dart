import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signature_saving_test/utils.dart';

class SignaturePreviewPage extends StatelessWidget {
  final Uint8List signature;
  const SignaturePreviewPage({super.key, required this.signature});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: CloseButton(),
          title: Text('Store Signature'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => storeSignature(context),
              icon: Icon(Icons.done),
            ),
          ],
        ),
        body: Center(
          child: Image.memory(signature),
        ),
      );

  Future storeSignature(BuildContext context) async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final time = DateTime.now().toIso8601String().replaceAll('.', ':');
    final name = 'signature_$time.png';

    final result = await ImageGallerySaver.saveImage(signature, name: name);
    final isSuccess = result['isSuccess'];

    if (isSuccess) {
      Navigator.pop(context);

      Utils.showSnackBar(
        context,
        text: 'Save to signature folder',
        color: Colors.green,
      );
    } else {
      Utils.showSnackBar(
        context,
        text: 'Failed to signature folder',
        color: Colors.red,
      );
    }
  }
}
