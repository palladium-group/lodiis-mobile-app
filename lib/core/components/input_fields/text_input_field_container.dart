import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lncmis_mobile_app/core/components/input_fields/input_checked_icon.dart';
import 'package:lncmis_mobile_app/core/components/input_fields/input_search_clear_icon.dart';
import 'package:lncmis_mobile_app/core/components/input_fields/input_search_icon.dart';
import 'package:lncmis_mobile_app/models/input_field.dart';

class TextInputFieldContainer extends StatefulWidget {
  const TextInputFieldContainer({
    Key? key,
    required this.inputField,
    this.lastUpdatedId,
    this.onInputValueChange,
    this.inputValue,
    this.showInputCheckedIcon = true,
    this.showInputSearchIcon = false,
  }) : super(key: key);

  final InputField inputField;
  final String? lastUpdatedId;
  final Function? onInputValueChange;
  final String? inputValue;
  final bool showInputCheckedIcon;
  final bool showInputSearchIcon;

  @override
  State<TextInputFieldContainer> createState() =>
      _TextInputFieldContainerState();
}

class _TextInputFieldContainerState extends State<TextInputFieldContainer> {
  TextEditingController? textController;
  String? _value;
  String? _lastInputValue = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      _value = widget.inputValue;
    });
    updateTextValue(value: widget.inputValue);
  }

  updateTextValue({String? value = ''}) {
    _value = value;
    setState(() {});
    textController = TextEditingController(text: value);
  }

  onValueChange(String value) {
    if (_lastInputValue != value) {
      _value = value;
      _lastInputValue = _value;
      setState(() {});
      widget.onInputValueChange!(value.trim());
    }
  }

  clearSearchValue() {
    updateTextValue();
    widget.onInputValueChange!(_value);
  }

  @override
  void didUpdateWidget(covariant TextInputFieldContainer oldWidget) {
    super.didUpdateWidget(widget);
    if (oldWidget.inputValue != widget.inputValue) {
      if (widget.inputField.isReadOnly! ||
          (widget.lastUpdatedId!.isNotEmpty &&
              widget.lastUpdatedId != widget.inputField.id)) {
        updateTextValue(value: widget.inputValue);
      }
      if (widget.inputValue == null || widget.inputValue == '') {
        updateTextValue();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            readOnly: widget.inputField.isReadOnly!,
            controller: widget.inputField.isReadOnly!
                ? TextEditingController(
                    text: widget.inputValue,
                  )
                : textController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  widget.inputField.regExpValidation as Pattern),
            ],
            onChanged: onValueChange,
            maxLines: widget.inputField.valueType == 'LONG_TEXT' ? null : 1,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
            style: const TextStyle().copyWith(
              color: widget.inputField.inputColor,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              errorText: null,
            ),
          ),
        ),
        Visibility(
          visible: widget.inputField.suffixLabel != '' &&
              _value != null &&
              '$_value'.trim() != '',
          child: Text(widget.inputField.suffixLabel ?? '',
              style: const TextStyle().copyWith(
                color: widget.inputField.inputColor,
              )),
        ),
        InputCheckedIcon(
          showTickedIcon: widget.showInputCheckedIcon &&
              _value != null &&
              '$_value'.trim() != '',
          color: widget.inputField.inputColor,
        ),
        Visibility(
          visible: widget.showInputSearchIcon && _value == '',
          child: const InputSearchIcon(),
        ),
        Visibility(
          visible: widget.showInputSearchIcon && _value != '',
          child: GestureDetector(
            child: const InputSearchClearIcon(),
            onTap: () => clearSearchValue(),
          ),
        )
      ],
    );
  }
}
