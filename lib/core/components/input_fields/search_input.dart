import 'package:flutter/material.dart';
import 'package:lncmis_mobile_app/core/components/input_fields/text_input_field_container.dart';
import 'package:lncmis_mobile_app/models/input_field.dart';
import 'package:rxdart/rxdart.dart';

class SearchInput extends StatelessWidget {
  SearchInput({
    Key? key,
    this.onSearch,
  }) : super(key: key);

  final Function? onSearch;

  final PublishSubject<String> _searchedValued = PublishSubject<String>();
  final InputField inputField = InputField(
    id: 'search',
    name: '',
    valueType: 'TEXT',
  );

  onSearchInputValueChange(String value) {
    _searchedValued
        .debounce((_) => TimerStream(true, const Duration(milliseconds: 500)))
        .listen((searchedValue) async {
      onSearch!(searchedValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      height: 65.0,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(color: Color(0xFFFFFFFF)),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Colors.black12,
          ),
        ),
        child: TextInputFieldContainer(
          inputField: inputField,
          inputValue: '',
          showInputCheckedIcon: false,
          showInputSearchIcon: true,
          onInputValueChange: (dynamic value) {
            value = value.toLowerCase();
            _searchedValued.add(value);
            onSearchInputValueChange(value);
          },
        ),
      ),
    );
  }
}
