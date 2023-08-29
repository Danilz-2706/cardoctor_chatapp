import 'package:cardoctor_chatapp/src/page/contains.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/custom_theme.dart';

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget(
      {Key? key,
      required this.controller,
      this.textInputAction = TextInputAction.next,
      this.isEnable = true,
      this.autoFocus = false,
      this.onChanged,
      this.isPassword = false,
      this.icon,
      this.errorText,
      this.labelText,
      this.hintText,
      this.inputFormatters,
      this.maxLines,
      this.keyboardType = TextInputType.text,
      this.focusNode,
      this.readOnly = false,
      this.onTap,
      this.fillColor,
      this.onSubmitted,
      this.maxLength,
      this.isCounterText = false,
      this.fillBackground = false,
      this.suffixIcon,
      this.onPressDelete,
      this.titleText,
      this.style,
      this.require = false,
      this.onPressSuffix,
      this.isScroll,
      this.hintStyle})
      : super(key: key);

  final TextEditingController controller;
  final bool isEnable;
  final bool autoFocus;
  final bool require;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction textInputAction;
  final FormFieldSetter<String>? onChanged;
  final bool isPassword;
  final String? titleText;
  final String? errorText;
  final String? labelText;
  final String? hintText;
  final int? maxLines;
  final TextInputType keyboardType;
  final FocusNode? focusNode;
  final FormFieldSetter<String>? onSubmitted;
  final dynamic icon;
  final bool readOnly;
  final Function()? onTap;
  final Color? fillColor;
  final int? maxLength;
  final bool fillBackground;
  final bool? isCounterText;
  final String? suffixIcon;
  final VoidCallback? onPressDelete;
  final VoidCallback? onPressSuffix;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final EdgeInsets? isScroll;

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late bool _obscureText;
  bool _reachMaxLength = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.maxLength != null) {
      _reachMaxLength = widget.controller.text.length >= widget.maxLength!;
    }
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
            visible: widget.titleText != '',
            child: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: RichText(
                text: TextSpan(
                    text: widget.titleText ?? "",
                    style: widget.style ??
                        Theme.of(context).textTheme.body2Bold.copyWith(
                            color: widget.isEnable ? kColorDark1 : kColordark5),
                    children: widget.require
                        ? <TextSpan>[
                            TextSpan(
                              text: " ",
                              style: Theme.of(context)
                                  .textTheme
                                  .body2Bold
                                  .copyWith(color: kColordarkger1, height: 1),
                            ),
                          ]
                        : []),
              ),
            )),
        TextField(
          scrollPadding: widget.isScroll ?? EdgeInsets.zero,
          enabled: widget.isEnable,
          autofocus: widget.autoFocus,
          focusNode: _focusNode,
          controller: widget.controller,
          obscureText: _obscureText,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          decoration: InputDecoration(
              counterText: widget.isCounterText! ? null : '',
              // filled: widget.fillBackground,
              filled: true,
              fillColor: widget.fillColor ??
                  (widget.isEnable ? Colors.white : kColordark12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(width: 1, color: kColordark12),
              ),
              disabledBorder: widget.fillBackground
                  ? null
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 1, color: kColordark12),
                    ),
              enabledBorder: widget.fillBackground
                  ? null
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 1, color: kColordark12),
                    ),
              focusedBorder: widget.fillBackground
                  ? null
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 1, color: kColordark12),
                    ),
              errorBorder: widget.fillBackground
                  ? null
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 1, color: kColordark12),
                    ),
              focusedErrorBorder: widget.fillBackground
                  ? null
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 1, color: kColordark12),
                    ),
              contentPadding: EdgeInsets.only(
                  left: widget.fillBackground ? 0 : 16,
                  top: 14,
                  bottom: 14,
                  right: widget.isPassword ? 0 : 16),
              hintText: widget.hintText,
              errorText: widget.errorText,
              errorMaxLines: 1000,
              labelText: widget.labelText,
              prefixIcon: widget.icon == null
                  ? null
                  : (widget.icon is String
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(
                            widget.icon,
                            fit: BoxFit.fitHeight,
                            package: Consts.packageName,
                            height: 5,
                          ),
                        )
                      : Icon(
                          widget.icon,
                          size: 24,
                        )),
              suffixIcon: /*widget.readOnly == true
                  ? null
                  : */
                  (widget.isPassword || widget.suffixIcon != null
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              if (widget.onPressDelete != null) {
                                widget.controller.clear();
                                widget.onPressDelete?.call();
                                return;
                              }
                              widget.onPressSuffix?.call();
                              if (widget.isPassword) {
                                _obscureText = !_obscureText;
                                return;
                              }
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 12,
                                bottom: 12,
                                left: 10,
                                right: widget.fillBackground ? 0 : 16),
                            child: Image.asset(
                              'assets/imgs/ic_delete_field.png',
                              package: Consts.packageName,
                              height: 24,
                              width: 24,
                            ),
                          ),
                        )
                      : null),
              suffixIconConstraints: BoxConstraints(
                minHeight: 18.5,
                minWidth: 18.5,
              ),
              labelStyle: widget.style ??
                  Theme.of(context).textTheme.subTitle.copyWith(
                      color:
                          widget.isEnable ? kTextBlackColors : kTextGreyColors),
              hintStyle: widget.hintStyle ??
                  Theme.of(context).textTheme.subTitle.copyWith(
                        color: kColordark5,
                      ),
              helperStyle: Theme.of(context).textTheme.subTitleRegular.copyWith(
                    color: kColorlightestGray,
                  ),
              counterStyle: Theme.of(context)
                  .textTheme
                  .subTitleRegular
                  .copyWith(
                    color:
                        _reachMaxLength ? kColordarkger1 : kColorlightestGray,
                  ),
              errorStyle: Theme.of(context).textTheme.textRegular.copyWith(
                    color: kColordarkger1,
                  )),
          keyboardType: widget.keyboardType,
          onChanged: (value) {
            setState(() {
              if (widget.maxLength != null) {
                _reachMaxLength = value.length >= widget.maxLength!;
              }
              widget.onChanged?.call(value);
            });
          },
          onSubmitted: widget.onSubmitted,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          maxLength: widget.maxLength,
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          style: widget.fillBackground
              ? Theme.of(context).textTheme.subTitle.copyWith(
                    color: widget.isEnable ? kColorDark1 : kColordark5,
                  )
              : Theme.of(context).textTheme.subTitle.copyWith(
                    color: widget.isEnable ? kColorDark1 : kColordark5,
                  ),
        ),
      ],
    );
  }
}
