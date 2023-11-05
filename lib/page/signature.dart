import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:signature_saving_test/page/signature_preview.dart';

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({super.key});

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  late SignatureController controller;

  @override
  void initState() {
    super.initState();
    controller = SignatureController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Signature(
                controller: controller,
                height: 200,
                width: 200,
              ),
              buildButtons(context),
            ],
          ),
        ),
      );

  Widget buildButtons(BuildContext context) => Container(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildCheck(context),
            buildClear(),
          ],
        ),
      );

  Widget buildCheck(BuildContext context) => IconButton(
        onPressed: () async {
          if (controller.isNotEmpty) {
            final signature = await exportSignature();

            if (!mounted) return;
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    SignaturePreviewPage(signature: signature!)));
          }
        },
        icon: Icon(
          Icons.check,
          color: Colors.green,
        ),
      );
  Widget buildClear() => IconButton(
        onPressed: () => controller.clear(),
        icon: Icon(
          Icons.clear,
          color: Colors.red,
        ),
      );

  Future<Uint8List?> exportSignature() async {
    final exportController = SignatureController(
        penColor: Colors.black,
        exportBackgroundColor: Colors.white,
        points: controller.points);

    final signature = await exportController.toPngBytes();
    exportController.dispose();

    return signature;
  }
}
