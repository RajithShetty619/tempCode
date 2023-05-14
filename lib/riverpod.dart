import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class FilterString extends StateNotifier<String> {
  FilterString() : super('');
  String _string = '';

  String get string => _string;
  List<int> get column {
    if (string.isNotEmpty) {
      var data = string.split(',').map((e) => int.parse(e)).toList();
      return data;
    }
    return [];
  }

  void update(String val) {
    state = val;
    _string = val;
  }
}

final filterProvider = StateNotifierProvider<FilterString, String>((ref) {
  return FilterString();
});

final listProvider = StateNotifierProvider((ref) => ListNotifier());

class ListNotifier extends StateNotifier<List<int>> {
  ListNotifier() : super([]);

  void update(List<int> curr) {
    state = curr;
  }
}

final tickerProvider = StreamProvider.autoDispose<List<List<String>>>((ref) async* {
  while (true) {
    await Future.delayed(const Duration(milliseconds: 500));
    final curr = ref.read(listProvider.notifier).state;
    var time = DateFormat('ss').format(DateTime.now());
    final filter = ref.read(filterProvider.notifier).column;

    List<List<String>> list = List<List<String>>.generate(
        20,
        (int index) => List<String>.generate(20, (int i) {
              if (curr.contains(index)) {
                return "$index $i $time";
              } else {
                return index.toString();
              }
            }, growable: true),
        growable: true);
    list = list.map((row) {
      for (var i = filter.length - 1; i >= 0; i--) {
        row.removeAt(filter[i]);
      }
      return row;
    }).toList();
    yield list;
  }
});
