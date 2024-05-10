class GroupModel{
  final int id;
  final String title;
  bool isExpandable;

  GroupModel({required this.id,required this.title,this.isExpandable = false});
}