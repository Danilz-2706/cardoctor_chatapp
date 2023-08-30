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
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            spreadRadius: 0,
            blurRadius: 15,
            offset: Offset(0, 0),
          ),
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(
            16,
          ),
        ),
        border: Border.all(
          width: 1,
          color: const Color.fromRGBO(230, 230, 227, 1),
        ),
      ),
      child: Text(
        listForm.text ?? '',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(10, 11, 9, 1),
        ),
      ),
    );
  }
}
