class GroupModel {
  final String id;
  final String userId;
  final String name;
  final String createdAt;
  bool isExpandable;
  bool isSelected;

  GroupModel(
      {required this.id,
      required this.userId,
      required this.name,
      required this.createdAt,
      this.isExpandable = false,
      this.isSelected = false});

  Map<String, dynamic> toMap() {
    return {'id': id, 'user_id': userId, 'name': name, 'created_at': createdAt};
  }

  // Convert a Map object into a User object
  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      name: map['name'],
      userId: map['user_id'],
      id: map['id'],
      createdAt: map['created_at'],
    );
  }
}
