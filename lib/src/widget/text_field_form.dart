import 'package:cardoctor_chatapp/src/page/contains.dart';
import 'package:flutter/material.dart';

import '../model/form_text.dart';
import '../page/contains.dart';
import '../page/contains.dart';
import '../page/contains.dart';

class TextFieldForm extends StatelessWidget {
  const TextFieldForm({
    Key? key,
    required this.listForm,
  }) : super(key: key);

  final FormItem listForm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            spreadRadius: 0,
            blurRadius: 15,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Text(
        listForm.text ?? '',
        style: const TextStyle(
          fontSize: 11,
          color: Color.fromRGBO(49, 49, 49, 1),
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
