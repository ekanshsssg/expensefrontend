class Balances {
  late List<Balance> balances;

  Balances({required this.balances});

  Balances.fromJson(Map<String, dynamic> json) {
    balances = <Balance>[];
    json['balances'].forEach((v) {
      balances.add(Balance.fromJson(v));
    });
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.balances != null) {
  //     data['balances'] = this.balances.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class Balance {
  int userId;
  String name;
  double balance;

  Balance({required this.userId, required this.name, required this.balance});

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
        userId: json['userId'] as int,
        name: json['name'] as String,
        balance: double.parse((json['balance'] as num).toDouble().toStringAsFixed(2)));
        // balance: (json['balance'] as num).toDouble());
  }

  // Overriding == operator for comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Balance &&
        other.userId == userId &&
        other.name == name &&
        other.balance == balance;
  }

  // Overriding hashCode to match the == operator
  @override
  int get hashCode => userId.hashCode ^ name.hashCode ^ balance.hashCode;

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['userId'] = this.userId;
  //   data['name'] = this.name;
  //   data['balance'] = this.balance;
  //   return data;
  // }
}
