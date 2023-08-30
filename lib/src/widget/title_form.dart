import 'package:flutter/material.dart';

import '../model/form_text.dart';

class TitleForm extends StatelessWidget {
  const TitleForm({
    Key? key,
    required this.listForm,
  }) : super(key: key);

  final FormItem listForm;

  @override
  Widget build(BuildContext context) {
    return Text(
      listForm.text ?? '',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(10, 11, 9, 1),
      ),
    );
  }
}
