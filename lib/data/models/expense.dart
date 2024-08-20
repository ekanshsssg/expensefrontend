
class Expenses {
  late List<Expense> expenses;

  Expenses({required this.expenses});

  Expenses.fromJson(Map<String, dynamic> json) {
    // if (json['expenses'] != null) {
    //   expenses = <Expense>[];
    //   json['expenses'].forEach((v) {
    //     expenses!.add(new Expense.fromJson(v));
    //   });
    // }

    expenses = <Expense>[];
    json['expenses'].forEach((v) {
      expenses.add(Expense.fromJson(v));
    });
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.expenses != null) {
  //     data['expenses'] = this.expenses.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class Expense {
  double amount;
  String category;
  String createdAt;
  String description;
  int expenseId;
  int paidBy;
  String paidByName;
  double userAmount;

  Expense(
      {required this.amount,
      required this.category,
      required this.createdAt,
      required this.description,
      required this.expenseId,
      required this.paidBy,
      required this.paidByName,
      required this.userAmount});

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      createdAt: json['created_at'] as String,
      description: json['description'] as String,
      expenseId: json['expense_id'] as int,
      paidBy: json['paid_by'] as int,
      paidByName: json['paid_by_name'] as String,
      userAmount: double.parse((json['userAmount'] as num).toDouble().toStringAsFixed(2)),
      // userAmount: (json['userAmount'] as num).toDouble(),
    );
    // amount = json['amount'];
    // category = json['category'];
    // createdAt = json['created_at'];
    // description = json['description'];
    // expenseId = json['expense_id'];
    // paidBy = json['paid_by'];
    // userAmount = json['userAmount'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['amount'] = this.amount;
  //   data['category'] = this.category;
  //   data['created_at'] = this.createdAt;
  //   data['description'] = this.description;
  //   data['expense_id'] = this.expenseId;
  //   data['paid_by'] = this.paidBy;
  //   data['userAmount'] = this.userAmount;
  //   return data;
  // }
}
