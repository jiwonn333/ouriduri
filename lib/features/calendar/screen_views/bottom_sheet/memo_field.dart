import 'package:flutter/cupertino.dart';

class MemoField extends StatelessWidget {
  const MemoField({super.key, required this.controller});
  final TextEditingController controller;
  @override
  Widget build(BuildContext ctx) => CupertinoTextField(
    controller: controller,
    placeholder: '메모를 입력하세요',
    padding: const EdgeInsets.all(12),
    minLines: 1,
    maxLines: 4,
  );
}