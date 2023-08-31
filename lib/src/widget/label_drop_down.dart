import 'package:flutter/material.dart';

import '../model/form_text.dart';
import '../page/contains.dart';

class LabelDropDownForm extends StatelessWidget {
  const LabelDropDownForm({
    Key? key,
    required this.listForm,
  }) : super(key: key);

  final FormItem listForm;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            text: listForm.label,
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromRGBO(10, 11, 9, 1),
            ),
            children: [
              const TextSpan(
                  text: " *",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(10, 11, 9, 1),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
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
          child: Row(
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  listForm.hintText ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(107, 109, 108, 1),
                  ),
                ),
              ),
              if (listForm.drop != 'empty') const Expanded(child: SizedBox()),
              if (listForm.drop != 'empty')
                Text(
                  listForm.value2 ?? '',
                  style: const TextStyle(
                    color: Color.fromRGBO(255, 141, 78, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (listForm.drop != 'empty')
                Image.asset(
                  listForm.drop == 'drop'
                      ? 'assets/imgs/arrow-down.png'
                      : 'assets/imgs/edit.png',
                  height: 20,
                  width: 20,
                  package: Consts.packageName,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
