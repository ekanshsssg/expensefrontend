class Activities {
  late List<Activity> activities;

  Activities({required this.activities});

  Activities.fromJson(Map<String, dynamic> json) {
    activities = <Activity>[];
    json['activities'].forEach((v) {
      activities.add(Activity.fromJson(v));
    });
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.activities != null) {
  //     data['activities'] = this.activities!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class Activity {
  String createdAt;
  String description;

  Activity({required this.createdAt, required this.description});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
        createdAt: json['created_at'] as String,
        description: json['description'] as String);
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['created_at'] = this.createdAt;
  //   data['description'] = this.description;
  //   return data;
  // }
}
