import 'package:collection/collection.dart';
import 'package:expensefrontend/data/api/auth.dart';
import 'package:expensefrontend/features/Expense/expense_page.dart';
import 'package:expensefrontend/features/Group/addMembersToGroup/add_members.dart';
import 'package:expensefrontend/features/Group/deleteMembersFromGroup/delete_members_page.dart';
import 'package:expensefrontend/features/settlement/settle_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/group_details_bloc.dart';


class GroupDetailsPage extends StatelessWidget {
  final int groupId;
  final String groupName;

  const GroupDetailsPage({
    Key? key,
    required this.groupId,
    required this.groupName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupDetailsBloc()..add(FetchGroupDetails(groupId)),
      child: Scaffold(
        appBar: AppBar(
            // title: Text(groupName),
            ),
        body: BlocConsumer<GroupDetailsBloc, GroupDetailsState>(
          listener: (context, state) {
            // TODO: implement listener
            if (state is GroupDetailsFailure) {
              // print(state.error);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is GroupDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GroupDetailsLoaded) {
              return Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    groupName,
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                ],
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: state.balances.isEmpty
                                ? const Text("All settled up")
                                : ListView.builder(
                                    shrinkWrap: true,
                                    // physics: NeverScrollableScrollPhysics(),
                                    itemCount: state.balances.length,
                                    itemBuilder: (context, index) {
                                      final balance = state.balances[index];
                                      return balance.balance > 0
                                          ? Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                        "${balance.name} owes you "),
                                                    Text(
                                                      "₹ ${balance.balance.abs()}",
                                                      style: const TextStyle(
                                                          color: Colors.green),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                              ],
                                            )
                                          : Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                        "You owe ${balance.name} "),
                                                    Text(
                                                      "₹ ${balance.balance.abs()}",
                                                      style: const TextStyle(
                                                          color: Colors.red),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                              ],
                                            );
                                    }),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SettleUpPage(
                                          groupId: groupId,
                                        ),
                                      ),
                                    );

                                    if (!context.mounted) return;

                                    if (result != null &&
                                        !(ListEquality()
                                            .equals(state.balances, result))) {
                                      debugPrint("check");
                                      context
                                          .read<GroupDetailsBloc>()
                                          .add(FetchGroupDetails(groupId));
                                    }
                                  },
                                  child: const Text('Settle Up'),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    foregroundColor: Colors.black54,
                                    backgroundColor: Colors.white,
                                    shadowColor: Colors.black,
                                    elevation: 2,
                                    side: BorderSide(
                                        width: 1, color: Colors.grey.shade600),
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    appRouter
                                        .push(AddMembers(groupId: groupId));
                                  },
                                  child: const Text('Add Members'),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    foregroundColor: Colors.black54,
                                    backgroundColor: Colors.white,
                                    shadowColor: Colors.black,
                                    elevation: 2,
                                    side: BorderSide(
                                        width: 1, color: Colors.grey.shade600),
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    appRouter.push(
                                        DeleteMembersPage(groupId: groupId));
                                  },
                                  child: const Text('Delete Members'),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    foregroundColor: Colors.black54,
                                    backgroundColor: Colors.white,
                                    shadowColor: Colors.black,
                                    elevation: 2,
                                    side: BorderSide(
                                        width: 1, color: Colors.grey.shade600),
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    final apiClient = ApiClient1();
                                    try {
                                      await apiClient.newDownload(groupId,groupName);
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("File downloaded")));
                                    }on Exception catch(e) {
                                      print(e.toString());
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                    }catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("File can not be downloaded.")));
                                    }
                                  },
                                  child: const Text('Report'),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    foregroundColor: Colors.black54,
                                    backgroundColor: Colors.white,
                                    shadowColor: Colors.black,
                                    elevation: 2,
                                    side: BorderSide(
                                        width: 1, color: Colors.grey.shade600),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                      child: Container(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: state.expenses.isEmpty
                            ? const Center(
                                child: Text("No expenses"),
                              )
                            : ListView.builder(
                                itemCount: state.expenses.length,
                                itemBuilder: (context, index) {
                                  final expense = state.expenses[index];
                                  String action = expense.userAmount < 0
                                      ? "you borrowed"
                                      : "you lent";
                                  String subtitle =
                                      "${expense.paidByName} paid ₹ ${expense.amount}";
                                  String userAmount =
                                      "₹${expense.userAmount.abs()}";
                                  Color amountColor = expense.userAmount < 0
                                      ? Colors.red
                                      : Colors.green;
                                  String date = expense.createdAt.split(" ")[0];
                                  String month =
                                      expense.createdAt.split(" ")[1];

                                  return Column(
                                    children: [
                                      _buildExpenseItem(
                                          expense.description,
                                          subtitle,
                                          action,
                                          userAmount,
                                          amountColor,
                                          date,
                                          month),
                                      Divider(thickness: 1, color: Colors.grey),
                                    ],
                                  );
                                }),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('Something went wrong!'));
            }
          },
        ),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton.extended(
            onPressed: () async {
              final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddExpensePage(groupId: groupId)));

              if (!context.mounted) return;

              if (result == true) {
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text('Expense added successfully.')),
                  );
                // BlocProvider.value(value: value)
                // BlocProvider.of(GroupDetailsBloc)(context)
                context
                    .read<GroupDetailsBloc>()
                    .add(FetchGroupDetails(groupId));
              } else if (result == false) {
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text('Expense addition failed')),
                  );
              }
            },
            icon: Icon(Icons.add),
            label: const Text("Add Expense"),
            backgroundColor: Colors.grey.shade300,
          );
        }),
      ),
    );
  }
}

Widget _buildExpenseItem(String title, String subtitle, String action,
    String amount, Color amountColor, String date, String month) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Container(
          height: 55,
          width: 55,
          color: Colors.grey.shade300,
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Text(
                  month,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ])),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              action,
              style: TextStyle(color: amountColor),
            ),
            Text(
              amount,
              style: TextStyle(
                color: amountColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
