import 'package:expensefrontend/features/Group/addMembersToGroup/core/add_members_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddMembers extends StatelessWidget {
  final int groupId;

  const AddMembers({Key? key, required this.groupId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddMembersBloc(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Add Members'),
          ),
          body: BlocConsumer<AddMembersBloc, AddMembersState>(
            listener: (context, state) {
              if (state is AddMembersSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Members added successfully'),
                  ),
                );
                Navigator.pop(context);
              } else if (state is AddMembersFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                  ),
                );
              } else if (state is YouAreAlreadyPresent) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        const Text('You are already a member of this group'),
                  ),
                );
              } else if (state is YouAreAlreadySelected) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Member already selected'),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller:
                          context.read<AddMembersBloc>().emailController,
                      decoration: InputDecoration(
                        labelText: 'Search by email',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            final email = context
                                .read<AddMembersBloc>()
                                .emailController
                                .text;
                            if (email.isNotEmpty) {
                              context
                                  .read<AddMembersBloc>()
                                  .add(SearchMembers(email,groupId));
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    if (state is AddMembersLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (state is AddMembersSelected)
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.selectedMembers.length,
                          itemBuilder: (context, index) {
                            final member = state.selectedMembers[index];
                            return ListTile(
                              title: Text(member.name),
                              subtitle: Text(member.emailId),
                              trailing: IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  context.read<AddMembersBloc>().add(
                                        RemoveMemberFromSelection(
                                            member: member),
                                      );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ElevatedButton(
                      onPressed: ((state is AddMembersSelected) && state.selectedMembers.isNotEmpty) ? () {
                        context
                            .read<AddMembersBloc>()
                            .add(ConfirmAddMembers(groupId: groupId));
                      } : null,
                      child: const Text('Add these members to group'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
