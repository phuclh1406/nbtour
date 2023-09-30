import 'package:flutter/material.dart';
import 'package:nbtour/constant/colors.dart';
import 'package:nbtour/constant/dimension.dart';
import 'package:nbtour/constant/text_style.dart';
import 'package:nbtour/models/month_model.dart';
import 'package:nbtour/widgets/filter_item_widget.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

final monthList = [
  const Month(
    id: 1,
    monthTitle: 'Jan',
  ),
  const Month(
    id: 2,
    monthTitle: 'Feb',
  ),
  const Month(
    id: 3,
    monthTitle: 'Mar',
  ),
  const Month(
    id: 4,
    monthTitle: 'Apr',
  ),
  const Month(
    id: 5,
    monthTitle: 'May',
  ),
  const Month(
    id: 6,
    monthTitle: 'Jun',
  ),
  const Month(
    id: 7,
    monthTitle: 'Jul',
  ),
  const Month(
    id: 8,
    monthTitle: 'Aug',
  ),
  const Month(
    id: 9,
    monthTitle: 'Sep',
  ),
  const Month(
    id: 10,
    monthTitle: 'Oct',
  ),
  const Month(
    id: 11,
    monthTitle: 'Nov',
  ),
  const Month(
    id: 12,
    monthTitle: 'Dec',
  ),
];

class _FilterScreenState extends State<FilterScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final lastDate = DateTime(now.year + 1, now.month, now.day);
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate);

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInValid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInValid ||
        _selectedDate == null) {
      //show error msg
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'))
          ],
        ),
      );
      return;
    }

    // widget.onAddExpense(Expense(
    //     title: _titleController.text,
    //     amount: enteredAmount,
    //     date: _selectedDate!,
    //     category: _selectedCategory));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  List<bool> isSelectedList = List.generate(monthList.length, (index) => false);
  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      color: Colors.white,
      child: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 48, 0, keyboardSpace + 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: kMediumPadding),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: kMediumPadding / 2),
                  child: Text('Filter', style: TextStyles.regularStyle),
                ),
                const SizedBox(height: kMediumPadding),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: kMediumPadding / 2),
                  child: Text('By Month', style: TextStyles.regularStyle),
                ),
                const SizedBox(height: kMediumPadding / 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < 4; i++)
                      FilterItem(
                        borderColor: isSelectedList[i]
                            ? ColorPalette.primaryColor
                            : ColorPalette.subTitleColor,
                        title: monthList[i].monthTitle,
                        backgroundColor: isSelectedList[i]
                            ? ColorPalette.primaryColor
                            : Colors.white,
                        onTap: () {
                          setState(() {
                            isSelectedList[i] = !isSelectedList[i];
                          });
                        },
                        titleColor: isSelectedList[i]
                            ? Colors.white
                            : ColorPalette.subTitleColor,
                      ),
                  ],
                ),
                const SizedBox(height: kMediumPadding / 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 4; i < 8; i++)
                      FilterItem(
                        borderColor: isSelectedList[i]
                            ? ColorPalette.primaryColor
                            : ColorPalette.subTitleColor,
                        title: monthList[i].monthTitle,
                        backgroundColor: isSelectedList[i]
                            ? ColorPalette.primaryColor
                            : Colors.white,
                        onTap: () {
                          setState(() {
                            isSelectedList[i] = !isSelectedList[i];
                          });
                        },
                        titleColor: isSelectedList[i]
                            ? Colors.white
                            : ColorPalette.subTitleColor,
                      ),
                  ],
                ),
                const SizedBox(height: kMediumPadding / 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 8; i < monthList.length; i++)
                      FilterItem(
                        borderColor: isSelectedList[i]
                            ? ColorPalette.primaryColor
                            : ColorPalette.subTitleColor,
                        title: monthList[i].monthTitle,
                        backgroundColor: isSelectedList[i]
                            ? ColorPalette.primaryColor
                            : Colors.white,
                        onTap: () {
                          setState(() {
                            isSelectedList[i] = !isSelectedList[i];
                          });
                        },
                        titleColor: isSelectedList[i]
                            ? Colors.white
                            : ColorPalette.subTitleColor,
                      ),
                  ],
                ),
                const SizedBox(height: kMediumPadding / 2),
                Row(
                  children: [
                    const SizedBox(width: kMediumPadding / 2),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(Icons.calendar_month),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kMediumPadding / 2),
                      child: Text(_selectedDate == null
                          ? 'No date selected'
                          : _selectedDate!.toString().substring(0, 10)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel',
                          style: TextStyle(color: ColorPalette.primaryColor)),
                    ),
                    ElevatedButton(
                      onPressed: _submitExpenseData,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalette.primaryColor),
                      child: const Text('Save Expense',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(
                      width: kMediumPadding,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
