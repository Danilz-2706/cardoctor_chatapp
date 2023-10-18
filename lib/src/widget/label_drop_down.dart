import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/form_text.dart';
import '../page/contains.dart';

class LabelDropDownForm extends StatelessWidget {
  const LabelDropDownForm({
    Key? key,
    required this.listForm,
    required this.color,
  }) : super(key: key);

  final FormItem listForm;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
        const SizedBox(height: 8),
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
          child: Row(
            children: [
              Expanded(
                child: Text(
                  listForm.hintText ?? '',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF282828),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),
              if (listForm.drop != 'empty')
                Text(
                  listForm.value2 ?? '',
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (listForm.drop != 'empty') const SizedBox(width: 8),
              if (listForm.drop != 'empty')
                Image.asset(
                  listForm.drop == 'drop'
                      ? 'assets/imgs/arrow-down.png'
                      : listForm.drop == 'km'
                          ? 'assets/imgs/Km.png'
                          : 'assets/imgs/edit.png',
                  height: 20,
                  width: 20,
                  color: listForm.drop != 'drop' && listForm.drop != 'km'
                      ? color
                      : null,
                  package: Consts.packageName,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
