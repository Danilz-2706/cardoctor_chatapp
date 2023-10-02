import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      style: GoogleFonts.inter(
        color: const Color(0xFF0A0B09),
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    );
  }
}
