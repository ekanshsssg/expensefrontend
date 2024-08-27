import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/groups_model.dart';
import 'core/create_group_bloc.dart';

class CreateGroupPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateGroupBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Group'),
        ),
        body: BlocConsumer<CreateGroupBloc, CreateGroupState>(
          listener: (context, state) {
            if (state is CreateGroupSuccess) {

              Navigator.pop(context, true);
            } else if (state is CreateGroupFailure) {

              Navigator.pop(context, false);
            }
          },
          builder: (context, state) {
            if (state is CreateGroupLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () {
                      final name = _nameController.text;
                      final description = _descriptionController.text;
                      if (name.isNotEmpty && description.isNotEmpty) {
                        BlocProvider.of<CreateGroupBloc>(context).add(
                            CreateGroupRequested(
                                name: name, description: description));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please enter all fields')),
                        );
                      }
                    },
                    child: Text('Create Group'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
