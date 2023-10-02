import 'package:cardoctor_chatapp/src/page/contains.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Column(
      children: [
        if (listForm.label != null)
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              text: listForm.label,
              style: GoogleFonts.inter(
                color: const Color(0xFF0A0B09),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              children: listForm.required != null && listForm.required == true
                  ? [
                      TextSpan(
                        text: " *",
                        style: GoogleFonts.inter(
                          color: const Color(0xFF0A0B09),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ]
                  : [],
            ),
          ),
        if (listForm.label != null) const SizedBox(height: 8),
        Container(
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
            style: GoogleFonts.inter(
              color: const Color(0xFF282828),
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
