class AccountTitleModel{
  final int id;
  final String name;
  final String email;
  bool isSelected;

  AccountTitleModel({required this.id,required this.name,this.isSelected = false, required this.email});
}