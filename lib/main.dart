import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:tempcode/riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends ConsumerState<MyHomePage> {
  late LinkedScrollControllerGroup controllersHori;
  late ScrollController scrollController1;
  late ScrollController scrollController2;

  late LinkedScrollControllerGroup controllersVertical;
  late ScrollController scrollController3;
  late ScrollController scrollController4;
  Map<int, bool> visible = {};

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      final DateTime now = DateTime.now();
      // final String formattedDateTime = _formatDateTime(now);
    });
    controllersHori = LinkedScrollControllerGroup();
    scrollController1 = controllersHori.addAndGet();
    scrollController2 = controllersHori.addAndGet();

    controllersVertical = LinkedScrollControllerGroup();
    scrollController3 = controllersVertical.addAndGet();
    scrollController4 = controllersVertical.addAndGet();
  }

  @override
  void dispose() {
    scrollController1.dispose();
    scrollController2.dispose();

    scrollController4.dispose();
    scrollController3.dispose();
    super.dispose();
  }

  Future<void> _showInputDialog(BuildContext context) async {
    String inputText = ref.read(filterProvider.notifier).string;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter a string'),
          content: TextFormField(
            initialValue: inputText,
            onChanged: (value) {
              inputText = value;
            },
            decoration: const InputDecoration(
              labelText: 'String',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                ref.read(filterProvider.notifier).update(inputText);
                Navigator.of(context).pop();
                // Process the inputText here
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var list = List<int>.generate(20, (int index) => index, growable: true);
    var listVertical = List<int>.generate(20, (int index) => index, growable: true);

    text(int e) => Container(
          width: 70,
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 6),
          child: Text("data $e"),
        );

    return Scaffold(
      body: SafeArea(
          child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Padding(
                padding: const EdgeInsets.only(top: 110.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    controller: scrollController3,
                    itemCount: listVertical.length,
                    itemBuilder: (context, index) {
                      return VisibilityDetector(
                          key: Key(index.toString()),
                          onVisibilityChanged: (VisibilityInfo info) {
                            if (info.visibleFraction > .7) {
                              setState(() {
                                visible[index] = true;
                              });
                            } else {
                              setState(() {
                                visible[index] = false;
                              });
                            }
                            List<int> curr = [];
                            visible.forEach((key, value) {
                              if (value) {
                                curr.add(key);
                              }
                            });
                            ref.read(listProvider.notifier).update(curr);
                          },
                          child: SizedBox(height: 70, child: text(listVertical[index])));
                    })),
          ),
          Consumer(
            builder: (context, ref, child) {
              ref.watch<String>(filterProvider);
              final List column = ref.read(filterProvider.notifier).column;
              list = list.where((element) => !column.contains(element)).toList();

              final response = ref.watch(tickerProvider);
              List<List<String>> dataList = [[]];
              response.when(
                data: (data) => dataList = data,
                loading: () => print("loading"),
                error: (error, stackTrace) => print(error),
              );

              return Flexible(
                flex: 3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width:
                        double.parse(list.length.toString()) * 70, //width * no of heading elements
                    child:
                        CustomScrollView(controller: scrollController4, shrinkWrap: true, slivers: [
                      SliverPersistentHeader(
                        delegate: MyHeaderDelegate(list: list),
                        pinned: true,
                      ),
                      for (int i = 0; i < dataList.length; i++)
                        SliverList(
                            delegate: SliverChildListDelegate(
                          [
                            SizedBox(
                              height: 70,
                              child: Row(
                                  children: dataList[i]
                                      .map((e) => SizedBox(width: 70, child: Text(e)))
                                      .toList()),
                            ),
                          ],
                        )),
                    ]),
                  ),
                ),
              );
            },
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showInputDialog(context),
        child: const Icon(Icons.list),
      ),
    );
  }
}

class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  MyHeaderDelegate({required this.list});
  final List<int> list;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    text(int e) => Container(
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 6),
        child: Text("heading $e"));
    return Container(
      color: Colors.white,
      child: ListView(
          primary: false,
          scrollDirection: Axis.horizontal,
          children: list.map((e) {
            return text(e);
          }).toList()),
    );
  }

  @override
  double get maxExtent => 100;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
