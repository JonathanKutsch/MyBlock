import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:my_block/model/database.dart';
import 'package:my_block/model/todo.dart';
import 'package:my_block/widgets/custom_date_time_picker.dart';
import 'package:my_block/widgets/custom_modal_action_button.dart';
import 'package:my_block/widgets/custom_textfield.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime _selectedDate = DateTime.now();
  final _textTaskController = TextEditingController();

  Future _pickDate() async {
    DateTime datepick = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime.now().add(Duration(days: -365)),
      lastDate: new DateTime.now().add(Duration(days: 365)));
    if (datepick != null)
    setState((){
      _selectedDate = datepick;
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Database>(context);

    _textTaskController.clear();
    return Padding(
      padding: const EdgeInsets.all(26.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: Text("Add new task",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            )),
            SizedBox(
              height: 24,
            ),
            CustomTextField(labelText: 'Enter task name', controller: _textTaskController),
            SizedBox(height: 12),
            CustomDateTimePicker(
              icon: Icons.date_range,
              onPressed: _pickDate,
              value: new DateFormat("dd-MM-yyyy").format(_selectedDate),
            ),
            SizedBox(
              height: 24,
            ),
            CustomModalActionButton(
              onClose: () {
                Navigator.of(context).pop();
              },
              onSave: () {
                if (_textTaskController.text == "") {
                  print("data not found");
                } else {
                  provider
                    .insertTodoEntries(new TodoData(
                      date: _selectedDate,
                      time: DateTime.now(),
                      isFinish: false,
                      task: _textTaskController.text,
                      description: "",
                      todoType: TodoType.TYPE_TASK.index,
                      id: null))
                    .whenComplete(() => Navigator.of(context).pop());
                }
              },
            )
          ],
      ),
    );
  }
}