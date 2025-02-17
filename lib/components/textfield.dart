import 'package:scarlet_erm/components/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MyTextForm extends StatelessWidget {
  final text;
  final containerWidth;
  final hintText;
  final maxLines;
  final controller;
  final validator;
  final onchange;
  final enable;
  final textKeyboardType;
  final prefixIcon;
  final sufixIcon;
  final bool obscurText;
  final String? dateMask;
  const MyTextForm({
    Key? key,
    this.text,
    @required this.containerWidth,
    @required this.hintText,
    this.textKeyboardType,
    this.onchange,
    this.maxLines,
    this.enable,
    this.prefixIcon,
    this.sufixIcon,
    this.obscurText = false,
    @required this.controller,
    this.validator,
    this.dateMask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final dateMaskFormatter = MaskTextInputFormatter(mask: dateMask);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTextWidget(
          text: text,
          // color: Colors.white,
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 5),
        SizedBox(
          width: containerWidth,
          child: TextFormField(
            cursorColor: Colors.white,
            onChanged: onchange,
            enabled: enable,
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            keyboardType: textKeyboardType,
            controller: controller,
            obscureText: obscurText,
            textInputAction: TextInputAction.done,
            inputFormatters: [
              MaskTextInputFormatter(
                  mask: dateMask,
                  filter: {"#": RegExp(r'[0-9]'), "?": RegExp(r'[a-zA-Z]')})
            ],
            // maxLines: maxLines == null ? null : maxLines,
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              suffixIcon: sufixIcon,
              isDense: true,
              errorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.error),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.error),
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary, width: 1.3),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              hintText: hintText,
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            style: TextStyle(color: Colors.black,
              fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
