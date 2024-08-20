import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/member.dart';
import './core/delete_member_bloc.dart';

class DeleteMembersPage extends StatelessWidget {
  final int groupId;

  const DeleteMembersPage({Key? key, required this.groupId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeleteMembersBloc()..add(FetchGroupMembers(groupId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Delete Members'),
        ),
        body: BlocConsumer<DeleteMembersBloc, DeleteMembersState>(
          listener: (context, state) {
            if (state is DeleteMembersSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
              Navigator.pop(context);
            } else if (state is DeleteMembersFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is DeleteMembersLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is DeleteMembersLoaded) {
              return DeleteMembersList(
                groupId: groupId,
                members: state.members,
              );
            }
            else {
              return Center(child: Text('Something went wrong!'));
            }
          },
        ),
      ),
    );
  }
}

class DeleteMembersList extends StatefulWidget {
  final int groupId;
  final List<Member> members;

  DeleteMembersList({
    Key? key,
    required this.groupId,
    required this.members,
  }) : super(key: key);

  @override
  DeleteMembersListState createState() => DeleteMembersListState();
}

class DeleteMembersListState extends State<DeleteMembersList> {
  final List<int> _selectedMembers = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.members.length,
            itemBuilder: (context, index) {
              final member = widget.members[index];
              return CheckboxListTile(
                title: Text(member.name),
                subtitle: Text(member.emailId),
                value: _selectedMembers.contains(member.memberId),
                onChanged: (bool? selected) {
                  setState(() {
                    if (selected!) {
                      _selectedMembers.add(member.memberId);
                    } else {
                      _selectedMembers.remove(member.memberId);
                    }
                  });
                },
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_selectedMembers.isNotEmpty) {
              context.read<DeleteMembersBloc>().add(
                    DeleteSelectedMembers(
                      groupId: widget.groupId,
                      selectedMembers: _selectedMembers,
                    ),
                  );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please select members to delete'),
                ),
              );
            }
          },
          child: Text('Delete Members'),
        ),
      ],
    );
  }
}
