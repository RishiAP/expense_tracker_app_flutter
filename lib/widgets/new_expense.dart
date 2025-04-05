import 'package:expense_tracker_app/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key,required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;
  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate=DateTime.now();
  Category _selectedCategory=Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
      if(pickedDate==null){
        return;
      }
    setState(() {
      _selectedDate = pickedDate;
    });
  }


  void _submitExpenseData(){
    final amount=double.tryParse(_amountController.text);
    final title=_titleController.text.trim();
    final amountIsInvalid=amount==null || amount<=0;
    if(title.isEmpty || amountIsInvalid){
      showDialog(context: context, builder: (ctx)=>AlertDialog(
        title: const Text("Invalid Input"),
        content: const Text("Please make sure a valid title amount or date was entered!"),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(ctx);
          }, child: const Text("Close"))
        ],
      ));
      return;
    }
    widget.onAddExpense(Expense(title:title,amount: amount,category: _selectedCategory,date: _selectedDate));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16,48,16,16),
      child: Column(
        children: [
          TextField(
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text("Enter title"),
            ),
            controller: _titleController,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: '\u20B9 ',
                    label: Text("Enter amount"),
                  ),
                  controller: _amountController,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(formatter.format(_selectedDate)),
                  IconButton(
                    onPressed: _presentDatePicker,
                    icon: const Icon(Icons.calendar_month),
                  )
                ],
              ))
            ],
          ),
          const SizedBox(height: 16,),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.name.toUpperCase()),
                        ))
                    .toList(),
                onChanged: (value) {
                    if(value==null){
                      return;
                    }
                  setState(() {
                    _selectedCategory=value;
                  });
                },
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                  onPressed: _submitExpenseData,
                  child: const Text('Save Expense'))
            ],
          )
        ],
      ),
    );
  }
}
