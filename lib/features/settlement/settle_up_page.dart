import 'package:expensefrontend/features/settlement/core/settle_up_bloc.dart';
import 'package:expensefrontend/features/settlement/widget/core/settle_up_dialog_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/balance.dart';

class SettleUpPage extends StatelessWidget {
  final int groupId;

  const SettleUpPage({Key? key, required this.groupId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettleUpBloc()..add(FetchBalances(groupId)),

      child: Scaffold(
        appBar: AppBar(
          title: Text("Select a balance to settle"),
        ),
        body: BlocConsumer<SettleUpBloc, SettleUpState>(
            listener: (context, state) {
              if (state is SettleUpFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                  ),
                );
              }
            }, builder: (context, state) {
          if (state is SettleUpLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SettleUpLoaded) {
            return PopScope(
              canPop: false,
              onPopInvoked: (didPop) {
                if(didPop) return ;
                print("h3");
                // final state = BlocProvider.of<SettleUpBloc>(context).state;
                print(state);
                print("h4");
                // if(state is SettleUpLoaded){
                //   print(state.balances);

                  Navigator.of(context).pop(state.balances);
                // }else{
                //   Navigator.of(context).pop();
                // }
              },
child: Padding(
  padding: EdgeInsets.all(16),
  child: state.balances.isEmpty
      ? const Center(
    child: Text("All settled up"),
  )
      : ListView.builder(
      itemCount: state.balances.length,
      itemBuilder: (context, index) {
        final balance = state.balances[index];
        return Card(
          elevation: 4.0,
          margin: EdgeInsets.symmetric(
              horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 10.0),
              title: Text(balance.name),
              trailing: balance.balance > 0
                  ? Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                crossAxisAlignment:
                CrossAxisAlignment.end,
                children: [
                  Text(
                    "you are owed",
                    style:
                    TextStyle(color: Colors.green),
                  ),
                  Text(
                    "₹ ${balance.balance}",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
                  : Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                crossAxisAlignment:
                CrossAxisAlignment.end,
                children: [
                  Text(
                    "you owe",
                    style: TextStyle(color: Colors.red),
                  ),
                  Text(
                    "₹ ${balance.balance.abs()}",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return BlocProvider(
                      create: (context) =>
                          SettleUpDialogBloc(),
                      child: Builder(
                        builder: (context) => BlocConsumer<
                            SettleUpDialogBloc,
                            SettleUpDialogState>(
                            listener: (context, state) {
                              if (state
                              is SettleUpDialogSuccess) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    content: Text(
                                        "Successfully settled up")));
                                Navigator.pop(context, true);
                                // context
                                //     .read<SettleUpBloc>()
                                //     .add(FetchBalances(groupId));
                              } else if (state
                              is SettleUpDialogFailure) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    content: Text(
                                        "Failed to settle up")));
                                Navigator.pop(context);
                              }
                            }, builder: (context, state) {
                          if (state is SettleUpLoading) {
                            return const AlertDialog(
                              backgroundColor: Colors.white,
                              content: Column(
                                mainAxisSize:
                                MainAxisSize.min,
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text('Processing...'),
                                ],
                              ),
                            );
                          }
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                                  children: [
                                    CircleAvatar(
                                      child: Icon(
                                        Icons
                                            .account_circle_outlined,
                                        size: 40,
                                        color: Colors.red,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Container(
                                      height: 30,
                                      width: 30,
                                      child: Icon(Icons
                                          .arrow_forward),
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    CircleAvatar(
                                      child: Icon(
                                        Icons
                                            .account_circle_outlined,
                                        size: 40,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                    "${balance.balance > 0 ? "${balance.name}  paid  You" : "You  paid  ${balance.name}"}"),
                                SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 30,
                                      child: Center(
                                        child: Text(
                                          "₹",
                                        ),
                                      ),
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                        "${balance.balance.abs()}")
                                  ],
                                )
                              ],
                            ),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context
                                          .read<
                                          SettleUpDialogBloc>()
                                          .add(SettleUp(
                                          groupId:
                                          groupId,
                                          amount: balance
                                              .balance
                                              .abs(),
                                          settleWith:
                                          balance
                                              .userId,
                                          str: balance.balance >
                                              0
                                              ? "paid"
                                              : "received"));
                                    },
                                    child: Text("Confirm"),
                                  ),
                                ],
                              )
                            ],
                          );
                        }),
                      ),
                    );
                  },
                ).then((result) {
                  if (result == true) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content:
                        Text("Successfully settled up"),
                      ),
                    );
                    context
                        .read<SettleUpBloc>()
                        .add(FetchBalances(groupId));
                  }
                });
              },
            ),
          ),
        );
      }),
),
            );
            return Padding(
              padding: EdgeInsets.all(16),
              child: state.balances.isEmpty
                  ? const Center(
                child: Text("All settled up"),
              )
                  : ListView.builder(
                  itemCount: state.balances.length,
                  itemBuilder: (context, index) {
                    final balance = state.balances[index];
                    return Card(
                      elevation: 4.0,
                      margin: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          title: Text(balance.name),
                          trailing: balance.balance > 0
                              ? Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            crossAxisAlignment:
                            CrossAxisAlignment.end,
                            children: [
                              Text(
                                "you are owed",
                                style:
                                TextStyle(color: Colors.green),
                              ),
                              Text(
                                "₹ ${balance.balance}",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                              : Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            crossAxisAlignment:
                            CrossAxisAlignment.end,
                            children: [
                              Text(
                                "you owe",
                                style: TextStyle(color: Colors.red),
                              ),
                              Text(
                                "₹ ${balance.balance.abs()}",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return BlocProvider(
                                  create: (context) =>
                                      SettleUpDialogBloc(),
                                  child: Builder(
                                    builder: (context) => BlocConsumer<
                                        SettleUpDialogBloc,
                                        SettleUpDialogState>(
                                        listener: (context, state) {
                                          if (state
                                          is SettleUpDialogSuccess) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Successfully settled up")));
                                            Navigator.pop(context, true);
                                            // context
                                            //     .read<SettleUpBloc>()
                                            //     .add(FetchBalances(groupId));
                                          } else if (state
                                          is SettleUpDialogFailure) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Failed to settle up")));
                                            Navigator.pop(context);
                                          }
                                        }, builder: (context, state) {
                                      if (state is SettleUpLoading) {
                                        return const AlertDialog(
                                          backgroundColor: Colors.white,
                                          content: Column(
                                            mainAxisSize:
                                            MainAxisSize.min,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator(),
                                              SizedBox(
                                                height: 16,
                                              ),
                                              Text('Processing...'),
                                            ],
                                          ),
                                        );
                                      }
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              children: [
                                                CircleAvatar(
                                                  child: Icon(
                                                    Icons
                                                        .account_circle_outlined,
                                                    size: 40,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 16,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 30,
                                                  child: Icon(Icons
                                                      .arrow_forward),
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 16,
                                                ),
                                                CircleAvatar(
                                                  child: Icon(
                                                    Icons
                                                        .account_circle_outlined,
                                                    size: 40,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            Text(
                                                "${balance.balance > 0 ? "${balance.name}  paid  You" : "You  paid  ${balance.name}"}"),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              children: [
                                                Container(
                                                  height: 30,
                                                  width: 30,
                                                  child: Center(
                                                    child: Text(
                                                      "₹",
                                                    ),
                                                  ),
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                    "${balance.balance.abs()}")
                                              ],
                                            )
                                          ],
                                        ),
                                        actions: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  context
                                                      .read<
                                                      SettleUpDialogBloc>()
                                                      .add(SettleUp(
                                                      groupId:
                                                      groupId,
                                                      amount: balance
                                                          .balance
                                                          .abs(),
                                                      settleWith:
                                                      balance
                                                          .userId,
                                                      str: balance.balance >
                                                          0
                                                          ? "paid"
                                                          : "received"));
                                                },
                                                child: Text("Confirm"),
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    }),
                                  ),
                                );
                              },
                            ).then((result) {
                              if (result == true) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content:
                                    Text("Successfully settled up"),
                                  ),
                                );
                                context
                                    .read<SettleUpBloc>()
                                    .add(FetchBalances(groupId));
                              }
                            });
                          },
                        ),
                      ),
                    );
                  }),
            );
          }
          return Container();
        }),
      ),
      // child:
    );
  }
}
