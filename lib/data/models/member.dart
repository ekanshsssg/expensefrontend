class Member {
  final String name;
  final String emailId;
  final int memberId;

  Member({required this.name, required this.memberId,required this.emailId});

  factory Member.fromJson(Map<String, dynamic> member) {
    return Member(
      name: member['name'] as String,
      emailId: member['emailId'] as String,
      memberId: member['memberId'] as int,
    );
  }

}
