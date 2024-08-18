import 'package:cloud_firestore/cloud_firestore.dart';

enum ItemsStreamsStatus { initial }

class ItemsStreamsState {
  final bool hasData;
  final Stream<QuerySnapshot>? itemsStreams;

  ItemsStreamsState({required this.itemsStreams, required this.hasData});

  factory ItemsStreamsState.initial() {
    return ItemsStreamsState(
        itemsStreams: null,
        hasData: false
    );
  }

  ItemsStreamsState copyWith({
    Stream<QuerySnapshot>? itemsStreams,
    bool? hasData,
  }) {
    return ItemsStreamsState(
        itemsStreams: itemsStreams ?? this.itemsStreams,
        hasData: hasData?? this.hasData
    );
  }
}
