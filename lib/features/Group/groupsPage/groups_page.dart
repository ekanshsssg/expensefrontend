import 'package:expensefrontend/features/Group/createGroup/create_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../groupDetails/group_details_page.dart';
import 'core/group_bloc.dart';



class GroupsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupBloc()..add(FetchGroupsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Groups'),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          color: Colors.white,
          child: BlocBuilder<GroupBloc, GroupState>(
            builder: (context, state) {
              if (state is GroupLoadingState) {
                return Center(child: CircularProgressIndicator());
              } else if (state is GroupLoadedState) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                'Overall Balance',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              state.overallBalance >= 0
                                  ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "You are owed",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "₹ ${(state.overallBalance).toStringAsFixed(2)}",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              )
                                  : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "You owe",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "₹ ${(state.overallBalance.abs()).toStringAsFixed(2)}",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Groups',
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: state.groups.isEmpty
                            ? const Center(
                          child: Text("No groups"),
                        )
                            : ListView.builder(
                          itemCount: state.groups.length,
                          itemBuilder: (context, index) {
                            final group =
                            state.groups[index] as Map<String, dynamic>;

                            return Card(
                              margin: EdgeInsets.only(bottom: 16),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                // contentPadding: EdgeInsets.symmetric(
                                //     horizontal: 16, vertical: 8),
                                // leading: CircleAvatar(
                                //   backgroundColor: Colors.teal.shade100,
                                //   child: Text(
                                //     group['name'][0].toUpperCase(),
                                //     style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                                //   ),
                                // ),
                                title: Text(
                                  group['name'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                // subtitle: Text('Members: ${group['memberCount'] ?? 'N/A'}'),
                                trailing:
                                Icon(Icons.arrow_forward_ios, size: 16),
                                onTap: () async {
                                  // Navigate to group details
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          GroupDetailsPage(
                                            groupId: group['group_id'],
                                            groupName: group['name'],
                                            createdBy: group['created_by'],
                                          ),
                                    ),
                                  );
                                  context
                                      .read<GroupBloc>()
                                      .add(FetchGroupsEvent());
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () async {

                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateGroupPage()));

                            if (!context.mounted) return;

                            if (result == true) {
                              ScaffoldMessenger.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                      content:
                                      Text('Group created successfully.')),
                                );
                              context.read<GroupBloc>()..add(FetchGroupsEvent());
                            } else if(result == false) {
                              ScaffoldMessenger.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                      content: Text('Group creation failed')),
                                );
                            }
                          },
                          child: Text('Create Group'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            shadowColor: Colors.black,
                            elevation: 2,
                            side:
                            BorderSide(width: 1, color: Colors.grey.shade600),
                          )),
                    ],
                  ),
                );
              } else if (state is GroupErrorState) {
                return Center(child: Text('Failed to load groups'));
              }
              return Container();
            },
          ),
        ),

      ),
    );
  }

}



