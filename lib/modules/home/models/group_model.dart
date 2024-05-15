class GroupModel{
  final String id;
  final String userId;
  final String title;
  bool isExpandable;
  bool isSelected;

  GroupModel({required this.id,required this.userId,required this.title,this.isExpandable = false,this.isSelected = false});
}