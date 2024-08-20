import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/api/secure_storage.dart';
import '../../data/models/member.dart';
import 'core/add_expense_bloc.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AddExpensePage extends StatefulWidget {
  final int groupId;

  const AddExpensePage({Key? key, required this.groupId}) : super(key: key);

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _secureStorage = SecureStorage();
  late int _userId;

  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late int paidBy;
  List<int> _selectedMembers = [];

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  Future<void> _getUserId() async {
    _userId = int.parse(await _secureStorage.readSecureData('userId'));
    setState(() {
      paidBy = _userId;
      _selectedMembers.add(_userId);
    });
    print(_userId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AddExpenseBloc()..add(FetchGroupMembers(widget.groupId)),
      child: Scaffold(
          appBar: AppBar(title: Text('Add Expense')),
          body: BlocConsumer<AddExpenseBloc, AddExpenseState>(
            listener: (context, state) {
              if (state is AddExpenseSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Expense added successfully.'),
                  ),
                );
                Navigator.pop(context,true);
              } else if (state is AddExpenseFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to add an Expense.'),
                  ),
                );
                Navigator.pop(context,false);
              }
            },
            builder: (context, state) {
              if (state is AddExpenseLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is AddExpenseMembersLoaded) {
                print("qw");
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildMemberSelection(state.members),
                        _buildForm(state.members),
                        _buildSubmitButton(context),
                      ],
                    ),
                  ),
                );
              }
              return Container();
            },
          )),
    );
  }

  Widget _buildMemberSelection(List<Member> members) {
    return MultiSelectDialogField(
      title: const Text('Add members'),
      items: members
          .map((member) => member.memberId != _userId
              ? MultiSelectItem<int>(member.memberId, member.name)
              : MultiSelectItem<int>(member.memberId, "You"))
          .toList(),
      listType: MultiSelectListType.CHIP,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: Colors.grey),
      ),
      buttonIcon: Icon(
        Icons.group,
        color: Colors.black,
      ),
      buttonText: Text(
        "Select Members",
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      initialValue: _selectedMembers,
      onSelectionChanged: (values) {
        if (!values.contains(_userId)) {
          values.add(_userId);
        }
        // _selectedMembers = values;
      },
      onConfirm: (values) {
        setState(() {
          _selectedMembers = values;
        });
      },
    );

    // return [
    //   Text('Select Members'),
    //   Wrap(
    //     children: members.map((member) {
    //       return ChoiceChip(
    //         label: Text(member.name),
    //         selected: _selectedMembers.contains(member.memberId),
    //         onSelected: (selected) {
    //           setState(() {
    //             if (selected) {
    //               _selectedMembers.add(member.memberId);
    //             } else {
    //               _selectedMembers.remove(member.memberId);
    //             }
    //           });
    //         },
    //       );
    //     }).toList(),
    //   ),
    // ];
  }

  Widget _buildForm(List<Member> members) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _categoryController,
            decoration: InputDecoration(labelText: 'Category'),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _amountController,
            decoration: InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          SizedBox(height: 16),
          // DropdownButton<int>(
          //   hint: Text('Paid By'),
          //   value: paidBy,
          //   items: _selectedMembers.map((memberId) {
          //     return DropdownMenuItem<int>(
          //       value: memberId,
          //       child: Text('Member $memberId'),
          //     );
          //   }).toList(),
          //   onChanged: (value) {
          //     setState(() {
          //       paidBy = value;
          //     });
          //   },
          // ),
          Row(
            children: [
              Text(
                'Paid By:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<int>(
                  hint: Text(
                    'Select Member',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  value: paidBy,
                  items: _selectedMembers.map((memberId) {
                    final member = members
                        .firstWhere((member) => member.memberId == memberId);
                    return DropdownMenuItem<int>(
                      value: memberId,
                      child: Text(
                        memberId != _userId ? member.name : "You",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      paidBy = value ?? paidBy;
                    });
                  },
                  dropdownColor: Colors.white,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  // isExpanded: true,
                  // isDense: true,

                ),
                // child: DropdownButton<int>(
                //   hint: Text(
                //     'Select Member',
                //     style: TextStyle(
                //       color: Colors.grey,
                //       fontSize: 16,
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                //   value: paidBy,
                //   items: _selectedMembers.map((memberId) {
                //     final member = members
                //         .firstWhere((member) => member.memberId == memberId);
                //     return DropdownMenuItem<int>(
                //       value: memberId,
                //       child: Text(
                //         memberId != _userId ? member.name : "You",
                //         style: TextStyle(
                //           color: Colors.black,
                //           fontSize: 16,
                //           fontWeight: FontWeight.w400,
                //         ),
                //       ),
                //     );
                //   }).toList(),
                //   onChanged: (value) {
                //     setState(() {
                //       paidBy = value ?? paidBy;
                //     });
                //   },
                //   dropdownColor: Colors.white,
                //   icon: Icon(
                //     Icons.arrow_drop_down,
                //     color: Colors.black,
                //   ),
                //   underline: Container(
                //     height: 2,
                //     color: Colors.deepPurple.shade300,
                //   ),
                //   style: TextStyle(
                //     color: Colors.black,
                //     fontSize: 16,
                //     fontWeight: FontWeight.w400,
                //   ),
                // ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Text(
                'Split : ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 32,
              ),
              // TextButton(onPressed: (){}, child: Text('Equally')),
              OutlinedButton(onPressed: () {}, child: Text('Equally'))
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final category = _categoryController.text;
        final amount = double.tryParse(_amountController.text);
        final description = _descriptionController.text;

        if (category.isEmpty ||
            amount == null ||
            description.isEmpty ||
            // paidBy == null ||
            _selectedMembers.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Please fill all fields and select members')));
          return;
        }



        context.read<AddExpenseBloc>().add(AddExpense(
              groupId: widget.groupId,
              category: category,
              amount: amount,
              description: description,
              paidBy: paidBy,
              members: _selectedMembers,
            ));
      },
      child: const Text('Add Expense'),
    );
  }
}
