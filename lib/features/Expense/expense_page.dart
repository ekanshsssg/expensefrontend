import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/api/secure_storage.dart';
import '../../data/models/member.dart';
import 'core/add_expense_bloc.dart';

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
                Navigator.pop(context, true);
              } else if (state is AddExpenseFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to add an Expense.'),
                  ),
                );
                Navigator.pop(context, false);
              }
            },
            builder: (context, state) {
              if (state is AddExpenseLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is AddExpenseMembersLoaded) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // _buildMemberSelection(state.members),
                        _buildSelection(state.members),
                        _buildForm(state.members),
                        // Spacer(),
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

  Widget _buildSelection(List<Member> members) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            builder: (context) {
              return StatefulBuilder(
                  builder: (context, StateSetter setBottomSheetState) {
                return SizedBox(
                  height: members.length >2 ? 400 : 250,
                  child: ListView.builder(
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      final member = members[index];
                      final isDefaultMember = member.memberId == _userId;

                      return CheckboxListTile(
                        title: Text(member.name),
                        subtitle: Text(member.emailId),
                        value: _selectedMembers.contains(member.memberId),
                        onChanged: isDefaultMember ? null :  (bool? selected) {
                          setBottomSheetState(() {
                            if (selected!) {
                              _selectedMembers.add(member.memberId);
                            } else {
                              _selectedMembers.remove(member.memberId);
                              debugPrint(_selectedMembers.toString());
                            }
                          });

                          setState((){
                            _selectedMembers = _selectedMembers;
                          });
                        },
                      );
                    },
                  ),
                  // child: Expanded(
                  //   child: ListView.builder(
                  //     itemCount: members.length,
                  //     itemBuilder: (context, index) {
                  //       final member = members[index];
                  //       return CheckboxListTile(
                  //         title: Text(member.name),
                  //         subtitle: Text(member.emailId),
                  //         value: _selectedMembers.contains(member.memberId),
                  //         onChanged: (bool? selected) {
                  //           setState(() {
                  //             if (selected!) {
                  //               _selectedMembers.add(member.memberId);
                  //             } else {
                  //               _selectedMembers.remove(member.memberId);
                  //             }
                  //           });
                  //         },
                  //       );
                  //     },
                  //   ),
                  // ),
                );
              });
            });
// showBottomSheet(context: context, builder: builder)
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(_selectedMembers.isNotEmpty
              ? '${_selectedMembers.length} selected'
              : 'Select Members'),
          const Icon(
            Icons.group,
            color: Colors.black,
          )
        ]),
      ),
    );
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
