import 'package:expensefrontend/features/activity/core/activity_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActivityBloc()..add(GetActivityEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Recent Activities'),
          automaticallyImplyLeading: false,
        ),
        body:
            Container(
              color: Colors.white,
              child: BlocBuilder<ActivityBloc, ActivityState>(builder: (context, state) {
                        if (state is ActivityLoading) {
              return const Center(child: CircularProgressIndicator());
                        } else if (state is ActivityLoadFailure) {
              return const Center(
                child: Text("Failed to load activities"),
              );
                        } else if (state is ActivityLoaded) {
              return state.activities.isEmpty
                  ? const Center(
                      child: Text("No activities done yet."),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: ListView.builder(
                        itemCount: state.activities.length,
                        itemBuilder: (context, index) {
                          final activity = state.activities[index];
                          final date = activity.createdAt.split(" ")[0];
                          final month = activity.createdAt.split(" ")[1];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 55,
                                    width: 55,
                                    color: Colors.grey.shade300,
                                    child: Center(
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                  Expanded(child: Text(activity.description))
                                ],
                              ),
                              // SizedBox(height: 16,),
                              Divider(thickness: 1, color: Colors.grey),
                            ],
                          );
                        },
                      ),
                    );
                        }
                        return Container();
                      }),
            ),
      ),
    );
  }
}
