import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:xstock/modules/home/models/group_data_model.dart';
import 'package:xstock/modules/home/models/item_data_model.dart';

class LoadAndViewCsvPage extends StatelessWidget {
  final String path;
  const LoadAndViewCsvPage({super.key, required this.path}) ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Load and View Csv data'),
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: _loadCsvData(),
        builder: (_, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            List<GroupItem> groupItems = convertToGroupItems(snapshot.data);
            List<Map<String, dynamic>> items = convertToMap(groupItems);
            List<GroupDataModel> list = convertToObjects(groupItemsByValue(items, 'name'));
            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(list[index].groupName),
                        ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 16),
                          shrinkWrap: true,
                            itemCount: list[index].items.length,
                            itemBuilder: (context, innerIndex) {
                              return Row(
                                children: [
                                  Expanded(child: Text(list[index].items[innerIndex].itemName),),
                                  Expanded(child: Text(list[index].items[innerIndex].itemColor),),
                                  Expanded(child: Text(list[index].items[innerIndex].itemCount.toString()),),
                                ],
                              );
                            })
                      ],
                    );
                  }),
            );
          }

          return Center(
            child: Text('no data found !!!'),
          );
        },
      ),
    );
  }

  Future<List<List<dynamic>>> _loadCsvData() async {
    final file = new File(path).openRead();
    return await file
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();
  }

  List<GroupDataModel> convertToObjects(Map<String, List<Map<String, dynamic>>> groupedData) {
    List<GroupDataModel> groups = [];
    groupedData.forEach((groupName, itemList) {
      List<ItemDataModel> items = itemList.map((item) {
        return ItemDataModel(
          itemName: item['type'],
          itemColor: item['color'],
          itemCount: item['count'],
        );
      }).toList();
      groups.add(GroupDataModel(groupName: groupName, items: items));
    });

    return groups;
  }
  List<Map<String, dynamic>> convertToMap(List<GroupItem> groupItems) {
    return groupItems.map((item) {
      return {
        "name": item.name,
        "type": item.type,
        "color": item.color,
        "count": item.count,
      };
    }).toList();
  }
  Map<String, List<Map<String, dynamic>>> groupItemsByValue(
      List<Map<String, dynamic>> items, String key) {
    Map<String, List<Map<String, dynamic>>> groupedData = {};

    for (var item in items) {
      String value = item[key].toString();

      if (groupedData.containsKey(value)) {
        groupedData[value]!.add(item);
      } else {
        groupedData[value] = [item];
      }
    }

    return groupedData;
  }
}

class GroupItem {
  final String name;
  final String type;
  final String color;
  int count;

  GroupItem(this.name, this.type, this.color, this.count);
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'color': color,
      'count': count,
    };
  }
}


List<GroupItem> convertToGroupItems(List<dynamic>? data) {
  List<GroupItem> groupItems = [];

  if (data != null) {
    for (var item in data) {
      if (item is List<dynamic> && item.length >= 4) {
        String groupName = item[0] as String;
        String itemType = item[1] as String;
        String colorValue = (item[2] as String);
        int count = item[3] as int;

        GroupItem groupItem = GroupItem(groupName, itemType, colorValue, count);

        groupItems.add(groupItem);
      }
    }
  }

  return groupItems;
}
