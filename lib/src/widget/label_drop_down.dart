import 'package:flutter/material.dart';

import '../model/form_text.dart';

class LabelDropDownForm extends StatelessWidget {
  const LabelDropDownForm({
    Key? key,
    required this.listForm,
  }) : super(key: key);

  final FormItem listForm;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            text: listForm.label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(10, 11, 9, 1),
            ),
            children: [
              const TextSpan(
                  text: " *",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(10, 11, 9, 1),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Row(
            children: [
              Text(
                listForm.hintText ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromRGBO(107, 109, 108, 1),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
