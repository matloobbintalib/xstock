import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

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
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: snapshot.data!.map(
                      (row) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(row[0].toString(),style: context.textTheme.bodyLarge?.copyWith(color: Colors.white),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // Name
                            Expanded(child: Text(row[1].toString(),style: context.textTheme.bodyMedium?.copyWith(color: Colors.white))),
                            //Coach
                            Expanded(child: Text(row[2].toString(),style: context.textTheme.bodyMedium?.copyWith(color: Colors.white))),
                            SizedBox(width: 10,),
                            Text(row[3].toString(),style: context.textTheme.bodyMedium?.copyWith(color: Colors.white))
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                    .toList(),
              ),
            );
          }

          return Center(
            child: Text('no data found !!!'),
          );
        },
      ),
    );
  }

  // load csv as string and transform to List<List<dynamic>>
  /*
  [
    ['Name', 'Coach', 'Players'],
    ['Name1', 'Coach1', '5'],
    etc
  ]
  */
  Future<List<List<dynamic>>> _loadCsvData() async {
    final file = new File(path).openRead();
    return await file
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();
  }
}
