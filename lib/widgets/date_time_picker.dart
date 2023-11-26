import 'package:flutter/material.dart';

class DateTimeRow extends StatefulWidget {
  final DateTime value;
  final ValueChanged<DateTime> onChanged;

  const DateTimeRow({Key? key, 
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _DateTimeRowState createState() => _DateTimeRowState();
}

class _DateTimeRowState extends State<DateTimeRow> {
 late  int _gun ;
 late int _ay ;
 late  int _yil;
  @override
  void initState() {
    
       _gun = widget.value.day;
   _ay = widget.value.month;
   _yil = widget.value.year;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownButton<int>(
          value: _gun,
          icon: const Icon(Icons.arrow_downward),
          items: List.generate(31, (index) => index + 1).map((day) {
            return DropdownMenuItem<int>(
              value: day,
              child: Text(day.toString()),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _gun = value??1;
            });
            widget.onChanged(DateTime(_yil, _ay, _gun));
          },
        ),
        DropdownButton<int>(
          value: _ay,
          icon: const Icon(Icons.arrow_downward),
          items: List.generate(12, (index) => index + 1).map((month) {
            return DropdownMenuItem<int>(
              value: month,
              child: Text(month.toString()),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _ay = value??1;
            });
            widget.onChanged(DateTime(_yil, _ay, _gun));
          },
        ),
        DropdownButton<int>(
          value: _yil,
          icon: const Icon(Icons.arrow_downward),
          items: List.generate(100, (index) => index + 2023).map((year) {
            return DropdownMenuItem<int>(
              value: year,
              child: Text(year.toString()),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _yil = value??2023;
            });
            widget.onChanged(DateTime(_yil, _ay, _gun));
          },
        ),
      ],
    );
  }
}