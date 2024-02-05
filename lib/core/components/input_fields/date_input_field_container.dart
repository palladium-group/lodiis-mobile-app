import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/components/input_fields/input_checked_icon.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/input_field.dart';

class DateInputFieldContainer extends StatefulWidget {
  const DateInputFieldContainer({
    Key? key,
    required this.inputField,
    this.lastUpdatedId,
    required this.onInputValueChange,
    required this.currentLanguage,
    this.inputValue,
  }) : super(key: key);

  final InputField inputField;
  final String? lastUpdatedId;
  final Function onInputValueChange;
  final String? currentLanguage;
  final String? inputValue;

  @override
  State<DateInputFieldContainer> createState() =>
      _DateInputFieldContainerState();
}

class _DateInputFieldContainerState extends State<DateInputFieldContainer> {
  TextEditingController? dateController;

  String? _date;

  @override
  void initState() {
    super.initState();
    setState(() {
      _date = widget.inputValue == '' ? null : widget.inputValue;
      dateController = TextEditingController(text: _date);
    });
  }

  updateDateValue({String? value = ''}) {
    _date = value;
    setState(() {});
    dateController = TextEditingController(text: value);
  }

  @override
  void didUpdateWidget(covariant DateInputFieldContainer oldWidget) {
    super.didUpdateWidget(widget);
    if (oldWidget.inputValue != widget.inputValue) {
      if (widget.inputField.isReadOnly! ||
          (widget.lastUpdatedId!.isNotEmpty &&
              widget.lastUpdatedId != widget.inputField.id)) {
        updateDateValue(value: widget.inputValue);
      }
      if (widget.inputValue == null || widget.inputValue == '') {
        resetDate();
      }
    }
  }

  resetDate() {
    setState(() {
      _date = null;
      dateController = TextEditingController(text: _date);
    });
  }

  DateTime getDateFromGivenYear(
    int year, {
    int numberOfMonth = 0,
    int numberOfDays = 0,
    required DateTime currentDate,
  }) {
    return DateTime(
      currentDate.year - year,
      currentDate.month - numberOfMonth,
      currentDate.day + numberOfDays,
    );
  }

  void onOpenDateSelection(BuildContext context) async {
    int limit = 200;
    int minAgeInYear = widget.inputField.minAgeInYear ?? limit;
    int maxAgeInYear = widget.inputField.maxAgeInYear ?? -limit;
    DateTime lastDate = widget.inputField.lastDate!.isNotEmpty
        ? AppUtil.getDateIntoDateTimeFormat(widget.inputField.lastDate!)
        : getDateFromGivenYear(
            widget.inputField.minAgeInYear != null ? minAgeInYear : -limit,
            currentDate: DateTime.now(),
          );
    DateTime firstDate = widget.inputField.firstDate!.isNotEmpty
        ? AppUtil.getDateIntoDateTimeFormat(widget.inputField.firstDate!)
        : getDateFromGivenYear(
            widget.inputField.maxAgeInYear != null ? maxAgeInYear : limit,
            numberOfMonth: widget.inputField.numberOfMonth != null
                ? widget.inputField.numberOfMonth! + 1
                : 0,
            numberOfDays: 1,
            currentDate: widget.inputField.lastDate!.isNotEmpty
                ? lastDate
                : DateTime.now(),
          );
    DateTime currentDate =
        widget.inputField.lastDate!.isNotEmpty ? lastDate : DateTime.now();
    int numberOfYearBetweenCurrentAndMaxDate = currentDate.year - lastDate.year;
    _date = _date ??
        AppUtil.formattedDateTimeIntoString(
          numberOfYearBetweenCurrentAndMaxDate >= 0 ? lastDate : currentDate,
        );
    DateTime? date = await showDatePicker(
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light().copyWith(
              primary: widget.inputField.inputColor,
            ),
          ),
          child: child!,
        );
      },
      context: context,
      fieldLabelText: widget.currentLanguage == 'lesotho'
          ? '${widget.inputField.translatedName}'
          : widget.inputField.name,
      initialDate: AppUtil.getDateIntoDateTimeFormat(_date!),
      firstDate:
          widget.inputField.disablePastPeriod! ? DateTime.now() : firstDate,
      confirmText: widget.currentLanguage == 'lesotho' ? 'Ok' : 'Ok',
      cancelText: widget.currentLanguage == 'lesotho' ? 'Cancel' : 'Cancel',
      lastDate: widget.inputField.allowFuturePeriod! ||
              numberOfYearBetweenCurrentAndMaxDate >= 0
          ? lastDate
          : DateTime.now(),
      helpText: widget.inputField.hint != null
          ? widget.currentLanguage == 'lesotho' &&
                  widget.inputField.translatedHint != null
              ? widget.inputField.translatedHint
              : widget.inputField.hint
          : widget.currentLanguage == 'lesotho' &&
                  widget.inputField.translatedName != null
              ? '${widget.inputField.translatedName}'
              : widget.inputField.name,
      errorFormatText: 'Enter valid ${widget.inputField.name}',
      errorInvalidText: 'Enter ${widget.inputField.name} in valid range',
    );

    if (date != null) {
      updateDateValue(value: AppUtil.formattedDateTimeIntoString(date));
      widget.onInputValueChange(_date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: dateController,
            style: const TextStyle().copyWith(
              color: widget.inputField.inputColor,
            ),
            onTap: () => widget.inputField.isReadOnly!
                ? null
                : onOpenDateSelection(context),
            readOnly: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              border: InputBorder.none,
              errorText: null,
            ),
          ),
        ),
        InputCheckedIcon(
          showTickedIcon: _date != null && _date != '',
          color: widget.inputField.inputColor,
        )
      ],
    );
  }
}
