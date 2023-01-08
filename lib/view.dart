import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({super.key});

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  Future<List<XFile>> allFiles = Future(() => []);
  late final Timer timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    allFiles = Directory("/data/user/0/uz.qmgroup.my_history/cache")
        .list()
        .map((event) => XFile(event.path))
        .toList();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _index++);
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: SafeArea(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: FutureBuilder(
              future: allFiles,
              builder: (context, snapshot) {
                var data = snapshot.data;
                if (data != null) {
                  if (data.isNotEmpty) {
                    return InkWell(
                      onTap: () {
                        setState(() => _index = 0);
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(data[_index % data.length].name),
                            Image.file(
                              File(data[_index % data.length].path),
                              fit: BoxFit.contain,
                              key: UniqueKey(),
                            ),
                          ],
                        )
                      ),
                    );
                  } else {
                    return const Text("No photos yet");
                  }
                } else {
                  // Otherwise, display a loading indicator.
                  return const Center(child: CircularProgressIndicator());
                }
              })),
    );
  }
}
